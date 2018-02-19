//
//  BubbleLauncherController.swift
//  BubbleHeroEngine
//
//  Created by Yunpeng Niu on 19/02/18.
//  Copyright © 2018 Yunpeng Niu. All rights reserved.
//

import UIKit

/**
 Extension for `ViewController`, which controls the logic about launching & shooting
 bubbles.

 - Author: Niu Yunpeng @ CS3217
 - Date: Feb 2018
 */
class BubbleLauncherController {
    /// Sources for the bubbles being launched.
    var provider = BubbleProvider()
    /// The place where the shooting bubbles are launched.
    let bubbleLauncher: UIButton
    /// The delegate for `ShootingBubbleController`.
    var shootingController: ShootingBubbleController?
    /// The delegate for `BubbleArenaController`
    var arenaController: BubbleArenaControllerDelegate?

    init(bubbleLauncher: UIButton) {
        self.bubbleLauncher = bubbleLauncher
        updateBubbleLauncher()
    }

    /// Handles the launch of a bubble when the user single-taps on the screen.
    /// - Parameter sender: The sender of the single-tap gesture.
    func handleBubbleLaunch(at location: CGPoint) {
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
        guard let bubble = arenaController?.addMovingBubble(of: type, center: bubbleLauncher.center) else {
            return
        }

        // Creates a `GameObject` for the shooted bubble and register it into the
        // `PhysicsEngine` (to take over the control).
        let gameObject = GameObject(view: bubble, radius: BubbleCell.radius)
        gameObject.speed = getShootSpeed(by: angle)
        shootingController?.addShootedBubble(object: gameObject, type: type)
    }

    /// Updates the status of the `bubbleLauncher` after one bubble in shooted.
    private func updateBubbleLauncher() {
        let type = provider.pop()
        bubbleLauncher.setImage(Helpers.toBubbleImage(of: type), for: .normal)
    }
}
