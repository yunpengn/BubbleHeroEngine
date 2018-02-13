//
//  FilledBubble.swift
//  BubbleHeroEngine
//
//  Created by Yunpeng Niu on 13/02/18.
//  Copyright © 2018 Yunpeng Niu. All rights reserved.
//

/**
 `FilledBubble` is a kind of `Bubble` which is stationary. It has a specific
 position (identified by its row & column number). It is filled into a certain
 cell of a `Level`.
 
 Notice: There is no constraint to the row/column number here. The
 constraints will be enforced in `Level` only. This is because `Bubble`
 is a generic class and even may not be part of the current `Level` object.

 - Author: Niu Yunpeng @ CS3217
 - Date: Feb 2018
 */
class FilledBubble: Codable {
    let row: Int
    let column: Int
    let type: BubbleType

    /// Creates a new bubble filled at a specific location.
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
extension FilledBubble: Equatable {
    /// Returns true if `lhs` bubble is equal to `rhs` equal.
    static func == (_ lhs: FilledBubble, _ rhs: FilledBubble) -> Bool {
        return lhs.row == rhs.row
            && lhs.column == rhs.column
            && lhs.type == rhs.type
    }
}
