//
//  Photo+CoreDataClass.swift
//  Challenge
//
//  Created by Zsolt Kovacs on 6/23/17.
//  Copyright © 2017 iOSmith. All rights reserved.
//

import Foundation
import CoreData

@objc(Photo)
public class Photo: NSManagedObject {
    func update(with details: Dictionary<String, Any>) {
        if let newValue = details[ApiConstants.Key.Photo.title] as? String, title != newValue {
            title = newValue
        }

        if let newValue = details[ApiConstants.Key.Photo.url] as? String, url != newValue {
            url = newValue
        }

        if let newValue = details[ApiConstants.Key.Photo.thumbnailUrl] as? String, newValue != thumbnailUrl {
            thumbnailUrl = newValue
        }
    }
}
