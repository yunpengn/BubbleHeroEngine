//
//  ViewController+Delegate.swift
//  BubbleHeroEngine
//
//  Created by Yunpeng Niu on 18/02/18.
//  Copyright © 2018 Yunpeng Niu. All rights reserved.
//

import UIKit

extension ViewController: ControllerDelegate {
    func handleTouchTop(by object: GameObject) {
        
    }

    /// Given a specific location, fills the the closest available empty cell
    /// with a certain type of bubble.
    /// - Parameters:
    ///    - point: The location given
    ///    - type: The `BubbleType` that will be filled with
    func fillNearByCell(by point: CGPoint, type: BubbleType) {
        let row = Int(round(point.y / BubbleCell.height))
        let leftOffset = (row % 2 == 0) ? 0 : BubbleCell.leftOffset
        let column = Int(round((point.x - leftOffset) / BubbleCell.diameter))

        let newBubble = FilledBubble(row: row, column: column, type: type)
        level.addOrUpdateBubble(newBubble)
        bubbleArena.reloadItems(at: [IndexPath(row: column, section: row)])
        removeSameColorNeighbors(from: newBubble)
        removeUnattachedBubbles()
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
        if sameColorBubbles.count >= 3 {
            level.deleteBubbles(sameColorBubbles)
            let indexPaths = sameColorBubbles.map { bubble in
                return IndexPath(row: bubble.column, section: bubble.row)
            }
            bubbleArena.reloadItems(at: indexPaths)
        }
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
    /// Handles the condition when a `GameObject` touches the top of the screen.
    /// - Parameter object: The `GameObject` of concern.
    func handleTouchTop(by object: GameObject)
}
