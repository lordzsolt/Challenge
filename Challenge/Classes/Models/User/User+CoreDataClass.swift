//
//  User+CoreDataClass.swift
//  Challenge
//
//  Created by Zsolt Kovacs on 6/23/17.
//  Copyright © 2017 iOSmith. All rights reserved.
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {
    func update(with details: Dictionary<String, Any>) {
        if let newValue = details[ApiConstants.Key.User.name] as? String, name != newValue {
            name = newValue
        }

        if let newValue = details[ApiConstants.Key.User.username] as? String, username != newValue {
            username = newValue
        }

        if let newValue = details[ApiConstants.Key.User.email] as? String, email != newValue {
            // HACK 01: I'm not at all certain about the correctness of this. I need this to mark the post as modified, so the MasterViewController will reload the object.
            if posts != nil {
                for post in posts! {
                    (post as! Post).willChangeValue(forKey: "user")
                }
            }
            
            email = newValue

            if posts != nil {
                for post in posts! {
                    (post as! Post).didChangeValue(forKey: "user")
                }
            }
        }

        if let newValue = details[ApiConstants.Key.User.phone] as? String, phone != newValue {
            phone = newValue
        }

        if let newValue = details[ApiConstants.Key.User.website] as? String, website != newValue {
            website = newValue
        }

        if let address = details[ApiConstants.Key.User.address] as? Dictionary<String, Any> {
            self.address?.update(with: address)
        }
        if let company = details[ApiConstants.Key.User.company] as? Dictionary<String, Any> {
            self.company?.update(with: company)
        }
    }
}
