//
//  NSError.swift
//  Challenge
//
//  Created by Zsolt Kovacs on 7/2/17.
//  Copyright © 2017 iOSmith. All rights reserved.
//

import Foundation

extension NSError {
    public static func networkError(with message: Strings.Error) -> NSError {
        return NSError(domain: String(describing: ApiService.self), code: 404, userInfo: [NSLocalizedDescriptionKey: message.rawValue])
    }
}
