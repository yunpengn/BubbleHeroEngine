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
    /// A list of all `GameObject`s controlled by this `PhysicsEngine`.
    private var gameObjects: [GameObject] = []

    init() {
        let displayLink = CADisplayLink(target: self, selector: #selector(step))
        displayLink.add(to: .current, forMode: .defaultRunLoopMode)
    }

    func registerGameObject(_ toRegister: GameObject) {
        gameObjects.append(toRegister)
    }

    func deregisterGameObject(_ toDeregister: GameObject) {

    }

    @objc private func step(displayLink: CADisplayLink) {
        for object in gameObjects {
            object.move()
        }
    }

    /// Stops and disapears the `GameObject` when it touches the buttom of the screen.
    /// - Parameter object: The `GameObject` being checked.
    private func checkTouchButtom(of object: GameObject) {
        if object.centerY + object.radius >= screenHeight {
            object.stop()
            object.disappear()
            deregisterGameObject(object)
        }
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
