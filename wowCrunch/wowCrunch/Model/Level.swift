//
//  Level.swift
//  wowCrunch
//
//  Created by Kirill G on 1/26/18.
//  Copyright © 2018 Kirill. All rights reserved.
//

import Foundation

// MARK: - Dimensions constants
let NumColums = 9
let NumRows = 9

class Level {
    fileprivate var icons = Array2D<Icons>(columns: NumColums, rows: NumRows)
    
    func iconAt(column: Int, row: Int) -> Icons? {
        assert(column >= 0 && column < NumColums)
        assert(row >= 0 && row < NumRows)
        return icons[column, row]
    }
    
    func shuffle() -> Set<Icons> {
        return createInitialIcons()
    }
    
    private func createInitialIcons() -> Set<Icons> {
        var set = Set<Icons>()
        
        for row in 0..<NumRows {
            for column in 0..<NumColums {
                let iconsType = IconType.random()
                let icon = Icons(column: column, row: row, iconType: iconsType)
                icons[column,row] = icon
                set.insert(icon)
            }
        }
        return set
    }
}


