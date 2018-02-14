//
//  BubbleCell.swift
//  BubbleHeroEngine
//
//  Created by Yunpeng Niu on 13/02/18.
//  Copyright © 2018 Yunpeng Niu. All rights reserved.
//

import UIKit
import Foundation

/**
 A single cell that displays a bubble or displays nothing when there is
 no bubble at this position.

 It inherits from `UICollectionViewCell` so that it can be used in a
 collection view.

 - Author: Niu Yunpeng @ CS3217
 - Date: Feb 2018
 */
class BubbleCell: UICollectionViewCell {
    /// The diameter of each bubble
    static let diameter = UIScreen.main.bounds.width / CGFloat(Settings.cellPerRow)
    /// The square of the diameter of each bubble
    static let diameterSquare = BubbleCell.diameter * BubbleCell.diameter
    /// The radius of each bubble
    static let radius = BubbleCell.diameter / 2
    /// The offset on y-axis for bubbles on odd rows.
    static let leftOffset = BubbleCell.radius
    /// The offset between two succeeding rows.
    static let rowOffset = BubbleCell.radius * (2 - sqrt(3))
    /// The height for each row.
    static let height = BubbleCell.radius * sqrt(3)

    /// The background image of this bubble cell.
    private var background: UIImageView?

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
        layer.cornerRadius = BubbleCell.radius
    }

    /// Removes the background image of the cell and thus makes it transparent.
    func clear() {
        background?.removeFromSuperview()
        background = nil
    }

    /// Fills the bubble with a background image.
    /// - Parameter image: The image that the bubble will be filled with.
    func fill(image: UIImage) {
        clear()
        // Adds the background image to content view, as recommended in
        // Swift's official documentation.
        let imageView = UIImageView(image: image)
        imageView.frame = self.bounds
        contentView.addSubview(imageView)
        background = imageView
    }
}
