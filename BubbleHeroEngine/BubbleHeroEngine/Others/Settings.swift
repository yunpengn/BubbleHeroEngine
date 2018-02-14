//
//  Settings.swift
//  
//
//  Created by Yunpeng Niu on 13/02/18.
//

import UIKit

/**
 Defines some global level settings for the application.

 - Author: Niu Yunpeng @ CS3217
 - Date: Feb 2018
 */
class Settings {
    /// The allowed number of rows in a `Level`.
    static let numOfRows = 12
    /// The allowed number of bubbles on even rows.
    static let cellPerRow = 12
    /// The number of types of bubbles in the game currently.
    static let numOfTypes = UInt32(4)
    /// The speed in which the shooting bubble will travel.
    static let speed = CGFloat(10)
}
