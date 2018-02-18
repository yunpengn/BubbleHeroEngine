//
//  PhysicsEngine.swift
//  BubbleHeroEngine
//
//  Created by Yunpeng Niu on 18/02/18.
//  Copyright © 2018 Yunpeng Niu. All rights reserved.
//

import Foundation

/**
 This class implements a simplified 2D physics engine which supports simple object
 movement and collision detection.

 ## Object movement:
 Any object can start moving by giving it an initial speed or giving it a constant
 acceleration.
 Also, gravitational field is not taken into consideration. However, you can

 ## Collision detection:
 Since we only consider the 2D world, all objects only has size, but not volume. Also,
 all objects are modelled as a perfect circle. Thus, we can simply compare the distance
 between the centers of two objects with the sum of their radii to check whether any
 collision occurs between them.

 - Author: Niu Yunpeng @ CS3217
 - Date: Feb 2018
 */
class PhysicsEngine {
    
}
