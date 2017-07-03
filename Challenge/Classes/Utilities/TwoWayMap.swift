//
//  TwoWayDictionary.swift
//  Challenge
//
//  Created by Zsolt Kovacs on 7/3/17.
//  Copyright © 2017 iOSmith. All rights reserved.
//

import Foundation

struct TwoWayMap<T: AnyObject, U: AnyObject> {
    private var mappingTU = NSMapTable<T, U>.weakToStrongObjects()
    private var mappingUT = NSMapTable<U, T>.weakToStrongObjects()

    func set(object: U, forKey key: T) {
        mappingTU.setObject(object, forKey: key)
        mappingUT.setObject(key, forKey: object)
    }

    func object(forKey key: T) -> U? {
        return mappingTU.object(forKey: key)
    }

    func key(forObject object: U) -> T? {
        return mappingUT.object(forKey: object)
    }

    func removeObject(forKey key: T) {
        if let object = mappingTU.object(forKey: key) {
            mappingUT.removeObject(forKey: object)
        }
        mappingTU.removeObject(forKey: key)
    }
}
