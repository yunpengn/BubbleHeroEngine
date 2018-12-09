//
//  PhysicsObject.swift
//  BubbleHero
//
//  Created by Yunpeng Niu on 28/02/18.
//  Copyright © 2018 Yunpeng Niu. All rights reserved.
//

import UIKit

/**
 Each object registered in the `PhysicsEngine` must be a `PhysicsBody`. A
 `PhysicsObject` is a class which conforms to the `PhysicsBody` protocol.
 Thus, it possesses some physics properties, like position, velocity &
 acceleration, etc.

 - Author: Niu Yunpeng @ CS3217
 - Date: Feb 2018
 */
open class PhysicsObject: PhysicsBody {
    public let view: UIView
    public var acceleration = CGVector.zero
    public var velocity = CGVector.zero
    public var center: CGPoint
    public let radius: CGFloat
    public var isCollidable = true
    public var isAttractable = true

    // An array of objects that it is attached to.
    public var attachedWith: [PhysicsBody] = []

    /// Creates a `PhysicsObject` by associating it with a `UIView` object.
    /// - Parameters:
    ///    - center: The coordinate for the center of the `PhysicsObject`.
    ///    - radius: The radius of this `PhysicsObject`.
    ///    - view: The `UIView` object associated with.
    public init(center: CGPoint, radius: CGFloat, view: UIView) {
        self.center = center
        self.radius = radius
        self.view = view
    }

    /// Creates a `PhysicsObject` with the default setting that its visual center is its
    /// actual center.
    convenience init(view: UIView) {
        let center = CGPoint(x: view.frame.midX, y: view.frame.midY)
        let radius = view.frame.width / 2
        self.init(center: center, radius: radius, view: view)
    }

    public func move() {
        move(by: velocity)
        velocity = CGVector(dx: velocity.dx + acceleration.dx, dy: velocity.dy + acceleration.dy)
    }

    public func move(by delta: CGVector) {
        center = CGPoint(x: center.x + delta.dx, y: center.y + delta.dy)
    }

    public func move(to point: CGPoint) {
        center = point
    }

    public func stop() {
        velocity = CGVector.zero
        acceleration = CGVector.zero
    }

    public func brake() {
        velocity = CGVector.zero
    }

    public func didCollideWith(_ object: PhysicsBody) -> Bool {
        guard isCollidable && object.isCollidable else {
            return false
        }
        let sqrX = (center.x - object.center.x) * (center.x - object.center.x)
        let sqrY = (center.y - object.center.y) * (center.y - object.center.y)
        let sqrRadius = (radius + object.radius) * (radius + object.radius)
        return sqrX + sqrY <= sqrRadius * EngineSettings.collisionThreshold
    }

    public func attachTo(_ object: PhysicsBody) {
        guard object !== self && !isAttachedTo(object) else {
            return
        }
        attachedWith.append(object)
    }

    public func isAttachedTo(_ object: PhysicsBody) -> Bool {
        return attachedWith.contains { $0 === object }
    }

    public func canAttachWith(object: PhysicsBody) -> Bool {
        let sqrX = (center.x - object.center.x) * (center.x - object.center.x)
        let sqrY = (center.y - object.center.y) * (center.y - object.center.y)
        let sqrRadius = (radius + object.radius) * (radius + object.radius)
        return sqrX + sqrY <= sqrRadius * EngineSettings.attachmentThreshold
    }

    public func reflectX() {
        velocity = CGVector(dx: -velocity.dx, dy: velocity.dy)
    }

    public func reflectY() {
        velocity = CGVector(dx: velocity.dx, dy: -velocity.dy)
    }

    public var isStatic: Bool {
        return velocity == CGVector.zero && acceleration == CGVector.zero
    }
}
