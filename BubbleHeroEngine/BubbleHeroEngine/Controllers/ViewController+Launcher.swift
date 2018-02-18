//
//  ViewController+Launcher.swift
//  BubbleHeroEngine
//
//  Created by Yunpeng Niu on 14/02/18.
//  Copyright © 2018 Yunpeng Niu. All rights reserved.
//

import UIKit

/**
 Extension for `ViewController`, which controls the logic about launching & shooting
 bubbles.

 - Author: Niu Yunpeng @ CS3217
 - Date: Feb 2018
 */
extension ViewController {
    /// Handles the launch of a bubble when the user single-taps on the screen.
    /// - Parameter sender: The sender of the single-tap gesture.
    @IBAction func handleBubbleLaunch(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        guard bubbleLauncher.center.y >= location.y + Settings.launchVerticalLimit else {
            return
        }
        let angle = getShootAngle(by: location)
        shootBubble(at: angle)
        updateBubbleLauncher()
    }

    /// Given a point at which the user touches, computes the initial angle of the
    /// bubble being shooted.
    ///
    /// The angle computed will increment when rotating anti-clockwise in the range
    /// of [0, PI]. Notice that we only allow the user to launch bubbles upwards.
    /// - Parameter point: The point at which the user touches.
    /// - Returns: The initial angle of the launched angle.
    private func getShootAngle(by point: CGPoint) -> CGFloat {
        let deltaX = bubbleLauncher.center.x - point.x
        let deltaY = bubbleLauncher.center.y - point.y
        let newDeltaY = deltaY > 0 ? deltaY : 0
        return atan2(newDeltaY, deltaX)
    }

    /// Computes the initial speed of the shooted bubble according to the angle.
    /// - Parameter angle: The angle in which the bubble is shooted.
    /// - Returns: A `CGVector` representing the speed of the shooted bubble.
    private func getShootSpeed(by angle: CGFloat) -> CGVector {
        let dX = -Settings.shootSpeed * cos(angle)
        let dY = -Settings.shootSpeed * sin(angle)
        return CGVector(dx: dX, dy: dY)
    }

    /// Shoots a bubble from `bubbleLauncher` at a specific angle.
    /// - Parameter angle: The angle at which the bubble will be shooted.
    private func shootBubble(at angle: CGFloat) {
        // Creates a shooted bubble visually.
        let type = provider.peek()
        let bubble = movingBubbleFactory(of: type, center: bubbleLauncher.center)

        // Creates a `GameObject` for the shooted bubble and register it into the
        // `PhysicsEngine` (to take over the control).
        let gameObject = GameObject(view: bubble, radius: BubbleCell.radius)
        gameObject.speed = getShootSpeed(by: angle)
        engine.registerGameObject(gameObject)

        // Keeps a record of the shooted bubble.
        gameObjects.addShootedBubble(object: gameObject, type: type)
    }

    /// Updates the status of the `bubbleLauncher` after one bubble in shooted.
    func updateBubbleLauncher() {
        let type = provider.pop()
        bubbleLauncher.setImage(toBubbleImage(of: type), for: .normal)
    }
}
