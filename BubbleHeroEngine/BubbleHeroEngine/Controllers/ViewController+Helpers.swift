//
//  ViewController+Helpers.swift
//  BubbleHeroEngine
//
//  Created by Yunpeng Niu on 18/02/18.
//  Copyright © 2018 Yunpeng Niu. All rights reserved.
//

import UIKit

/**
 Extension for `ViewController`, which contains some helper methods.

 - Author: Niu Yunpeng @ CS3217
 - Date: Feb 2018
 */
extension ViewController {
    /// Creates a `UIImageView` that represents a bubble that can move (compared to
    /// those in the `bubbleArena` which are static). The moving bubble created will
    /// be shown immediately.
    /// - Parameters:
    ///    - type: The type of the moving bubble.
    ///    - center: A `CGPoint` that represents the center of the bubbel (on the screen).
    func movingBubbleFactory(of type: BubbleType, center: CGPoint) -> UIImageView {
        let image = toBubbleImage(of: type)
        let imageView = UIImageView(image: image)
        let x = center.x - BubbleCell.radius
        let y = center.y - BubbleCell.radius
        imageView.frame = CGRect(x: x, y: y, width: BubbleCell.diameter, height: BubbleCell.diameter)
        view.addSubview(imageView)
        return imageView
    }
    
    /// Gets an image of the bubble cell according to its type.
    /// - Parameter type: The type of the bubble
    /// - Returns: The background image corresponding to this type.
    func toBubbleImage(of type: BubbleType) -> UIImage {
        switch type {
        case .blue:
            return #imageLiteral(resourceName: "bubble-blue")
        case .green:
            return #imageLiteral(resourceName: "bubble-green")
        case .orange:
            return #imageLiteral(resourceName: "bubble-orange")
        case .red:
            return #imageLiteral(resourceName: "bubble-red")
        }
    }
}
