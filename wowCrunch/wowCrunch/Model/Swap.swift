//
//  Swap.swift
//  wowCrunch
//
//  Created by Kirill G on 1/27/18.
//  Copyright © 2018 Kirill. All rights reserved.
//

import Foundation

func ==(lhs: Swap, rhs: Swap) -> Bool {
    return (lhs.iconA == rhs.iconA && lhs.iconB == rhs.iconB) ||
        (lhs.iconA == rhs.iconA && lhs.iconB == rhs.iconB)
}

struct Swap: CustomStringConvertible, Hashable {
    let iconA: Icons
    let iconB: Icons
    
    init(iconA: Icons, iconB: Icons) {
        self.iconA = iconA
        self.iconB = iconB
    }
    
    var description: String {
        return "swap \(iconA) and \(iconB)"
    }
    
    var hashValue: Int {
        return iconA.hashValue ^ iconB.hashValue
    }
}
