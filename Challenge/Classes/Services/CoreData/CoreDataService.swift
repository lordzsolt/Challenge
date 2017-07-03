 //
 //  CoreDataService.swift
 //  Challenge
 //
 //  Created by Zsolt Kovacs on 6/23/17.
 //  Copyright © 2017 iOSmith. All rights reserved.
 //

 import Foundation
 import CoreData

 class CoreDataService {
    private let container: NSPersistentContainer

    private let queue = DispatchQueue(label: String(describing: CoreDataService.self))
    private var operations: Set<BlockOperation> = []

    init(container: NSPersistentContainer) {
        self.container = container
    }

    // MARK: - User

    func addUsers(from details: Array<Dictionary<String, Any>>) {
        performInsert { [unowned self] operation in
            let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            context.parent = self.container.viewContext

            for detail in details {
                if operation.isCancelled {
                    break
                }
                self.addUser(from: detail, in: context)
            }

            self.save(context: context)
        }
    }

    private func addUser(from details: Dictionary<String, Any>, in context: NSManagedObjectContext) {
        guard let identifier = details[ApiConstants.Key.Common.identifier] as? Int else {
            return
        }

        var user: User? = context.retriveEntity(identifier: identifier)
        if user == nil {
            let entity = NSEntityDescription.insertNewObject(forEntityName: String(describing: User.self), into: context) as! User
            entity.id = Int64(identifier)
            entity.address = NSEntityDescription.insertNewObject(forEntityName: String(describing: Address.self), into: context) as? Address
            entity.company = NSEntityDescription.insertNewObject(forEntityName: String(describing: Company.self), into: context) as? Company
            user = entity
        }

        user?.update(with: details)
    }


    // MARK: - Post

    func addPosts(from details: Array<Dictionary<String, Any>>) {
        performInsert { [unowned self] operation in
            let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            context.parent = self.container.viewContext

            for detail in details {
                if operation.isCancelled {
                    break
                }
                self.addPost(from: detail, in: context)
            }

            self.save(context: context)
        }
    }

    private func addPost(from details: Dictionary<String, Any>, in context: NSManagedObjectContext) {
        guard let identifier = details[ApiConstants.Key.Common.identifier] as? Int else {
            return
        }

        var post: Post? = context.retriveEntity(identifier: identifier)
        if post == nil {
            let entity = NSEntityDescription.insertNewObject(forEntityName: String(describing: Post.self), into: context) as! Post
            entity.id = Int64(identifier)

            if let userId = details[ApiConstants.Key.Post.userId] as? Int {
                connect(post: entity, toUser: userId, in: context)
            }
            post = entity
        }

        post?.update(with: details)
    }

    private func connect(post: Post, toUser identifier: Int, in context: NSManagedObjectContext) {
        var user: User? = context.retriveEntity(identifier: identifier)
        if user == nil {
            // User does not yet exist in cache, create a stub User
            let entity = NSEntityDescription.insertNewObject(forEntityName: String(describing: User.self), into: context) as! User
            entity.id = Int64(identifier)
            user = entity
        }

        post.user = user
    }


    // MARK: - Album

    func addAlbums(from details: Array<Dictionary<String, Any>>) {
        performInsert { [unowned self] operation in
            let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            context.parent = self.container.viewContext

            for detail in details {
                if operation.isCancelled {
                    break
                }
                self.addAlbum(from: detail, in: context)
            }

            self.save(context: context)
        }
    }

    private func addAlbum(from details: Dictionary<String, Any>, in context: NSManagedObjectContext) {
        guard let identifier = details[ApiConstants.Key.Common.identifier] as? Int else {
            return
        }

        var album: Album? = context.retriveEntity(identifier: identifier)
        if album == nil {
            let entity = NSEntityDescription.insertNewObject(forEntityName: String(describing: Album.self), into: context) as! Album
            entity.id = Int64(identifier)
            if let userId = details[ApiConstants.Key.Album.userId] as? Int {
                connect(album: entity, toUser: userId, in: context)
            }
            album = entity
        }

        album?.update(with: details)
    }

    private func connect(album: Album, toUser identifier: Int, in context: NSManagedObjectContext) {
        var user: User? = context.retriveEntity(identifier: identifier)
        if user == nil {
            // User does not yet exist in cache, create a stub User
            let entity = NSEntityDescription.insertNewObject(forEntityName: String(describing: User.self), into: context) as! User
            entity.id = Int64(identifier)
            user = entity
        }

        album.user = user
    }

    // MARK: - Photo

    func addPhotos(from details: Array<Dictionary<String, Any>>) {
        performInsert { [unowned self] operation in
            let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            context.parent = self.container.viewContext

            for detail in details {
                if operation.isCancelled {
                    break
                }
                self.addPhoto(from: detail, in: context)
            }

            self.save(context: context)
        }
    }

    private func addPhoto(from details: Dictionary<String, Any>, in context: NSManagedObjectContext) {
        guard let identifier = details[ApiConstants.Key.Common.identifier] as? Int else {
            return
        }

        var photo: Photo? = context.retriveEntity(identifier: identifier)
        if photo == nil {
            let entity = NSEntityDescription.insertNewObject(forEntityName: String(describing: Photo.self), into: context) as! Photo
            entity.id = Int64(identifier)
            if let albumId = details[ApiConstants.Key.Photo.albumId] as? Int {
                connect(photo: entity, toAlbum: albumId, in: context)
            }
            photo = entity
        }

        photo?.update(with: details)
    }

    private func connect(photo: Photo, toAlbum identifier: Int, in context: NSManagedObjectContext) {
        var album: Album? = context.retriveEntity(identifier: identifier)
        if album == nil {
            // User does not yet exist in cache, create a stub Album
            let entity = NSEntityDescription.insertNewObject(forEntityName: String(describing: Album.self), into: context) as! Album
            entity.id = Int64(identifier)
            album = entity
        }

        photo.album = album
    }


    // MARK: - Helpers

    func cancelRunningOperations() {
        queue.sync { [weak self] in
            guard let operations = self?.operations else { return }
            for operation in operations {
                operation.cancel()
            }
        }
    }

    private func performInsert(_ insert: @escaping (BlockOperation) -> Void) {
        let operation = BlockOperation()

        operation.addExecutionBlock { [weak operation] in
            if let operation = operation {
                insert(operation)
            }
        }

        operation.completionBlock = { [weak self, weak operation] in
            guard let operation = operation else { return }
            self?.operations.remove(operation)
        }

        let _ = queue.sync { [weak self] in
            self?.operations.insert(operation)
        }

        operation.start()
    }
    
    private func save(context: NSManagedObjectContext) {
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        do {
            try context.save()
        }
        catch {
            let nserror = error as NSError
            fatalError("Failed to save context: \(nserror), \(nserror.userInfo)")
        }

    }
 }
