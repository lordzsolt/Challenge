//
//  Album+CoreDataClass.swift
//  Challenge
//
//  Created by Zsolt Kovacs on 6/23/17.
//  Copyright © 2017 iOSmith. All rights reserved.
//

import Foundation
import CoreData

@objc(Album)
public class Album: NSManagedObject {
    func update(with details: Dictionary<String, Any>) {
        if let newTitle = details[ApiConstants.Key.Photo.title] as? String, title != newTitle {
            title = newTitle
        }
    }
}
