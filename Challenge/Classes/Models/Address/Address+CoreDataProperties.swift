//
//  Address+CoreDataProperties.swift
//  Challenge
//
//  Created by Zsolt Kovacs on 6/23/17.
//  Copyright © 2017 iOSmith. All rights reserved.
//

import Foundation
import CoreData


extension Address {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Address> {
        return NSFetchRequest<Address>(entityName: "Address")
    }

    @NSManaged public var city: String?
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var street: String?
    @NSManaged public var suite: String?
    @NSManaged public var zipCode: String?
    @NSManaged public var user: User?

}
