//
//  Strings.swift
//  Challenge
//
//  Created by Zsolt Kovacs on 6/23/17.
//  Copyright © 2017 iOSmith. All rights reserved.
//

import Foundation

public enum Strings {
    public enum Root {
        static let retry = "Retry"
    }

    public enum Main {
        static let title = "Challenge Accepted!"
    }

    public enum Details {
        static let sectionExpanded = "Hide"
        static let sectionCollapsed = "Show"
    }

    public enum Error: String {
        case general = "An unexpected error occurred. Make sure your internet connection is active, then try again."
        case timeout = "A network request seems to have timed out. Please make sure you have a stable internet connection."
        case invalidResponse = "The server response seems to be invalid. If the problem persists, please contact us."
    }
}
