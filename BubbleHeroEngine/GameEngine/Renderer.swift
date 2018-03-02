//
//  Render.swift
//  BubbleHero
//
//  Created by Yunpeng Niu on 28/02/18.
//  Copyright © 2018 Yunpeng Niu. All rights reserved.
//

/**
 Any object that conforms to `Renderer` protocol can act as the rendering engine for
 a physics engine.

 - Author: Niu Yunpeng @ CS3217
 - Date: Feb 2018
 */
public protocol Renderer {
    /// Render a `PhysicsBody`, such as updating its location and shape in the view.
    public func render(for object: PhysicsBody)

    /// Makes a `PhysicsBody` appear by adding its associated `UIView` object to a view.
    public func appear(_ object: PhysicsBody)

    /// Makes a `PhysicsBody` disappear by removing its associated `UIView` object from
    /// its `superview`.
    public func disappear(_ object: PhysicsBody)
}
