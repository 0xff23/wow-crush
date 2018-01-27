//
//  Icons.swift
//  wowCrunch
//
//  Created by Kirill G on 1/26/18.
//  Copyright © 2018 Kirill. All rights reserved.
//

import SpriteKit

// MARK: - IconType
enum IconType: Int, CustomStringConvertible {
    case unknown = 0, bear, cat, mechastrider, ridingelekkelite, rocketmount, wolf
    
    var spriteName: String {
        let spriteNames = [
        "bear",
        "cat",
        "mechastrider",
        "ridingelekkelite",
        "rocketmount",
        "wolf"]
        return spriteNames[rawValue - 1]
    }
    
    var description: String {
        return spriteName
    }
    
    var highlightedIconName: String {
        return spriteName + ""
    }
    
    // Random iconType
    static func random() -> IconType {
        return IconType(rawValue: Int(arc4random_uniform(6))+1)!
    }
}


// MARK: - Compare two Icons
func ==(lhs: Icons, rhs: Icons) -> Bool {
    return lhs.column == rhs.column && lhs.row == rhs.row
}

class Icons: CustomStringConvertible, Hashable {
    
    var column: Int
    var row: Int
    let iconType: IconType
    var sprite: SKSpriteNode?
    
    init(column: Int, row: Int, iconType: IconType) {
        self.column = column
        self.row = row
        self.iconType = iconType
    }
    
    var description: String {
        return "type:\(iconType) square:(\(column),\(row)"
    }
    
    var hashValue: Int {
        return row * 10 + column
    }
    
}

