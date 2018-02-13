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

    /// The `Level` object as the access point to model.
    var level = Level()

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
