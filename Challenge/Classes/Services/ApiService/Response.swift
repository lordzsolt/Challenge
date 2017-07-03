//
//  Response.swift
//  PricingBasket
//
//  Created by Zsolt Kovacs on 6/3/17.
//  Copyright © 2017 iOSmith. All rights reserved.
//

import Foundation

enum Response<T> {
    case success(T)
    case failed(NSError)
}
