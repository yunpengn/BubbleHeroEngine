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

    /// The physics engine to support the game.
    let engine = PhysicsEngine()
    /// The `Level` object as the access point to model.
    let level = SampleData.loadSampleLevel()
    /// Sources for the bubbles being launched.
    var provider = BubbleProvider()

    /// Stores all the shooted bubbles (but not collided with any other bubble yet).
    /// This array acts as a mapping between these shooted bubbles and corresponding
    /// `GameObject`s in the `PhysicsEngine`.
    var shootedBubbles: [(object: GameObject, type: BubbleType)] = []

    /// Always hide the status bar (since in a full-screen game).
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bubbleArena.delegate = self
        bubbleArena.dataSource = self
        engine.delegate = self
        updateBubbleLauncher()
    }
}
