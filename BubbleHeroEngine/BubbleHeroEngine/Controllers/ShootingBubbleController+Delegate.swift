//
//  ShootingBubbleController+Delegate.swift
//  BubbleHeroEngine
//
//  Created by Yunpeng Niu on 20/02/18.
//  Copyright © 2018 Yunpeng Niu. All rights reserved.
//

/**
 Extension for `ShootingBubbleController`, which supports some functionalities to act as
 a delegate.

 - Author: Niu Yunpeng @ CS3217
 - Date: Feb 2018
 */
extension ShootingBubbleController: ShootingBubbleControllerDelegate {
    func addShootedBubble(object: GameObject, type: BubbleType) {
        engine.registerGameObject(object)
        gameObjects.addShootedBubble(object: object, type: type)
    }

    func addRemainingBubble(object: GameObject, bubble: FilledBubble) {
        engine.registerGameObject(object)
        gameObjects.addRemainingBubble(object: object, bubble: bubble)
    }
}

protocol ShootingBubbleControllerDelegate: AnyObject {
    /// Adds a shooted bubble (which has just been launched by bubble launcher) to let
    /// `ShootingBubbleController` and `PhysicsEngine` take over the control.
    /// - Parameters:
    ///    - object: The `GameObject` representation of this shooted bubble.
    ///    - type: The `BubbleType` of this shooted bubble.
    func addShootedBubble(object: GameObject, type: BubbleType)

    /// Adds a remainiing bubble in the grid of bubbles to let `ShootingBubbleController`
    /// and `PhysicsEngine` take over the control.
    /// - Parameters:
    ///    - object: The `GameObject` representation of this remainging bubble.
    ///    - type: The `FilledBubble` representation of this remainging bubble.
    func addRemainingBubble(object: GameObject, bubble: FilledBubble)
}
