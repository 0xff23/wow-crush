//
//  Level.swift
//  wowCrunch
//
//  Created by Kirill G on 1/26/18.
//  Copyright © 2018 Kirill. All rights reserved.
//

import Foundation

// MARK: - Dimensions constants
let numColums = 9
let numRows = 9

private var possibleSwaps = Set<Swap>()

class Level {
    
    fileprivate var icons = Array2D<Icons>(columns: numColums, rows: numRows)
    fileprivate var tiles = Array2D<Tile>(columns: numColums, rows: numRows)
    
    func tileAt(column: Int, row: Int) -> Tile? {
        assert(column >= 0 && column < numColums)
        assert(row >= 0 && row < numRows)
        return tiles[column, row]
    }
    
    func iconAt(column: Int, row: Int) -> Icons? {
        assert(column >= 0 && column < numColums)
        assert(row >= 0 && row < numRows)
        return icons[column, row]
    }
    
    private func hasChainAt(column: Int, row: Int) -> Bool {
        let iconType = icons[column, row]!.iconType
        
        // Horizontal chain check
        var horzLength = 1
        
        // Left
        var i = column - 1
        while i >= 0 && icons[i, row]?.iconType == iconType {
            i -= 1
            horzLength += 1
        }
        
        // Right
        i = column + 1
        while i < numColums && icons[i, row]?.iconType == iconType {
            i += 1
            horzLength += 1
        }
        if horzLength >= 3 { return true }
        
        // Vertical chain check
        var vertLength = 1
        
        // Down
        i = row - 1
        while i >= 0 && icons[column, i]?.iconType == iconType {
            i -= 1
            vertLength += 1
        }
        
        // Up
        i = row + 1
        while i < numRows && icons[column, i]?.iconType == iconType {
            i += 1
            vertLength += 1
        }
        return vertLength >= 3
    }
    
    func detectPossibleSwaps() {
        var set = Set<Swap>()
        
        for row in 0..<numRows {
            for column in 0..<numColums {
                if let icon = icons[column, row] {
                    // Is it possible to swap this icon with the one on the right?
                    if column < numColums - 1 {
                        // Have a icon in this spot? If there is no tile, there is no icon.
                        if let other = icons[column + 1, row] {
                            // Swap them
                            icons[column, row] = other
                            icons[column + 1, row] = icon
                            
                            // Is either icons now part of a chain?
                            if hasChainAt(column: column + 1, row: row) ||
                                hasChainAt(column: column, row: row) {
                                set.insert(Swap(iconA: icon, iconB: other))
                            }
                            
                            // Swap them back
                            icons[column, row] = icon
                            icons[column + 1, row] = other
                        }
                    }
                    
                    if row < numRows - 1 {
                        if let other = icons[column, row + 1] {
                            icons[column, row] = other
                            icons[column, row + 1] = icon
                            
                            // Is either icon now part of a chain?
                            if hasChainAt(column: column, row: row + 1) ||
                                hasChainAt(column: column, row: row) {
                                set.insert(Swap(iconA: icon, iconB: other))
                            }
                            
                            // Swap them back
                            icons[column, row] = icon
                            icons[column, row + 1] = other
                        }
                    }
                }
            }
        }
        
        possibleSwaps = set
    }
    
    func shuffle() -> Set<Icons> {
        var set: Set<Icons>
        repeat {
            set = createInitialIcons()
            detectPossibleSwaps()
            print("possible swaps: \(possibleSwaps)")
        } while possibleSwaps.count == 0
        return set
    }
    
    func isPossibleSwap(_ swap: Swap) -> Bool {
        return possibleSwaps.contains(swap)
    }
    
    func performSwap(swap: Swap) {
        let columnA = swap.iconA.column
        let rowA = swap.iconA.row
        let columnB = swap.iconB.column
        let rowB = swap.iconB.row
        
        icons[columnA,rowA] = swap.iconB
        swap.iconB.column = columnA
        swap.iconB.row = rowA
        
        icons[columnB,rowB] = swap.iconA
        swap.iconA.column = columnA
        swap.iconB.row = rowB
        
    }
    
    init(filename: String) {
        guard let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle(filename: filename) else { return }
        guard let tilesArray = dictionary["tiles"] as? [[Int]] else { return }
        
        for (row, rowArray) in tilesArray.enumerated() {
            let tileRow = numRows - row - 1
            for (column, value) in rowArray.enumerated() {
                if value == 1 {
                    tiles[column,tileRow] = Tile()
                }
            }
        }
    }
    
    private func createInitialIcons() -> Set<Icons> {
        var set = Set<Icons>()
        
        for row in 0..<numRows {
            for column in 0..<numColums {
                if tiles[column, row] != nil {
                    var iconType: IconType
                    repeat {
                        iconType = IconType.random()
                    } while (column >= 2 &&
                        icons[column - 1, row]?.iconType == iconType &&
                        icons[column - 2, row]?.iconType == iconType)
                        || (row >= 2 &&
                            icons[column, row - 1]?.iconType == iconType &&
                            icons[column, row - 2]?.iconType == iconType)
                    let icon = Icons(column: column, row: row, iconType: iconType)
                    icons[column,row] = icon
                    
                    set.insert(icon)
                }
            }
        }
        return set
    }
}
