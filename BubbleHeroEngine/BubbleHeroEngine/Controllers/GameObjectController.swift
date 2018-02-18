//
//  GameObjectController.swift
//  BubbleHeroEngine
//
//  Created by Yunpeng Niu on 18/02/18.
//  Copyright © 2018 Yunpeng Niu. All rights reserved.
//

import Foundation

class GameObjectController {
    /// Stores all the shooted bubbles (but not collided with any other bubble yet).
    /// This array acts as a mapping between these shooted bubbles and corresponding
    /// `GameObject`s in the `PhysicsEngine`.
    private var shootedBubbles: [(object: GameObject, type: BubbleType)] = []

    /// Stores all the remaining bubbles in the `bubbleArena` collection view. This
    /// array acts as a mapping between these remaining bubbles and corresponding
    /// `GameObject`s in the `PhysicsEngine`.
    private var remainingBubbles: [(object: GameObject, bubble: FilledBubble)] = []

    /// Adds a new shooted bubble.
    /// - Parameters:
    ///    - object: The `GameObject` representation of the shooted bubble.
    ///    - type: The `BubbleType` of the shooted bubble.
    func addShootedBubble(object: GameObject, type: BubbleType) {
        shootedBubbles.append((object, type))
    }

    /// Removes and returns the type of a previously shooted bubble when triggered
    /// by its `GameObject` representation.
    /// - Parameter object: The `GameObject` being checked.
    /// - Returns: its `BubbleType` if the bubble has been shooted before; nil otherwise.
    func popShootedBubble(of object: GameObject) -> BubbleType? {
        let bubble = shootedBubbles.first { $0.object === object }
        shootedBubbles = shootedBubbles.filter { $0.object !== object }
        return bubble?.type
    }

    /// Adds a new remaining bubble.
    /// - Parameters:
    ///    - object: The `GameObject` representation of the remaining bubble.
    ///    - type: The `BubbleType` of the remainging bubble.
    func addRemainingBubble(object: GameObject, bubble: FilledBubble) {
        remainingBubbles.append((object, bubble))
    }

    /// Removes a certain remaining bubble and returns its `GameObject` representation.
    /// - Parameter object: The `GameObject` being checked.
    /// - Returns: its `GameObject` representation if the bubble exists; nil otherwise.
    func popRemainingBubble(of bubble: FilledBubble) -> GameObject? {
        let gameObject = remainingBubbles.first { $0.bubble == bubble }
        remainingBubbles = remainingBubbles.filter { $0.bubble != bubble }
        return gameObject?.object
    }
}
