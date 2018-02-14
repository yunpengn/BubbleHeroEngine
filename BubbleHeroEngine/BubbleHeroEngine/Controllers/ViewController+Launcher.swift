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
        let angle = getShootAngle(by: sender.location(in: view))
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
        let bubble = shootBubbleFactory(at: angle)
        let xDisplacement = -Settings.speed * cos(angle)
        let yDisplacement = -Settings.speed * sin(angle)
        let renderer = Renderer(for: bubble)
        renderer.moveObject(bubble, atX: xDisplacement, atY: yDisplacement)
    }

    private func shootBubbleFactory(at angle: CGFloat) -> UIImageView {
        let image = toBubbleImage(of: provider.pop().type)
        let imageView = UIImageView(image: image)
        let x = bubbleLauncher.center.x - BubbleCell.radius
        let y = bubbleLauncher.center.y - BubbleCell.radius
        imageView.frame = CGRect(x: x, y: y, width: BubbleCell.diameter, height: BubbleCell.diameter)
        view.addSubview(imageView)
        return imageView
    }

    private func updateBubbleLauncher() {
        let type = provider.peek().type
        bubbleLauncher.setImage(toBubbleImage(of: type), for: .normal)
    }
}
