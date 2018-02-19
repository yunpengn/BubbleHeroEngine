//
//  BubbleArenaController+Delegate.swift
//  BubbleHeroEngine
//
//  Created by Yunpeng Niu on 20/02/18.
//  Copyright © 2018 Yunpeng Niu. All rights reserved.
//

import UIKit

/**
 Extension for `BubbleArenaController`, which supports some functionalities to act as
 a delegate.

 - Author: Niu Yunpeng @ CS3217
 - Date: Feb 2018
 */
extension BubbleArenaController: BubbleArenaControllerDelegate {
    func addMovingBubble(of type: BubbleType, center: CGPoint) -> UIImageView {
        let image = Helpers.toBubbleImage(of: type)
        let imageView = UIImageView(image: image)
        let x = center.x - BubbleCell.radius
        let y = center.y - BubbleCell.radius
        imageView.frame = CGRect(x: x, y: y, width: BubbleCell.diameter, height: BubbleCell.diameter)
        view.addSubview(imageView)
        return imageView
    }
}

protocol BubbleArenaControllerDelegate: AnyObject {
    /// Creates a `UIImageView` that represents a bubble that can move (compared to
    /// those in the `bubbleArena` which are static). The moving bubble created will
    /// be shown immediately.
    /// - Parameters:
    ///    - type: The type of the moving bubble.
    ///    - center: A `CGPoint` that represents the center of the bubbel (on the screen).
    func addMovingBubble(of type: BubbleType, center: CGPoint) -> UIImageView
}
