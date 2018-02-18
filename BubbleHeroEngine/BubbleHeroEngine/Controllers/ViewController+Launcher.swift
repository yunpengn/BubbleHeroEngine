//
//  ViewController+Launcher.swift
//  BubbleHeroEngine
//
//  Created by Yunpeng Niu on 14/02/18.
//  Copyright © 2018 Yunpeng Niu. All rights reserved.
//

import UIKit

extension ViewController {
    /// Handles the launch of a bubble when the user single-taps on the screen.
    @IBAction func handleBubbleLaunch(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        guard bubbleLauncher.center.y >= location.y + Settings.launchVerticalLimit else {
            return
        }
        let angle = getShootAngle(by: location)
        moveBubble(at: angle)
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

    private func moveBubble(at angle: CGFloat) {
        let bubble = movingBubbleFactory(of: provider.peek(), center: bubbleLauncher.center)
        let xDisplacement = -Settings.shootSpeed * cos(angle)
        let yDisplacement = -Settings.shootSpeed * sin(angle)
        let renderer = BubbleShootController(for: bubble, type: provider.peek(), within: self)
        renderer.moveObject(atX: xDisplacement, atY: yDisplacement)
    }

    func updateBubbleLauncher() {
        let type = provider.pop()
        bubbleLauncher.setImage(toBubbleImage(of: type), for: .normal)
    }
}
