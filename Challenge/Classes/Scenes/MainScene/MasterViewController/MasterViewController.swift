//
//  MainViewController.swift
//  PricingBasket
//
//  Created by Zsolt Kovacs on 6/3/17.
//  Copyright © 2017 iOSmith. All rights reserved.
//

import UIKit
import CoreData

protocol MasterViewControllerDelegate: class {
    func masterViewController(_ masterViewController: MasterViewController, didSelect post: Post?)
}

class MasterViewController: UITableViewController {
    var context: NSManagedObjectContext?
    weak var selectionDelegate: MasterViewControllerDelegate?

    fileprivate var resultsController: NSFetchedResultsController<Post>?
    fileprivate var searchController: UISearchController?

    fileprivate var searchQuery: String? {
        didSet {
            reloadData(query: searchQuery)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Strings.Main.title

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        tableView.register(PostCell.self, forCellReuseIdentifier: PostCell.reuseIdentifier)

        initSearchController()
        self.initFetchResults()

        // Resign first responder when application enters background; Otherwise some constraints will break on the searchBar
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationWillResignActive, object: nil, queue: nil) { [weak self] _ in
            self?.searchController?.searchBar.resignFirstResponder()
            self?.searchController?.searchBar.showsCancelButton = false
        }

        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSManagedObjectContextDidSave, object: nil, queue: nil) { [weak self] notification in
            guard let userInfo = notification.userInfo else {
                return
            }

            let inserted = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>
            let updated = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>
            let deleted = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>

            var shouldRefresh = false

            defer {
                if shouldRefresh {
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            }

            if inserted?.containsObjects(of: Post.self) == true {
                shouldRefresh = true
            }

            if !shouldRefresh && updated?.containsObjects(of: Post.self) == true {
                shouldRefresh = true
            }

            if !shouldRefresh && deleted?.containsObjects(of: Post.self) == true {
                shouldRefresh = true
            }
        }
    }

    // MARK: - UITableView

    override func numberOfSections(in tableView: UITableView) -> Int {
        return resultsController?.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsController?.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.reuseIdentifier, for: indexPath)

        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        cell.detailTextLabel?.numberOfLines = 0

        if let post = resultsController?.sections?[indexPath.section].objects?[indexPath.row] as? Post {
            cell.textLabel?.text = post.title
            cell.detailTextLabel?.text = post.user?.email
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard case .delete = editingStyle else {
            return
        }

        if let post = resultsController?.sections?[indexPath.section].objects?[indexPath.row] as? Post {
            context?.delete(post)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let post = resultsController?.sections?[indexPath.section].objects?[indexPath.row] as? Post {
            selectionDelegate?.masterViewController(self, didSelect: post)
        }
    }
}

extension MasterViewController: UISearchResultsUpdating {
    fileprivate func initSearchController() {
        definesPresentationContext = true

        let searchController = UISearchController(searchResultsController: nil)
        self.searchController = searchController
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false

        searchController.searchBar.autocorrectionType = .no
        searchController.searchBar.autocapitalizationType = .none

        tableView.tableHeaderView = searchController.searchBar
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: searchController.searchBar.frame.height, left: 0, bottom: 0, right: 0)
    }

    func updateSearchResults(for searchController: UISearchController) {
        searchController.searchBar.setShowsCancelButton(searchController.searchBar.isFirstResponder, animated: true)
        searchQuery = searchController.searchBar.text
    }
}

extension MasterViewController: NSFetchedResultsControllerDelegate {
    fileprivate func initFetchResults() {
        let request = NSFetchRequest<Post>(entityName: String(describing: Post.self))
        request.sortDescriptors = [NSSortDescriptor(key: ApiConstants.Key.Common.identifier, ascending: true)]

        if let context = context {
            resultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            resultsController?.delegate = self
        } else {
            fatalError("MainViewController.context property must be set before viewDidLoad")
        }

        reloadData(query: nil)
    }

    fileprivate func refreshVisibleIndexes() {
        guard let visibleIndex = tableView.indexPathsForVisibleRows else {
            return
        }

        for index in visibleIndex {
            if let user = (resultsController?.sections?[index.section].objects?[index.row] as? Post)?.user {
                context?.refresh(user, mergeChanges: true)
            }
        }
    }

    fileprivate func reloadData(query: String?) {
        if let query = query, !query.characters.isEmpty {
            resultsController?.fetchRequest.predicate = NSPredicate(format: "\(ApiConstants.Key.Post.title) CONTAINS[cd] %@", query)
        } else {
            resultsController?.fetchRequest.predicate = nil
        }

        do {
            try resultsController?.performFetch()
        }
        catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }

        tableView.reloadData()
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert: tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete: tableView.deleteRows(at: [indexPath!], with: .fade)
        default: break
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
