//
//  NetworkActivityIndicator.swift
//  Challenge
//
//  Created by Zsolt Kovacs on 7/3/17.
//  Copyright © 2017 iOSmith. All rights reserved.
//

import UIKit

class NetworkActivityIndicator {
    static var counter = 0 {
        didSet {
            UIApplication.shared.isNetworkActivityIndicatorVisible = counter > 0
        }
    }

    static func push() {
        counter += 1
    }

    static func pop() {
        counter -= 1
    }
}
