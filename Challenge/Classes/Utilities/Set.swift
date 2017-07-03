//
//  Set.swift
//  Challenge
//
//  Created by Zsolt Kovacs on 6/29/17.
//  Copyright © 2017 iOSmith. All rights reserved.
//

import Foundation

extension Set {
    func containsObjects<T>(of type: T.Type) -> Bool {
        for item in self {
            if item is T {
                return true
            }
        }
        return false
    }
}
