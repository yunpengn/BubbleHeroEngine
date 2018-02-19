//
//  ShootingBubbleController+Delegate.swift
//  BubbleHeroEngine
//
//  Created by Yunpeng Niu on 20/02/18.
//  Copyright © 2018 Yunpeng Niu. All rights reserved.
//

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

protocol ShootingBubbleControllerDelegate {
    func addShootedBubble(object: GameObject, type: BubbleType)

    func addRemainingBubble(object: GameObject, bubble: FilledBubble)
}
