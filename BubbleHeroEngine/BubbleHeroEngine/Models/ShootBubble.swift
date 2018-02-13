//
//  Bubble.swift
//  BubbleHeroEngine
//
//  Created by Yunpeng Niu on 13/02/18.
//  Copyright © 2018 Yunpeng Niu. All rights reserved.
//

/**
 `Bubble` is the atomic unit in the game. It belongs to a
 certain `BubbleType`. Apart from that, there is not much
 information attached to it.
 */
class ShootBubble {
    /// The type of this bubble.
    let type: BubbleType

    /// Creates a bubble of a certain `BubbleType`.
    /// - Parameter type: The type of the bubble being created.
    init(type: BubbleType) {
        self.type = type
    }
}
