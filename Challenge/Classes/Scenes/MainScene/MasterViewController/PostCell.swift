//
//  PostCell.swift
//  Challenge
//
//  Created by Zsolt Kovacs on 6/26/17.
//  Copyright © 2017 iOSmith. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
