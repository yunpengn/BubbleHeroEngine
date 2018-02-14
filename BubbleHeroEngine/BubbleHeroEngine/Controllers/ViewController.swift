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
class ViewController: UIViewController, ArenaDelegate {
    /// The collection view that shows all bubbles.
    @IBOutlet weak var bubbleArena: UICollectionView!
    /// The place where the shooting bubbles are launched.
    @IBOutlet weak var bubbleLauncher: UIButton!
    
    /// The `Level` object as the access point to model.
    let level = SampleData.loadSampleLevel()
    /// Sources for the bubbles being launched.
    var provider = BubbleProvider()

    // Always hide the status bar (since in a full-screen game).
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        bubbleArena.delegate = self
        bubbleArena.dataSource = self
        updateBubbleLauncher()
    }

    /// Gets an image of the bubble cell according to its type.
    /// - Parameter type: The type of the bubble
    /// - Returns: The background image corresponding to this type.
    func toBubbleImage(of type: BubbleType) -> UIImage {
        switch type {
        case .blue:
            return #imageLiteral(resourceName: "bubble-blue")
        case .green:
            return #imageLiteral(resourceName: "bubble-green")
        case .orange:
            return #imageLiteral(resourceName: "bubble-orange")
        case .red:
            return #imageLiteral(resourceName: "bubble-red")
        }
    }

    func getBubbleNear(by point: CGPoint) -> [FilledBubble] {
        let row = Int(round(point.y / BubbleCell.height))
        let leftOffset = (row % 2 == 0) ? 0 : BubbleCell.leftOffset
        let column = Int(round((point.x - leftOffset) / BubbleCell.diameter))
        let neighbors = level.getNeighborsOf(row: row, column: column)

        return neighbors.filter { bubble in
            return shouldCollide(bubble, with: point)
        }
    }

    private func shouldCollide(_ bubble: FilledBubble, with point: CGPoint) -> Bool {
        let leftOffset = (bubble.row % 2 == 0) ? 0 : BubbleCell.leftOffset
        let bubbleX = CGFloat(bubble.column) * BubbleCell.diameter + leftOffset
        let bubbleY = CGFloat(bubble.row) * BubbleCell.height
        let deltaX = bubbleX - point.x
        let deltaY = bubbleY - point.y
        return deltaX * deltaX + deltaY * deltaY
            <= BubbleCell.diameterSquare * Settings.collisionThreshold
    }

    func fillNearByCell(by point: CGPoint, type: BubbleType) {
        let row = Int(round(point.y / BubbleCell.height))
        let leftOffset = (row % 2 == 0) ? 0 : BubbleCell.leftOffset
        let column = Int(round((point.x - leftOffset) / BubbleCell.diameter))

        let newBubble = FilledBubble(row: row, column: column, type: type)
        level.addOrUpdateBubble(newBubble)
        bubbleArena.reloadItems(at: [IndexPath(row: column, section: row)])
        removeSameColorNeighbors(from: newBubble)

    }

    private func removeSameColorNeighbors(from bubble: FilledBubble) {
        var sameColorBubbles = level.getSameColorConnectedItemsOf(bubble)
        sameColorBubbles.append(bubble)
        if sameColorBubbles.count >= 3 {
            level.deleteBubbles(sameColorBubbles)
            let indexPaths = sameColorBubbles.map { bubble in
                return IndexPath(row: bubble.column, section: bubble.row)
            }
            bubbleArena.reloadItems(at: indexPaths)
        }
    }
}

protocol ArenaDelegate {
    /// Computes the bubbles nearby a point. The bubble is considered to be
    /// "nearby" if the following condition is `true`:
    ///
    /// If there exists a bubble centered at `point`, the distances between
    /// their centers are smaller or equal to the diameter of a bubble.
    /// - Parameter point: The point being computed
    /// - Returns: an array of neighboring bubbles if there exists; nil otherwise.
    func getBubbleNear(by point: CGPoint) -> [FilledBubble]

    /// Given a specific location, fills the the closest available empty cell
    /// with a certain type of bubble.
    /// - Parameters:
    ///    - point: The location given
    ///    - type: The `BubbleType` that will be filled with
    func fillNearByCell(by point: CGPoint, type: BubbleType)
}
