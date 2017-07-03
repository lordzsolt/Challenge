//
//  ApiService.swift
//  Challenge
//
//  Created by Zsolt Kovacs on 6/23/17.
//  Copyright © 2017 iOSmith. All rights reserved.
//

import Foundation

class ApiService {
    private var loadUsersTask: URLSessionDataTask?
    private var loadPostsTask: URLSessionDataTask?
    private var loadAlbumsTask: URLSessionDataTask?
    private var loadPhotosTask: URLSessionDataTask?

    deinit {
        loadUsersTask?.cancel()
        loadPostsTask?.cancel()
        loadAlbumsTask?.cancel()
        loadPhotosTask?.cancel()
    }

    func loadUsers(_ completion: @escaping (Response<Array<Dictionary<String, Any>>>) -> Void) {
        loadUsersTask = task(with: ApiConstants.Url.Users, completion: completion)
        loadUsersTask?.resume()
    }

    func loadPosts(_ completion: @escaping (Response<Array<Dictionary<String, Any>>>) -> Void) {
        loadPostsTask = task(with: ApiConstants.Url.Posts, completion: completion)
        loadPostsTask?.resume()
    }

    func loadAlbums(_ completion: @escaping (Response<Array<Dictionary<String, Any>>>) -> Void) {
        loadAlbumsTask = task(with: ApiConstants.Url.Albums, completion: completion)
        loadAlbumsTask?.resume()
    }

    func loadPhotos(_ completion: @escaping (Response<Array<Dictionary<String, Any>>>) -> Void) {
        loadPhotosTask = task(with: ApiConstants.Url.Photos, completion: completion)
        loadPhotosTask?.resume()
    }

    private func task<T>(with path: String, completion: @escaping (Response<T>) -> Void) -> URLSessionDataTask? {
        guard let url = URL(string: path) else {
            return nil
        }

        return URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                if !error.isRequestCancelled {
                    completion(.failed(NSError.networkError(with: .general)))
                }
                return
            }

            guard let data = data else {
                completion(.failed(NSError.networkError(with: .invalidResponse)))
                return
            }

            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
                completion(.failed(NSError.networkError(with: .invalidResponse)))
                return
            }

            guard let typedJson = json as? T else {
                completion(.failed(NSError.networkError(with: .invalidResponse)))
                return
            }

            completion(.success(typedJson))
        }
    }
}

fileprivate extension Error {
    var isRequestCancelled: Bool {
        let error = self as NSError
        return error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled
    }
}
