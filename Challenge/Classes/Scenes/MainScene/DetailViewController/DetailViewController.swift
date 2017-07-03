//
//  DetailViewController.swift
//  Challenge
//
//  Created by Zsolt Kovacs on 6/26/17.
//  Copyright © 2017 iOSmith. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    var post: Post? {
        didSet {
            DispatchQueue.main.async {
                self.titleLabel.text = self.post?.title
                self.detailLabel.text = self.post?.body
                self.albumsController.user = self.post?.user
            }
        }
    }
    var context: NSManagedObjectContext? {
        didSet {
            albumsController.context = context
        }
    }

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    private weak var albumsController: AlbumsCollectionViewController!

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        albumsController = childViewControllers.first as! AlbumsCollectionViewController
        albumsController.context = context

        view.backgroundColor = UIColor.white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)

        headerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true

        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: nil, queue: nil) { [weak self] notification in
            guard let post = self?.post else {
                return
            }

            guard let userInfo = notification.userInfo else {
                return
            }

            let deleted = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>
            let updated = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>

            if deleted?.contains(post) == true {
                DispatchQueue.main.async {
                    self?.post = nil
                }
            }

            if updated?.first(where:{ ($0 as? Post)?.id == post.id }) != nil {
                self?.post = self?.context?.object(with: post.objectID) as? Post
            }
        }
    }
}
