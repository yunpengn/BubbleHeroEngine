//
//  MagneticBody.swift
//  BubbleHero
//
//  Created by Yunpeng Niu on 02/03/18.
//  Copyright © 2018 Yunpeng Niu. All rights reserved.
//

/**
 `MagneticBody` is a special kind of `PhysicsBody` that obeys a (simplified form
 of) Coulomb's law. Due to Coulomb force, there exists a varying attraction between
 a `MagneticBody` and a non-static `PhysicsBody`, whose magnitude is dependent on
 the distance between them.

 In addition, we implement a `canAttract` propert whose default value is true. In
 certain situations, a magnetic body may lose its magnetism temporarily. This is to
 simulate the following real-world physics: For each material of magnet, there is a
 Curie temperature, or temperature at which the heat will destroy the polarization
 of the material, causing it to loses its magnetic properties.

 - Author: Niu Yunpeng @ CS3217
 - Date: March 2018
 */
public protocol MagneticBody: PhysicsBody {
    /// Decides whether this magnetic body can attract other bodies now, whose
    /// default value is true.
    var canAttract: Bool { get set }

    /// Attracts another `PhysicsBody` by moving its position.
    /// - Parameter object: The object being attracted.
    func attract(object: PhysicsBody)
}
