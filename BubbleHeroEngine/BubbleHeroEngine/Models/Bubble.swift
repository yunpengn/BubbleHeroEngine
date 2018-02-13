//
//  Bubble.swift
//  BubbleHeroEngine
//
//  Created by Yunpeng Niu on 13/02/18.
//  Copyright © 2018年 Yunpeng Niu. All rights reserved.
//

/**
 `Bubble` is the atomic unit in the game. It is located at an unchanged
 position (identified by its row number and column number). Each type
 should belong to a certain type.
 
 Notice: There is no constraint to the row/column number here. The
 constraints will be enforced in `Level` only. This is because `Bubble`
 is a generic class and even may not be part of the current `Level` object.

 - Author: Niu Yunpeng @ CS3217
 - Date: Feb 2018
 */
class Bubble: Codable {
    let row: Int
    let column: Int
    let type: BubbleType

    /// Creates a new bubble.
    /// - Parameters:
    ///    - row: The row number of this bubble.
    ///    - column: The column number of this bubble.
    ///    - type: The `BubbleType` of this bubble.
    init(row: Int, column: Int, type: BubbleType) {
        self.row = row
        self.column = column
        self.type = type
    }
}

/// Conforms to the `Equatable` protocol.
extension Bubble: Equatable {
    /// Returns true if `lhs` bubble is equal to `rhs` equal.
    static func == (_ lhs: Bubble, _ rhs: Bubble) -> Bool {
        return lhs.row == rhs.row
            && lhs.column == rhs.column
            && lhs.type == rhs.type
    }
}
