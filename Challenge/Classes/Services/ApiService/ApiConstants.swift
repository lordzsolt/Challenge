//
//  ApiConstants.swift
//  Challenge
//
//  Created by Zsolt Kovacs on 6/23/17.
//  Copyright © 2017 iOSmith. All rights reserved.
//

import Foundation

enum ApiConstants {
    enum Url {
        private static let baseUrl = "http://jsonplaceholder.typicode.com/"

        static let Posts = baseUrl + "posts"
        static let Users = baseUrl + "users"
        static let Albums = baseUrl + "albums"
        static let Photos = baseUrl + "photos"
    }

    // It might be overkill to add app API keys as contants, but I've been burned too many times with our internal API changing key paths. As such, I try to make sure there's a single point that can be changed in case it is needed
    enum Key {
        enum Common {
            static let identifier = "id"
        }

        enum User {
            static let name = "name"
            static let username = "username"
            static let email = "email"
            static let address = "address"
            static let phone = "phone"
            static let website = "website"
            static let company = "company"
        }

        enum Address {
            static let street = "street"
            static let suite = "suite"
            static let city = "city"
            static let zipcode = "zipcode"
            static let geo = "geo"
            static let latitude = "lat"
            static let longitude = "lng"
        }

        enum Company {
            static let name = "name"
            static let catchPhrase = "catchPhrase"
            static let businessStategy = "bs"
        }

        enum Post {
            static let userId = "userId"
            static let title = "title"
            static let body = "body"
        }

        enum Album {
            static let userId = "userId"
            static let title = "title"
        }

        enum Photo {
            static let albumId = "albumId"
            static let title = "title"
            static let url = "url"
            static let thumbnailUrl = "thumbnailUrl"
        }

    }
}
