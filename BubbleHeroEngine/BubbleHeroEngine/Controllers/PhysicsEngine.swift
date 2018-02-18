//
//  PhysicsEngine.swift
//  BubbleHeroEngine
//
//  Created by Yunpeng Niu on 18/02/18.
//  Copyright © 2018 Yunpeng Niu. All rights reserved.
//

import UIKit

/**
 This class implements a simplified 2D physics engine which supports simple object
 movement and collision detection.

 ## Object movement:
 Any object can start moving by giving it an initial speed or giving it an initial
 acceleration. Notice that since `GameObject` does not have a mass, it will not obey
 Newton's 2nd law and thus all acceleration must be explicitly given rather than derived
 from an external force.

 Notice that since we are in the 2D world, gravitational field is not taken into
 consideration. However, the gavitational force can be modelled by manually giving the
 object an acceleration equal to the gravitational constant.

 ## Collision detection:
 Since we only consider the 2D world, all objects only has size, but not volume. Also,
 all objects are modelled as a perfect circle. Thus, we can simply compare the distance
 between the centers of two objects with the sum of their radii to check whether any
 collision occurs between them.

 - Author: Niu Yunpeng @ CS3217
 - Date: Feb 2018
 */
class PhysicsEngine {
    /// The delegate of the `ViewController` which handles the logic specific to the game.
    var delegate: ControllerDelegate?
    /// A list of all `GameObject`s controlled by this `PhysicsEngine`.
    private var gameObjects: [GameObject] = []

    /// Initializes a physics engine.
    init() {
        let displayLink = CADisplayLink(target: self, selector: #selector(step))
        displayLink.add(to: .current, forMode: .defaultRunLoopMode)
    }

    /// Registers a new `GameObject` into this `PhysicsEngine`. The movement
    /// and collision detection of this `GameObject` will be managed by this
    /// `PhysicsEngine` from now on. Each `GameObject` should be registered
    /// in at most one `PhysicsEngine`.
    /// - Parameter toRegister: The `GameObject` being registered.
    func registerGameObject(_ toRegister: GameObject) {
        gameObjects.append(toRegister)
    }

    /// Deregisters a `GameObject` from this `PhysicsEngine`, who will not be in
    /// charge of its movement and collision detection from on. This method will
    /// do nothing if the `GameObject` was not registered with this `PhysicsEngine`
    /// before.
    /// - Parameter toDeregister: The `GameObject` being deregistered.
    func deregisterGameObject(_ toDeregister: GameObject) {
        // We have to use identity operator because there is no other possible
        // way to identify the most generic form of a `GameObject`.
        gameObjects = gameObjects.filter { $0 !== toDeregister }
    }

    /// Fully removes a `GameObject` in the following steps:
    /// 1. Stops the movement of the `GameObject`.
    /// 2. Makes the `GameObject` disappear from the view.
    /// 3. Deregisters the `GameObject` from this `GameEngine`.
    /// - Parameter toRemove: The `GameObject` being removed.
    func removeGameObject(_ toRemove: GameObject) {
        toRemove.stop()
        toRemove.disappear()
        deregisterGameObject(toRemove)
    }

    /// A "step" that each registered `GameObject` should perform per frame of the
    /// `CADisplayLink`. This object includes the control over object movement and
    /// collision detection.
    /// - Parameter displayLink: The timer object that synchronizes the drawing to
    /// the refresh rate of the display.
    @objc private func step(displayLink: CADisplayLink) {
        for object in gameObjects {
            guard !object.isStatic else {
                continue
            }
            object.move()
            checkHorizontalReflect(of: object)
            checkTouchButtom(of: object)
            checkTouchTop(of: object)
            checkCollision(of: object)
        }
    }

    /// Reflects (by reversing the x-component of its speed) when it touches the left
    /// or right side of the screen (acting as the "wall").
    /// - Parameter object: The `GameObject` being checked.
    private func checkHorizontalReflect(of object: GameObject) {
        if object.centerX - object.radius <= 0 || object.centerX + object.radius >= screenWidth {
            object.reflectX()
        }
    }

    /// Removes the `GameObject` when it touches the buttom of the screen.
    /// - Parameter object: The `GameObject` being checked.
    private func checkTouchButtom(of object: GameObject) {
        if object.centerY + object.radius >= screenHeight {
            removeGameObject(object)
        }
    }

    /// Stops the `GameObject` and notifies when it touches the top of the screen.
    /// - Parameter object: The `GameObject` being checked.
    private func checkTouchTop(of object: GameObject) {
        if object.centerY - object.radius <= 0 {
            removeGameObject(object)
            delegate?.handleCollision(by: object)
        }
    }

    /// Checks whether this `GameObject` collides with any other `GameObject`
    /// registered in the same `PhysicsEngine`.
    /// - Parameter object: The `GameObject` being checked.
    private func checkCollision(of object: GameObject) {
        for otherObject in gameObjects {
            if otherObject !== object && willCollide(lhs: object, rhs: otherObject) {
                removeGameObject(object)
                delegate?.handleCollision(by: object)
            }
        }
    }

    /// Checks whether two `GameObject`s will collide with each other.
    /// - Parameters:
    ///    - lhs: One of the two `GameObject`s to check.
    ///    - rhs: The other `GameObject` to check.
    /// - Returns: true if they will collide.
    private func willCollide(lhs: GameObject, rhs: GameObject) -> Bool {
        let sqrX = (lhs.centerX - rhs.centerX) * (lhs.centerX - rhs.centerX)
        let sqrY = (lhs.centerY - rhs.centerY) * (lhs.centerY - rhs.centerY)
        let sqrRadius = (lhs.radius + rhs.radius) * (lhs.radius + rhs.radius)
        return sqrX + sqrY <= sqrRadius * Settings.collisionThreshold
    }

    /// The height of the screen size.
    private var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }

    /// The width of the screen size.
    private var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
}
