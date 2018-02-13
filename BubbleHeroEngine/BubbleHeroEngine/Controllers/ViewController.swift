//
//  ViewController.swift
//  BubbleHeroEngine
//
//  Created by Yunpeng Niu on 13/02/18.
//  Copyright © 2018 Yunpeng Niu. All rights reserved.
//

import UIKit

/**
The main controller for the game view.

 - Author: Niu Yunpeng @ CS3217
 - Date: Feb 2018
 */
class ViewController: UIViewController {
    /// The collection view that shows all bubbles.
    @IBOutlet weak var bubbleArena: UICollectionView!
    /// The place where the shooting bubbles are launched.
    @IBOutlet weak var bubbleLauncher: UIButton!
    
    /// The `Level` object as the access point to model.
    var level = SampleData.loadSampleLevel()

    // Always hide the status bar (since in a full-screen game).
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        bubbleArena.delegate = self
        bubbleArena.dataSource = self
    }

    /// Handles the launch of a bubble when the user single-taps on the screen.
    @IBAction func handleBubbleLaunch(_ sender: UITapGestureRecognizer) {
        let angle = getShootAngle(by: sender.location(in: view))
    }

    /// Given a point at which the user touches, computes the initial angle of the
    /// bubble being shooted.
    ///
    /// The angle computed will increment when rotating anti-clockwise in the range
    /// of [0, 180]. Notice that we only allow the user to launch bubbles upwards.
    /// - Parameter point: The point at which the user touches.
    /// - Returns: The initial angle of the launched angle.
    private func getShootAngle(by point: CGPoint) -> CGFloat {
        let deltaX = bubbleLauncher.center.x - point.x
        let deltaY = bubbleLauncher.center.y - point.y
        let newDeltaY = deltaY > 0 ? deltaY : 0
        return atan2(newDeltaY, deltaX) / CGFloat.pi * 180
    }
}
