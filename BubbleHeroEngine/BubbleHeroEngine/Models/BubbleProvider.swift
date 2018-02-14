//
//  BubbleProvider.swift
//  BubbleHeroEngine
//
//  Created by Yunpeng Niu on 13/02/18.
//  Copyright © 2018 Yunpeng Niu. All rights reserved.
//

import Darwin

/**
 Provides random `BubbleType`s continously, i.e., acts as the
 source for bubble launcher.

 - Author: Niu Yunpeng @ CS3217
 - Date: Feb 2018
 */
struct BubbleProvider {
    var current = BubbleType.getRandomType()

    func peek() -> BubbleType {
        return current
    }

    mutating func pop() -> BubbleType {
        current = BubbleType.getRandomType()
        return current
    }
}
