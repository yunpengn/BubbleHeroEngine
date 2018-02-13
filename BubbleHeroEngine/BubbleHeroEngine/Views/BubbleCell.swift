//
//  BubbleCell.swift
//  BubbleHeroEngine
//
//  Created by Yunpeng Niu on 13/02/18.
//  Copyright © 2018 Yunpeng Niu. All rights reserved.
//

import UIKit

/**
 A single cell that displays a bubble or displays nothing when there is
 no bubble at this position.

 It inherits from `UICollectionViewCell` so that it can be used in a
 collection view.

 - Author: Niu Yunpeng @ CS3217
 - Date: Feb 2018
 */
class BubbleCell: UICollectionViewCell {
    /// The background image shown in this cell, which will be used by
    /// the user to distinguish different types of bubbles.
    @IBOutlet weak var image: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    /// Customizes the cell to make it look like a bubble.
    private func setup() {
        layer.cornerRadius = frame.width / 2
        backgroundColor = UIColor.orange
    }
}
