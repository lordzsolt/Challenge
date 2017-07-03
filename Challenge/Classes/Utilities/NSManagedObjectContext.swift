//
//  NSManagedObjectContext.swift
//  Challenge
//
//  Created by Zsolt Kovacs on 6/30/17.
//  Copyright © 2017 iOSmith. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    func retriveEntity<T: NSFetchRequestResult>(identifier: Int) -> T? {
        let request = NSFetchRequest<T>(entityName: String(describing: T.self))
        request.predicate = NSPredicate(format: "\(ApiConstants.Key.Common.identifier) == \(identifier)")
        request.fetchLimit = 1

        guard let result = try? fetch(request) else {
            return nil
        }

        return result.first
    }

}
