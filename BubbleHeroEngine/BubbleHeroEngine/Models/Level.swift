//
//  Level.swift
//  BubbleHeroEngine
//
//  Created by Yunpeng Niu on 13/02/18.
//  Copyright © 2018 Yunpeng Niu. All rights reserved.
//


/**
 `Level` is an abstract data structure that represents a certain game level,
 i.e., the placement of all bubbles.

 Internally, `Level` uses a 2D array to store all bubbles with their positions
 inside the grid. The elements of this 2D array are of type `Bubble?`. In other
 words, if a cell in this array is `nil`, it implies there is no bubble at this
 position.

 - Author: Niu Yunpeng @ CS3217
 - Date: Feb 2018
 
 The grid (2D array) has different number of items on odd/even rows. Odd rows
 should have one fewer item than even rows.
 */
class Level: Codable {
    /// The allowed number of rows in a `Level`.
    let numOfRows: Int
    /// The allowed number of bubbles on even rows.
    let evenCount: Int
    /// The allowed number of bubbles on odd rows.
    let oddCount: Int

    /// Internal storage structure for all bubbles in a `Level`.
    private var bubbles: [[Bubble?]]

    /// Creates a new level with default size.
    init() {
        numOfRows = Setting.numOfRows
        evenCount = Setting.cellPerRow
        oddCount = evenCount - 1
        bubbles = [[Bubble?]](repeating: [Bubble?](repeating: nil, count: evenCount),
                              count: numOfRows)
    }

    /// Adds (or updates) a new bubble to the current `Level` at a certain
    /// position. If there already exists a bubble there, replace it. This
    /// method will simply do nothing if the given bubble is not at a legal
    /// position of the current `Level`.
    /// - Parameter toAdd: The bubble being added.
    func addOrUpdateBubble(_ toAdd: Bubble) {
        guard isValidLocation(row: toAdd.row, column: toAdd.column) else {
            return
        }
        bubbles[toAdd.row][toAdd.column] = toAdd
    }

    /// Checks whether the current `Level` has a certain bubble.
    /// - Parameters:
    ///    - row: The row number of the intended location (zero-based).
    ///    - column: The column number of the intended location (zero-based).
    func hasBubble(_ toCheck: Bubble) -> Bool {
        let row = toCheck.row
        let column = toCheck.column
        guard isValidLocation(row: row, column: column) else {
            return false
        }

        if let bubble = bubbles[row][column] {
            return bubble == toCheck
        } else {
            return false
        }
    }

    /// Checks whether the current `Level` has a bubble located at the intended
    /// position.
    /// - Parameters:
    ///    - row: The row number of the intended location (zero-based).
    ///    - column: The column number of the intended location (zero-based).
    func hasBubbleAt(row: Int, column: Int) -> Bool {
        return isValidLocation(row: row, column: column)
            && bubbles[row][column] != nil
    }

    /// Gets the bubble located at the specified location.
    /// - Parameters:
    ///    - row: The row number of the intended location (zero-based).
    ///    - column: The column number of the intended location (zero-based).
    /// - Returns: the bubble at that location if it exists; nil otherwise.
    func getBubbleAt(row: Int, column: Int) -> Bubble? {
        guard isValidLocation(row: row, column: column) else {
            return nil
        }
        return bubbles[row][column]
    }

    /// Deletes a certain bubble from the current `Level`; if it does not exist,
    /// do nothing.
    /// - Parameter toDelete: the bubble being deleted.
    func deleteBubble(_ toDelete: Bubble) {
        guard hasBubble(toDelete) else {
            return
        }
        bubbles[toDelete.row][toDelete.column] = nil
    }

    /// Deletes a certain bubble from the current `Level` at a certain location;
    /// if there is no bubbble on that location, do nothing. The location is
    /// represented by the zero-based row/column number.
    /// - Parameters:
    ///    - row: The row number of the intended location (zero-based).
    ///    - column: The column number of the intended location (zero-based).
    func deleteBubbleAt(row: Int, column: Int) {
        guard isValidLocation(row: row, column: column) else {
            return
        }
        bubbles[row][column] = nil
    }

    /// Checks whether a certain location is valid in a `Level`.
    /// - Parameters:
    ///    - row: The row number of the checked location (zero-based).
    ///    - column: The column number of the checked location (zero-based).
    private func isValidLocation(row: Int, column: Int) -> Bool {
        guard row < numOfRows else {
            return false
        }

        if row % 2 == 0 {
            return column < evenCount
        } else {
            return column < oddCount
        }
    }
}
