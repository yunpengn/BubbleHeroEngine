//
//  BubbleLauncherController+Delegate.swift
//  BubbleHeroEngine
//
//  Created by Yunpeng Niu on 20/02/18.
//  Copyright © 2018 Yunpeng Niu. All rights reserved.
//

/**
 Extension for `BubbleLauncherController`, which supports some functionalities to act as
 a delegate.

 - Author: Niu Yunpeng @ CS3217
 - Date: Feb 2018
 */
extension BubbleLauncherController: BubbleLauncherControllerDelegate {
    func markReadyForNextLaunch() {
        readyForNextLaunch = true
    }
}

protocol BubbleLauncherControllerDelegate: AnyObject {
    /// Informs the `BubbleLauncherController` that it can begin to handle the next
    // launch of shooting bubble.
    func markReadyForNextLaunch()
}
