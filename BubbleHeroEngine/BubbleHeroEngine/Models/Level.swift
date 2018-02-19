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
 inside the grid. The elements of this 2D array are of type `FilledBubble?`. In
 other words, if a cell in this array is `nil`, it implies there is no bubble at
 this position.

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
    private var bubbles: [[FilledBubble?]]

    /// Creates a new level with default size.
    init() {
        numOfRows = Settings.numOfRows
        evenCount = Settings.cellPerRow
        oddCount = evenCount - 1
        bubbles = [[FilledBubble?]](repeating: [FilledBubble?](repeating: nil, count: evenCount),
                              count: numOfRows)
    }

    /// Adds (or updates) a new bubble to the current `Level` at a certain
    /// position. If there already exists a bubble there, replace it. This
    /// method will simply do nothing if the given bubble is not at a legal
    /// position of the current `Level`.
    /// - Parameter toAdd: The bubble being added.
    func addOrUpdateBubble(_ toAdd: FilledBubble) {
        guard isValidLocation(row: toAdd.row, column: toAdd.column) else {
            return
        }
        bubbles[toAdd.row][toAdd.column] = toAdd
    }

    /// Checks whether the current `Level` has a certain bubble.
    /// - Parameters:
    ///    - row: The row number of the intended location (zero-based).
    ///    - column: The column number of the intended location (zero-based).
    func hasBubble(_ toCheck: FilledBubble) -> Bool {
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

    /// Finds all the connected bubbles with the same color starting from a certain
    /// bubble. The result includes the starting bubble itself.
    /// - Parameter bubble: The bubble acting as the starting point.
    /// - Returns: An array of connected bubbles with the same color; an empty array
    /// if the provided bubble does not exist.
    func getSameColorConnectedItemsOf(_ bubble: FilledBubble) -> [FilledBubble] {
        guard hasBubble(bubble) else {
            return []
        }

        var result: [FilledBubble] = []
        var toVisit = Stack<FilledBubble>()
        toVisit.push(bubble)

        // Starts a DFS to find all connected items with the same color.
        while let next = toVisit.pop() {
            if result.index(of: next) == nil {
                result.append(next)
            }

            for neighbor in getSameColorNeighborsOf(next) {
                if result.index(of: neighbor) == nil {
                    toVisit.push(neighbor)
                }
            }
        }

        return result
    }

    /// Gets the same color neighbors of a certain bubble.
    /// - Parameters:
    ///    - row: The row number of the intended location (zero-based).
    ///    - column: The column number of the intended location (zero-based).
    /// - Returns: An array of same color neighbors if there exists; empty array otherwise.
    private func getSameColorNeighborsOf(_ bubble: FilledBubble) -> [FilledBubble] {
        let neighbors = getNeighborsOf(row: bubble.row, column: bubble.column)
        return neighbors.filter { $0.type == bubble.type }
    }

    /// Gets the neighbors of a certain location, the items at the nearby indices
    /// are not `nil`.
    ///
    /// Notice: the nearby indices here are defined as the cellular network. Thus,
    /// there are at most 6 neighbors.
    /// - Parameters:
    ///    - row: The row number of the intended location (zero-based).
    ///    - column: The column number of the intended location (zero-based).
    /// - Returns: An array of neighbors if there exists; empty array otherwise.
    private func getNeighborsOf(row: Int, column: Int) -> [FilledBubble] {
        var neighbors: [FilledBubble?] = []

        let nearRowOffset = (row % 2 == 0) ? -1 : 1
        neighbors.append(getBubbleAt(row: row, column: column - 1))
        neighbors.append(getBubbleAt(row: row, column: column + 1))
        neighbors.append(getBubbleAt(row: row - 1, column: column))
        neighbors.append(getBubbleAt(row: row - 1, column: column + nearRowOffset))
        neighbors.append(getBubbleAt(row: row + 1, column: column))
        neighbors.append(getBubbleAt(row: row + 1, column: column + nearRowOffset))

        return neighbors.flatMap { $0 }
    }

    /// Finds the unattached bubbles. A bubble is defined as "unattached"
    /// if it is not connected to the top wall or any other attached bubbles.
    /// - Returns: an array of unattached bubbles.
    func getUnattachedBubbles() -> [FilledBubble] {
        // To find and remove unattached bubbles, we first label those attached ones.
        var isAttached = checkAttached()

        // Those existing (non-nil) bubbles who are not labelled as attached
        // should be removed and returned.
        var result: [FilledBubble] = []
        for i in 0..<numOfRows / 2 {
            for j in 0..<evenCount {
                guard !isAttached[i * 2][j] else {
                    continue
                }
                if let bubble = bubbles[i * 2][j] {
                    result.append(bubble)
                }
            }
            for k in 0..<oddCount {
                guard !isAttached[i * 2 + 1][k] else {
                    continue
                }
                if let bubble = bubbles[i * 2 + 1][k] {
                    result.append(bubble)
                }
            }
        }

        return result
    }

    /// Finds all the attached bubbles. A bubble is defined as "attached" if it is
    /// connected to the top wall or any other connected bubbles.
    /// - Returns: an array of attached bubbles.
    private func checkAttached() -> [[Bool]] {
        var isAttached = [[Bool]](repeating: [Bool](repeating: false, count: evenCount),
                                  count: numOfRows)
        var toCheck = Stack<FilledBubble>()

        // All bubbles in the first row are (directly) attached (to the top wall).
        for column in 0..<evenCount {
            if let bubble = bubbles[0][column] {
                isAttached[0][column] = true
                toCheck.push(bubble)
            }
        }

        // Starts a DFS to find all attached bubbles.
        while let next = toCheck.pop() {
            if !isAttached[next.row][next.column] {
                isAttached[next.row][next.column] = true
            }

            for neighbor in getNeighborsOf(row: next.row, column: next.column)
                where !isAttached[neighbor.row][neighbor.column] {
                isAttached[neighbor.row][neighbor.column] = true
                toCheck.push(neighbor)
            }
        }

        return isAttached
    }

    /// Gets the bubble located at the specified location.
    /// - Parameters:
    ///    - row: The row number of the intended location (zero-based).
    ///    - column: The column number of the intended location (zero-based).
    /// - Returns: the bubble at that location if it exists; nil otherwise.
    func getBubbleAt(row: Int, column: Int) -> FilledBubble? {
        guard isValidLocation(row: row, column: column) else {
            return nil
        }
        return bubbles[row][column]
    }

    /// Deletes a list of bubbles from the current `Level`; if any one of them does
    /// not exist, do nothing.
    /// - Parameter toDelete: the list of bubbles being deleted.
    func deleteBubbles(_ toDelete: [FilledBubble]) {
        for bubble in toDelete {
            deleteBubble(bubble)
        }
    }

    /// Deletes a certain bubble from the current `Level`; if it does not exist,
    /// do nothing.
    /// - Parameter toDelete: the bubble being deleted.
    func deleteBubble(_ toDelete: FilledBubble) {
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
    func isValidLocation(row: Int, column: Int) -> Bool {
        guard row >= 0 && row < numOfRows else {
            return false
        }

        if row % 2 == 0 {
            return column >= 0 && column < evenCount
        } else {
            return column >= 0 && column < oddCount
        }
    }
}
