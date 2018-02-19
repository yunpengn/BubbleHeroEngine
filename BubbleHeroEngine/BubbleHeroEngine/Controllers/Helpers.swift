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
class Helpers {
    /// Gets an image of the bubble cell according to its type.
    /// - Parameter type: The type of the bubble
    /// - Returns: The background image corresponding to this type.
    static func toBubbleImage(of type: BubbleType) -> UIImage {
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
