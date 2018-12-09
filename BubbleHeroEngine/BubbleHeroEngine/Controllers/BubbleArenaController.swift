//
//  ViewController.swift
//  BubbleHeroEngine
//
//  Created by Yunpeng Niu on 13/02/18.
//  Copyright © 2018 Yunpeng Niu. All rights reserved.
//

import UIKit

/**
 The main controller for the game playing view. It also controls the `bubbleArena`
 which is a collection view of all the remaining bubbles.

 - Author: Niu Yunpeng @ CS3217
 - Date: Feb 2018
 */
class BubbleArenaController: UIViewController {
    /// The collection view that shows all bubbles.
    @IBOutlet weak var bubbleArena: UICollectionView!
    /// The place where the shooting bubbles are launched.
    @IBOutlet weak var bubbleLauncher: UIButton!

    /// The `Level` object as the access point to model.
    let level = SampleData.loadSampleLevel()
    /// The controller for shooted bubbles.
    var shootingController: ShootingBubbleController?
    /// The controller for bubble launcher.
    private var launcherController: BubbleLauncherController?

    /// Always hide the status bar (since in a full-screen game).
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bubbleArena.delegate = self
        bubbleArena.dataSource = self

        shootingController = ShootingBubbleController(level: level, bubbleArena: bubbleArena)
        shootingController?.arenaController = self
        launcherController = BubbleLauncherController(bubbleLauncher: bubbleLauncher)
        launcherController?.arenaController = self
        
        shootingController?.launcherController = launcherController
        launcherController?.shootingController = shootingController
    }

    /// Handles the launch of a bubble when the user single-taps on the screen.
    /// - Parameter sender: The sender of the single-tap gesture.
    @IBAction func handleBubbleLaunch(_ sender: UITapGestureRecognizer) {
        launcherController?.handleBubbleLaunch(at: sender.location(in: view))
    }
}

extension BubbleArenaController: UICollectionViewDelegate {

}

extension BubbleArenaController: UICollectionViewDelegateFlowLayout {
    /// Sets the size of each cell (to fit 11/12 cells per row).
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: BubbleCell.diameter, height: BubbleCell.diameter)
    }

    /// Sets the offset of each row.
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let leftRight = (section % 2 == 0) ? 0 : BubbleCell.leftOffset
        let bottom = -BubbleCell.rowOffset
        return UIEdgeInsets(top: 0, left: leftRight, bottom: bottom, right: leftRight)
    }
}

extension BubbleArenaController: UICollectionViewDataSource {
    /// Sets the number of sections to be 12 (i.e., 12 rows of bubbles).
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return level.numOfRows
    }

    /// Sets the number cells per row to be 11 or 12 (odd/even row).
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (section % 2 == 0) ? level.evenCount : level.oddCount
    }

    /// Data source for each cell.
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = getReusableBubbleCell(for: indexPath)
        guard let bubble = level.getBubbleAt(row: indexPath.section, column: indexPath.row) else {
            // Early exit if the cell is empty.
            return cell
        }

        // Fills the cell with the correct color of the bubble.
        cell.fill(image: Helpers.toBubbleImage(of: bubble.type))
        // Registers the cell with the physics engine.
        let gameObject = GameObject(view: cell, radius: BubbleCell.radius)
        shootingController?.addRemainingBubble(object: gameObject, bubble: bubble)
        return cell
    }

    /// Gets a reusable cell for preparing a new cell.
    private func getReusableBubbleCell(for indexPath: IndexPath) -> BubbleCell {
        guard let cell = bubbleArena.dequeueReusableCell(withReuseIdentifier: "bubble", for: indexPath)
            as? BubbleCell else {
                fatalError("Unable to dequeue a reusable cell.")
        }
        cell.clear()
        return cell
    }
}
