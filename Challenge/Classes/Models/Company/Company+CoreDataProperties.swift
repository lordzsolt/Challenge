//
//  Company+CoreDataProperties.swift
//  Challenge
//
//  Created by Zsolt Kovacs on 6/23/17.
//  Copyright © 2017 iOSmith. All rights reserved.
//

import Foundation
import CoreData


extension Company {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Company> {
        return NSFetchRequest<Company>(entityName: "Company")
    }

    @NSManaged public var businessStrategy: String?
    @NSManaged public var catchPhrase: String?
    @NSManaged public var name: String?
    @NSManaged public var user: User?

}
