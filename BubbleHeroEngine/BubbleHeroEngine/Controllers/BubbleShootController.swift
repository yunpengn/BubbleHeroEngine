//
//  BubbleShootController.swift
//  BubbleHeroEngine
//
//  Created by Yunpeng Niu on 14/02/18.
//  Copyright © 2018 Yunpeng Niu. All rights reserved.
//

import UIKit

class BubbleShootController {
    private var displayLink: CADisplayLink?
    private var obj: UIView
    private var xDisplacement = CGFloat(0)
    private var yDisplacement = CGFloat(0)

    init(for obj: UIView) {
        self.obj = obj
    }

    func moveObject(_ obj: UIView, atX xDisplacement: CGFloat, atY yDisplacement: CGFloat) {
        stopDisplayLink()
        self.obj = obj
        self.xDisplacement = xDisplacement
        self.yDisplacement = yDisplacement
        displayLink = CADisplayLink(target: self, selector: #selector(step))
        displayLink?.add(to: .current, forMode: .defaultRunLoopMode)
    }

    @objc private func step(displayLink: CADisplayLink) {
        checkHorizontalReflect()
        checkTopStick()
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
            xDisplacement = 0
            yDisplacement = 0
            stopDisplayLink()
        }
    }

    private func stopDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }
}
