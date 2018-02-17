//
//  BubbleFallController.swift
//  BubbleHeroEngine
//
//  Created by Yunpeng Niu on 17/02/18.
//  Copyright © 2018 Yunpeng Niu. All rights reserved.
//

import UIKit

/**
 Controls how the unattached bubbles will fall out of the screen.
 */
class BubbleFallController {
    private let obj: UIView
    private var displayLink: CADisplayLink?
    private var speed: CGFloat = 0

    init(for obj: UIView) {
        self.obj = obj
    }

    func fall() {
        speed = 0
        displayLink = CADisplayLink(target: self, selector: #selector(step))
        displayLink?.add(to: .current, forMode: .defaultRunLoopMode)
    }

    @objc private func step(displayLink: CADisplayLink) {
        checkTouchButtom()
        let frame = obj.frame
        let newY = frame.minY + speed
        obj.frame = CGRect(x: frame.minX, y: newY, width: frame.width, height: frame.height)
        speed += Settings.gravityConstant
    }

    private func checkTouchButtom() {
        if obj.frame.maxY >= UIScreen.main.bounds.height {
            obj.removeFromSuperview()
            displayLink?.invalidate()
            displayLink = nil
        }
    }
}
