//
//  AlbumsCollectionViewController.swift
//  Challenge
//
//  Created by Zsolt Kovacs on 6/26/17.
//  Copyright © 2017 iOSmith. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = PhotoCell.reuseIdentifier
private let headerReuseIdentifier = AlbumHeaderView.reuseIdentifier

class AlbumsCollectionViewController: UICollectionViewController {

    var user: User? {
        didSet {
            albums = user?.albums?.array as? [Album]
        }
    }

    var context: NSManagedObjectContext?

    fileprivate var albums: [Album]? {
        didSet {
            expandedSections = []

            DispatchQueue.main.async {
                self.collectionView?.setContentOffset(CGPoint.zero, animated: false)
                self.collectionView?.reloadData()
            }
        }
    }

    fileprivate var expandedSections: Set<Int> = []

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)

            // This should make the headers stick, but for some reason
            layout.sectionHeadersPinToVisibleBounds = true
        }

        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSManagedObjectContextDidSave, object: nil, queue: nil) { [weak self] notification in
            guard let user = self?.user else {
                return
            }

            guard let userInfo = notification.userInfo else {
                return
            }

            var shouldRefresh = false

            defer {
                if shouldRefresh {
                    self?.refreshAlbums()
                }
            }

            let updated = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>

            if updated?.first(where:{ ($0 as? User)?.id == user.id }) != nil {
                self?.user = self?.context?.object(with: user.objectID) as? User
            }

            if let updatedSet = updated {
                shouldRefresh = self?.setHasOverlapWithAlbums(updatedSet) == true
            }

            if !shouldRefresh, let deleted = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject> {
                shouldRefresh = self?.setHasOverlapWithAlbums(deleted) == true
            }
        }
    }

    // MARK: - Helpers

    private func setHasOverlapWithAlbums(_ set: Set<NSManagedObject>) -> Bool {
        let albumIds = albums?.map { $0.id }

        return set.contains(where: {
            if let id = ($0 as? Album)?.id {
                return albumIds?.contains(id) == true
            }
            return false
        })
    }

    private func refreshAlbums() {
        if let albums = albums {
            for album in albums {
                context?.refresh(album, mergeChanges: true)
            }

            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }

    fileprivate func configureExpandButton(of headerView: AlbumHeaderView, in section: Int) {
        let title = expandedSections.contains(section) ? Strings.Details.sectionExpanded : Strings.Details.sectionCollapsed
        headerView.expandButton.setTitle(title, for: .normal)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.collectionView?.collectionViewLayout.invalidateLayout()
        })

    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return albums?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard expandedSections.contains(section) else {
            return 0
        }
        let count = albums?[section].photos?.array.count ?? 0
        return count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCell

        if let photo = albums?[indexPath.section].photos?.array[indexPath.row] as? Photo {
            if let thumbnail = photo.thumbnailUrl {
                cell.imageView.setImageFrom(remotePath: thumbnail)
            }
        }
    
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! AlbumHeaderView
        headerView.delegate = self

        headerView.tag = indexPath.section
        headerView.titleLabel.text = albums?[indexPath.section].title
        configureExpandButton(of: headerView, in: indexPath.section)

        return headerView
    }


    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return false
    }
}


extension AlbumsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let title = albums?[section].title else {
            return CGSize.zero
        }

        let height = AlbumHeaderView.preferredHeight(with: title, constrainedTo: collectionView.frame.width)
        return CGSize(width: collectionView.frame.width, height: height)
    }
}


extension AlbumsCollectionViewController: AlbumHeaderViewDelegate {
    func headerViewExpandButtonTapped(_ headerView: AlbumHeaderView) {
        let section = headerView.tag

        if expandedSections.contains(section) {
            expandedSections.remove(section)
        } else {
            expandedSections.insert(section)
        }

        configureExpandButton(of: headerView, in: section)

        // I have to do reload without animation. reloadSections() somehow kills the sectionHeadersPinToVisibleBounds. No clue why.
        collectionView?.reloadData()
                collectionView?.reloadSections([section])
    }
}
