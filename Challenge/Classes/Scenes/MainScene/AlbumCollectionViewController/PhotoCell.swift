//
//  PhotoCell.swift
//  Challenge
//
//  Created by Zsolt Kovacs on 6/26/17.
//  Copyright © 2017 iOSmith. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView.clipsToBounds = true
    }

    @IBOutlet weak var imageView: UIImageView!

    override func prepareForReuse() {
        imageView.image = nil
    }
}
