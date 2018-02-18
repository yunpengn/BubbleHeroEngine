//
//  ViewController+Delegate.swift
//  BubbleHeroEngine
//
//  Created by Yunpeng Niu on 18/02/18.
//  Copyright © 2018 Yunpeng Niu. All rights reserved.
//

import UIKit

/**
 Extension for `ViewController`. This extension is the delegate for the `PhysicsEngine`.

 - Author: Niu Yunpeng @ CS3217
 - Date: Feb 2018
 */
extension ViewController: ControllerDelegate {
    func handleCollision(by object: GameObject) {
        let location = findNearbyCell(of: object)
        guard let type = gameObjects.popShootedBubble(of: object) else {
            return
        }
        let newBubble = fillCell(row: location.row, column: location.column, type: type)
        removeSameColorNeighbors(from: newBubble)
        removeUnattachedBubbles()
    }

    /// Finds the coordinates of the nearby cell of a given `GameObject`.
    /// - Parameter object: The `GameObject` being checked.
    /// - Returns: a tuple representing the row & column number of the nearby cell.
    private func findNearbyCell(of object: GameObject) -> (row: Int, column: Int) {
        // Gets the (minX, minY) of the `GameObject` (its top-left corner).
        let minX = object.centerX - object.radius
        let minY = object.centerY - object.radius

        // Calculates the row & column number.
        let row = Int(round((minY) / BubbleCell.height))
        let leftOffset = (row % 2 == 0) ? 0 : BubbleCell.leftOffset
        let column = Int(round((minX - leftOffset) / BubbleCell.diameter))

        return (row, column)
    }

    /// Fills a cell at the specific location with a certain `BubbleType`.
    /// - Parameters:
    ///    - row: Thw row number of the intended cell.
    ///    - column: The column number of the intended cell.
    ///    - type: The `BubbleType` that the cell will be filled with.
    /// - Returns: the cell being filled.
    private func fillCell(row: Int, column: Int, type: BubbleType) -> FilledBubble {
        let newBubble = FilledBubble(row: row, column: column, type: type)
        level.addOrUpdateBubble(newBubble)
        bubbleArena.reloadItems(at: [IndexPath(row: column, section: row)])
        return newBubble
    }

    /// Computes the bubbles nearby a point. The bubble is considered to be
    /// "nearby" if the following condition is `true`:
    ///
    /// If there exists a bubble centered at `point`, the distances between
    /// their centers are smaller or equal to the diameter of a bubble.
    /// - Parameter point: The point being computed
    /// - Returns: an array of neighboring bubbles if there exists; nil otherwise.
    func getBubbleNear(by point: CGPoint) -> [FilledBubble] {
        let row = Int(round(point.y / BubbleCell.height))
        let leftOffset = (row % 2 == 0) ? 0 : BubbleCell.leftOffset
        let column = Int(round((point.x - leftOffset) / BubbleCell.diameter))
        let neighbors = level.getNeighborsOf(row: row, column: column)

        return neighbors.filter { bubble in
            return shouldCollide(bubble, with: point)
        }
    }

    private func shouldCollide(_ bubble: FilledBubble, with point: CGPoint) -> Bool {
        let leftOffset = (bubble.row % 2 == 0) ? 0 : BubbleCell.leftOffset
        let bubbleX = CGFloat(bubble.column) * BubbleCell.diameter + leftOffset
        let bubbleY = CGFloat(bubble.row) * BubbleCell.height
        let deltaX = bubbleX - point.x
        let deltaY = bubbleY - point.y
        return deltaX * deltaX + deltaY * deltaY
            <= BubbleCell.diameterSquare * Settings.collisionThreshold
    }

    private func removeSameColorNeighbors(from bubble: FilledBubble) {
        let sameColorBubbles = level.getSameColorConnectedItemsOf(bubble)
        guard sameColorBubbles.count >= 3 else {
            return
        }

        level.deleteBubbles(sameColorBubbles)
        let indexPaths = sameColorBubbles.map { bubble in
            return IndexPath(row: bubble.column, section: bubble.row)
        }
        bubbleArena.reloadItems(at: indexPaths)
    }

    private func removeUnattachedBubbles() {
        let unattachedBubbles = level.removeUnattachedBubbles()
        level.deleteBubbles(unattachedBubbles)

        var indexPaths: [IndexPath] = []
        for bubble in unattachedBubbles {
            let indexPath = IndexPath(row: bubble.column, section: bubble.row)
            createFallingBubble(of: bubble.type, at: indexPath)
            indexPaths.append(indexPath)
        }
        bubbleArena.reloadItems(at: indexPaths)
    }

    /// Uses the physics engine to control the free falling process of unattached bubble.
    /// - Parameters:
    ///    - type: The type of the unattached bubble.
    ///    - indexPath: The `IndexPath` of the unattached bubble.
    private func createFallingBubble(of type: BubbleType, at indexPath: IndexPath) {
        // Creates a bubble at the same location of the unattached bubble (because the
        // original bubble in the collection view has been removed).
        guard let center = bubbleArena.cellForItem(at: indexPath)?.center else {
            return
        }
        let bubble = movingBubbleFactory(of: type, center: center)

        // Adds the object to game engine and simulates a free falling (with initial
        // speed of 0 and acceleration equal to a constant).
        let gameObject = GameObject(view: bubble, radius: BubbleCell.radius)
        gameObject.acceleration = CGVector(dx: 0, dy: Settings.gravityConstant)
        engine.registerGameObject(gameObject)
    }
}

protocol ControllerDelegate {
    /// Handles the condition when a `GameObject` collides with either the top of the
    /// screen or a bubble in the `bubbleArena`.
    /// - Parameter object: The `GameObject` of concern.
    func handleCollision(by object: GameObject)
}
