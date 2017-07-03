//
//  AlbumHeaderView.swift
//  Challenge
//
//  Created by Zsolt Kovacs on 6/26/17.
//  Copyright © 2017 iOSmith. All rights reserved.
//

import UIKit

protocol AlbumHeaderViewDelegate: class {
    func headerViewExpandButtonTapped(_ headerView: AlbumHeaderView)
}

class AlbumHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var expandButton: UIButton!

    weak var delegate: AlbumHeaderViewDelegate?

    private static let titleFont = UIFont.boldSystemFont(ofSize: 20)

    override func awakeFromNib() {
        titleLabel.font = AlbumHeaderView.titleFont
        titleLabel.numberOfLines = 0
    }

    override func prepareForReuse() {
        titleLabel.text = nil
    }

    @IBAction func expandButtonTapped(_ sender: UIButton) {
        delegate?.headerViewExpandButtonTapped(self)
    }

    static func preferredHeight(with title: String, constrainedTo width: CGFloat) -> CGFloat {
        var height: CGFloat = 2

        let labelWidth = width - 20 - 50 - 5 - 8 // Title.leading, Hide button width, leading, trailing
        let constraintRect = CGSize(width: labelWidth, height: .greatestFiniteMagnitude)
        let boundingBox = title.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: AlbumHeaderView.titleFont], context: nil)
        height += boundingBox.height

        height += 4

        return height
    }
}
