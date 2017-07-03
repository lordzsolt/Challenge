//
//  DataProvider.swift
//  Challenge
//
//  Created by Zsolt Kovacs on 6/24/17.
//  Copyright © 2017 iOSmith. All rights reserved.
//

import UIKit
import CoreData

class DataProvider {
    private let apiService = ApiService()

    private let persistencyService: CoreDataService
    private let persistentContainer: NSPersistentContainer

    init(container: NSPersistentContainer) {
        persistentContainer = container
        persistencyService = CoreDataService(container: persistentContainer)
    }


    /// Simultaneously reload users, posts, albums and photos from server
    ///
    /// If either request fails, the whole request will be considered a failure
    ///
    /// - Parameter completion: The completion block to be called once all requests finish
    func reloadData(_ completion: @escaping (Response<Void>) -> Void) {
        NetworkActivityIndicator.push()

        DispatchQueue.global(qos: .utility).async {

            // We'll download new data, so there's no point in continuing to save the old one
            self.persistencyService.cancelRunningOperations()

            let requestGroup = DispatchGroup()
            var globalError: NSError?

            requestGroup.enter()
            self.apiService.loadUsers { response in
                switch response {
                case .success(let json): self.persistencyService.addUsers(from: json)
                case .failed(let error): globalError = error
                }
                requestGroup.leave()
            }

            requestGroup.enter()
            self.apiService.loadPosts { response in
                switch response {
                case .success(let json): self.persistencyService.addPosts(from: json)
                case .failed(let error): globalError = error
                }
                requestGroup.leave()
            }

            requestGroup.enter()
            self.apiService.loadAlbums { response in
                switch response {
                case .success(let json): self.persistencyService.addAlbums(from: json)
                case .failed(let error): globalError = error
                }
                requestGroup.leave()
            }

            requestGroup.enter()
            self.apiService.loadPhotos { response in
                switch response {
                case .success(let json): self.persistencyService.addPhotos(from: json)
                case .failed(let error): globalError = error
                }
                requestGroup.leave()
            }

            // TODO: Maybe move the parsing/saving to CoreData outside the requestGroup
            // Wait for all requests to finish or timeout after 60 seconds
            let finished = requestGroup.wait(timeout: .now() + 60)

            NetworkActivityIndicator.pop()

            guard finished == .success else {
                completion(.failed(NSError.networkError(with: .timeout)))
                return
            }

            if let error = globalError {
                completion(.failed(error))
                return
            }

            try! self.persistentContainer.viewContext.save()
            completion(.success())
        }
    }
}
