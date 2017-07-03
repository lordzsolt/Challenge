//
//  Address+CoreDataClass.swift
//  Challenge
//
//  Created by Zsolt Kovacs on 6/23/17.
//  Copyright © 2017 iOSmith. All rights reserved.
//

import Foundation
import CoreData

@objc(Address)
public class Address: NSManagedObject {
    func update(with details: Dictionary<String, Any>) {
        if let newValue = details[ApiConstants.Key.Address.street] as? String, street != newValue {
            street = newValue
        }

        if let newValue = details[ApiConstants.Key.Address.suite] as? String, suite != newValue {
            suite = newValue
        }

        if let newValue = details[ApiConstants.Key.Address.city] as? String, city != newValue {
            city = newValue
        }

        if let newValue = details[ApiConstants.Key.Address.zipcode] as? String, zipCode != newValue {
            zipCode = newValue
        }

        if let geo = details[ApiConstants.Key.Address.geo] as? Dictionary<String, String> {
            if let newValue = geo[ApiConstants.Key.Address.latitude], latitude != newValue {
                latitude = newValue
            }

            if let newValue = geo[ApiConstants.Key.Address.longitude], longitude != newValue {
                longitude = newValue
            }
        }
    }
}
