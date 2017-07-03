//
//  Company+CoreDataClass.swift
//  Challenge
//
//  Created by Zsolt Kovacs on 6/23/17.
//  Copyright © 2017 iOSmith. All rights reserved.
//

import Foundation
import CoreData

@objc(Company)
public class Company: NSManagedObject {
    func update(with details: Dictionary<String, Any>) {
        if let newValue = details[ApiConstants.Key.Company.name] as? String, name != newValue {
            name = newValue
        }

        if let newValue = details[ApiConstants.Key.Company.catchPhrase] as? String, catchPhrase != newValue {
            catchPhrase = newValue
        }

        if let newValue = details[ApiConstants.Key.Company.businessStategy] as? String, businessStrategy != newValue {
            businessStrategy = newValue
        }
    }
}
