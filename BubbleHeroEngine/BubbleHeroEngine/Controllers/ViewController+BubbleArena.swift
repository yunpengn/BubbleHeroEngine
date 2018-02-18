//
//  ViewController+BubbleArena.swift
//  BubbleHeroEngine
//
//  Created by Yunpeng Niu on 13/02/18.
//  Copyright © 2018 Yunpeng Niu. All rights reserved.
//

import UIKit

/**
 Extension for `ViewController`. This extension is the delegate for the grid of bubbles.

 - Author: Niu Yunpeng @ CS3217
 - Date: Feb 2018
 */
extension ViewController: UICollectionViewDelegate {

}

/**
 Extension for `ViewController`. This extension controls the size of the cells.

 - Author: Niu Yunpeng @ CS3217
 - Date: Feb 2018
 */
extension ViewController: UICollectionViewDelegateFlowLayout {
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

/**
 Extension for `ViewController`. This extension is the data source for the grid of bubbles.

 - Author: Niu Yunpeng @ CS3217
 - Date: Feb 2018
 */
extension ViewController: UICollectionViewDataSource {
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
        cell.fill(image: toBubbleImage(of: bubble.type))
        // Registers the cell with the physics engine.
        let gameObject = GameObject(view: cell, radius: BubbleCell.radius)
        engine.registerGameObject(gameObject)
        // Keeps a record of the created `GameObject`.
        gameObjects.addRemainingBubble(object: gameObject, bubble: <#T##FilledBubble#>)
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
