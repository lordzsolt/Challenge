//
//  Post+CoreDataClass.swift
//  Challenge
//
//  Created by Zsolt Kovacs on 6/23/17.
//  Copyright © 2017 iOSmith. All rights reserved.
//

import Foundation
import CoreData

@objc(Post)
public class Post: NSManagedObject {
    func update(with details: Dictionary<String, Any>) {
        if let newValue = details[ApiConstants.Key.Post.title] as? String, title != newValue {
            title = newValue
        }

        if let newValue = details[ApiConstants.Key.Post.body] as? String, body != newValue {
            body = newValue
        }
    }
}
