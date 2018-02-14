//
//  BubbleShootController.swift
//  BubbleHeroEngine
//
//  Created by Yunpeng Niu on 14/02/18.
//  Copyright © 2018 Yunpeng Niu. All rights reserved.
//

import UIKit

class BubbleShootController {
    private let obj: UIView
    private let type: BubbleType
    private let arenaDelegate: ArenaDelegate

    private var displayLink: CADisplayLink?
    private var xDisplacement = CGFloat(0)
    private var yDisplacement = CGFloat(0)

    init(for obj: UIView, type: BubbleType, within delegate: ArenaDelegate) {
        self.obj = obj
        self.type = type
        self.arenaDelegate = delegate
    }

    func moveObject(atX xDisplacement: CGFloat, atY yDisplacement: CGFloat) {
        stopDisplayLink()
        self.xDisplacement = xDisplacement
        self.yDisplacement = yDisplacement
        displayLink = CADisplayLink(target: self, selector: #selector(step))
        displayLink?.add(to: .current, forMode: .defaultRunLoopMode)
    }

    @objc private func step(displayLink: CADisplayLink) {
        checkHorizontalReflect()
        checkTopStick()
        checkCollision()
        let frame = obj.frame
        let newX = frame.minX + xDisplacement
        let newY = frame.minY + yDisplacement
        obj.frame = CGRect(x: newX, y: newY, width: frame.width, height: frame.height)
    }

    private func checkHorizontalReflect() {
        if obj.frame.minX <= 0 || obj.frame.maxX >= UIScreen.main.bounds.width {
            xDisplacement = -xDisplacement
        }
    }

    private func checkTopStick() {
        if obj.frame.minY <= 0 {
            stopDisplayLink()
        }
    }

    private func checkCollision() {
        let point = CGPoint(x: obj.frame.minX, y: obj.frame.minY)
        let neighbors = arenaDelegate.getBubbleNear(by: point)
        if !neighbors.isEmpty {
            stopDisplayLink()
            obj.removeFromSuperview()
            arenaDelegate.fillNearByCell(by: point, type: type)
        }
    }

    private func stopDisplayLink() {
        xDisplacement = 0
        yDisplacement = 0
        displayLink?.invalidate()
        displayLink = nil
    }
}
