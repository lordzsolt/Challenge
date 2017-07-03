//
//  TwoWayMapTests.swift
//  Challenge
//
//  Created by Zsolt Kovacs on 7/3/17.
//  Copyright © 2017 iOSmith. All rights reserved.
//

import XCTest
@testable import Challenge

class TwoWayMapTests: XCTestCase {
    func testCreatedMapIsEmpty() {
        // Act
        let map = TwoWayMap<NSString, NSString>()

        // Assert
        XCTAssertNil(map.object(forKey: ""))
        XCTAssertNil(map.key(forObject: ""))
    }

    func testCanInsertCorrectly() {
        // Arrange
        let map = TwoWayMap<NSString, NSString>()

        // Act
        let object: NSString = "A"
        let key: NSString = "B"
        map.set(object: object, forKey: key)

        // Assert
        XCTAssertEqual(map.object(forKey: key), object)
        XCTAssertEqual(map.key(forObject: object), key)
    }

    func testCanRemoveCorrectly() {
        // Arrange
        let map = TwoWayMap<NSString, NSString>()
        let object: NSString = "A"
        let key: NSString = "B"
        map.set(object: object, forKey: key)

        // Act
        map.removeObject(forKey: key)

        // Assert
        XCTAssertNil(map.object(forKey: key))
        XCTAssertNil(map.key(forObject: object))
    }
}
