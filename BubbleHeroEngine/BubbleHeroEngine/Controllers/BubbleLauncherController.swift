//
//  BubbleLauncherController.swift
//  BubbleHeroEngine
//
//  Created by Yunpeng Niu on 19/02/18.
//  Copyright © 2018 Yunpeng Niu. All rights reserved.
//

import UIKit

/**
 Controls the logic regarding the bubble launcher: continously randomly generate available
 bubbles to launch, launch the bubble at user-specific angle, and then pass control to the
 `ShootingBubbleController` and `PhysicsEngine`.

 - Author: Niu Yunpeng @ CS3217
 - Date: Feb 2018
 */
class BubbleLauncherController {
    /// Sources for the bubbles being launched.
    var provider = BubbleProvider()
    /// The place where the shooting bubbles are launched.
    let bubbleLauncher: UIButton
    /// The geometric center of `bubbleLauncher`.
    let launcherCenter: CGPoint
    /// The delegate for `ShootingBubbleController`.
    var shootingController: ShootingBubbleControllerDelegate?
    /// The delegate for `BubbleArenaController`
    weak var arenaController: BubbleArenaControllerDelegate?

    /// Creates a controller for a certain bubble launcher.
    /// - bubbleLauncher: The bubble launcher representation in view.
    init(bubbleLauncher: UIButton) {
        self.bubbleLauncher = bubbleLauncher
        self.launcherCenter = bubbleLauncher.center
        updateBubbleLauncher()
    }

    /// Handles the launch of a bubble when the user single-taps on the screen.
    /// - Parameter location: The location of the single-tap gesture.
    func handleBubbleLaunch(at location: CGPoint) {
        // Only accepts upward launching of bubble.
        guard launcherCenter.y >= location.y + Settings.launchVerticalLimit else {
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
        let deltaX = launcherCenter.x - point.x
        let deltaY = launcherCenter.y - point.y
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
        guard let bubble = arenaController?.addMovingBubble(of: type, center: launcherCenter) else {
            return
        }

        // Creates a `GameObject` for the shooted bubble.
        let gameObject = GameObject(view: bubble, radius: BubbleCell.radius)
        gameObject.speed = getShootSpeed(by: angle)
        // Lets the physics engine take over the control.
        shootingController?.addShootedBubble(object: gameObject, type: type)
    }

    /// Updates the status of the `bubbleLauncher` after one bubble in shooted.
    private func updateBubbleLauncher() {
        let type = provider.pop()
        bubbleLauncher.setImage(Helpers.toBubbleImage(of: type), for: .normal)
    }
}
