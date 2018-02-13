//
//  SampleData.swift
//  BubbleHeroEngine
//
//  Created by Yunpeng Niu on 13/02/18.
//  Copyright © 2018 Yunpeng Niu. All rights reserved.
//

import Darwin

/**
 Defines some utility methods to help create dummy sample data
 for the convenience of further development.

 - Author: Niu Yunpeng @ CS3217
 - Date: Feb 2018
 */
class SampleData {
    /// Loads a sample level for convenience.
    static func loadSampleLevel() -> Level {
        let level = Level()

        for i in 0..<12 {
            addRandomTypeBubble(to: level, row: 0, column: i)
            addRandomTypeBubble(to: level, row: 2, column: i)
            if i != 5 && i != 8 {
                addRandomTypeBubble(to: level, row: 4, column: i)
            }
            addRandomTypeBubble(to: level, row: 6, column: i)
            addRandomTypeBubble(to: level, row: 8, column: i)

        }
        for i in 0..<11 {
            addRandomTypeBubble(to: level, row: 1, column: i)
            addRandomTypeBubble(to: level, row: 3, column: i)
            if i != 3 && i != 10 {
                addRandomTypeBubble(to: level, row: 5, column: i)
            }
            addRandomTypeBubble(to: level, row: 7, column: i)
            addRandomTypeBubble(to: level, row: 9, column: i)
        }

        return level
    }

    /// Adds a bubble of random `BubbleType` at the given location.
    /// - Parameters:
    ///    - level: The level that the generated bubble will be added to.
    ///    - row: The row number of the new bubble.
    ///    - column: The column number of the new bubble.
    private static func addRandomTypeBubble(to level: Level, row: Int, column: Int) {
        let randomValue = Int(arc4random_uniform(4))
        guard let type = BubbleType(rawValue: randomValue) else {
            fatalError("Couldn't generate a random type.")
        }
        level.addOrUpdateBubble(Bubble(row: row, column: column, type: type))
    }
}
