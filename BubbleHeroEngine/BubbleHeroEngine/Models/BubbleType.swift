//
//  BubbleType.swift
//  BubbleHeroEngine
//
//  Created by Yunpeng Niu on 13/02/18.
//  Copyright © 2018 Yunpeng Niu. All rights reserved.
//

/**
 `BubbleTypes` is an enumeration that defines the type of a bubble.
 Notice: Although the type here only defines the color of the bubble
 for now, there may be more types in the future.

 - Author: Niu Yunpeng @ CS3217
 - Date: Feb 2018
 */
enum BubbleType: Int, Codable {
    case blue
    case green
    case orange
    case red

    /// Cycles the type of a bubble in the order of blue -> green ->
    /// orange -> red -> blue ...
    /// - Returns: The next type in the cycling of colors.
    func nextColor() -> BubbleType {
        switch self {
        case .blue:
            return .green
        case .green:
            return .orange
        case .orange:
            return .red
        case .red:
            return .blue
        }
    }
}
