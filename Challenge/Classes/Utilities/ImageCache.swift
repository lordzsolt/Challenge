//
//  ImageCache.swift
//  Challenge
//
//  Created by Zsolt Kovacs on 6/27/17.
//  Copyright © 2017 iOSmith. All rights reserved.
//

import UIKit

extension UIImageView {
    func setImageFrom(remotePath: String) {
        ImageCache.shared.set(imageWith: remotePath, to: self)
    }
}


// I assumed the requirement was to write my own image cache. While I did write my own, it's most likely nowhere near as good as an open source one.
// If I'm allowed, I'd just replace this with Kingfisher
class ImageCache: NSObject {
    static let shared = ImageCache()

    var maxConcurrentDownloads = 5

    private var session: URLSession? = nil

    fileprivate let cache = NSCache<NSString, UIImage>()

    fileprivate let taskQueue = DispatchQueue(label: String(describing: ImageCache.self) + "task")
    fileprivate var activeTasks: Dictionary<UIImageView, URLSessionDownloadTask> = [:]
    fileprivate var lowPriorityTasks: Set<URLSessionDownloadTask> = []

    fileprivate let mappingQueue = DispatchQueue(label: String(describing: ImageCache.self) + "mapping")
    fileprivate let mapping = TwoWayMap<UIImageView, NSString>()

    private override init() {
        super.init()
        session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
    }

    fileprivate func set(imageWith path: String, to imageView: UIImageView) {
        guard let session = self.session else {
            fatalError("Session is not initialized")
        }

        if let image = cache.object(forKey: path as NSString) {
            imageView.image = image
            return
        }

        let filePath = filePathToImageAt(url: path)
        if let image = UIImage(contentsOfFile: filePath.path) {
            imageView.image = image
            return
        }

        let pathString = path as NSString

        guard let url = URL(string: path) else {
            print("Invalid URL")
            return
        }

        taskQueue.sync {
            if activeTasks.count > maxConcurrentDownloads, let task = activeTasks[imageView] {
                task.priority = URLSessionTask.lowPriority
                activeTasks.removeValue(forKey: imageView)
                lowPriorityTasks.insert(task)
            }
        }

        mappingQueue.sync {
            mapping.set(object: pathString, forKey: imageView)
        }

        let task = session.downloadTask(with: url)

        task.priority = URLSessionTask.highPriority

        taskQueue.sync {
            activeTasks[imageView] = task
        }

        task.resume()
    }

    // MARK: - File Cache

    fileprivate func save(image: UIImage, withPath path: String) {
        if let data = UIImagePNGRepresentation(image) {
            var filePath = filePathToImageAt(url: path)
            if !FileManager.default.fileExists(atPath: imagesDirectory().path) {
                try? FileManager.default.createDirectory(at: imagesDirectory(), withIntermediateDirectories: false, attributes: nil)
            }

            try? data.write(to: filePath)

            // We don't want to back up this image cache
            var resourceValue = URLResourceValues()
            resourceValue.isExcludedFromBackup = true
            try? filePath.setResourceValues(resourceValue)
        }
    }

    fileprivate func filePathToImageAt(url: String) -> URL {
        let filename = String(url.hashValue) + ".png"
        return imagesDirectory().appendingPathComponent(filename)
    }

    fileprivate func imagesDirectory() -> URL {
        return documentDirectory().appendingPathComponent("Images")
    }

    private func documentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

extension ImageCache: URLSessionDelegate, URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {

        taskQueue.sync { () -> Void in
            self.lowPriorityTasks.remove(downloadTask)
        }

        guard let data = try? Data(contentsOf: location) else {
            print("Downloaded date was empty")
            return
        }

        guard let image = UIImage(data: data) else {
            print("Unable to convert downloaded data to image")
            return
        }

        guard let path = downloadTask.originalRequest?.url?.absoluteString else {
            print("Download finished with non-existing path")
            return
        }

        let pathString = path as NSString

        defer {
            cache.setObject(image, forKey: pathString)
            save(image: image, withPath: pathString as String)
        }

        mappingQueue.sync {
            // Ensure the imageView wasn't reused for another path
            if let imageView = mapping.key(forObject: pathString) {
                if mapping.object(forKey: imageView) == pathString {
                    mapping.removeObject(forKey: imageView)

                    DispatchQueue.main.async {
                        imageView.image = image
                    }

                    taskQueue.sync { () -> Void in
                        self.activeTasks.removeValue(forKey: imageView)
                    }
                }
            }
        }
    }
}
