//
//  GameScene.swift
//  wowCrunch
//
//  Created by Kirill G on 1/26/18.
//  Copyright © 2018 Kirill. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    // MARK: - Scene properties
    var level: Level!
    
    let TileWidth: CGFloat = 32.0
    let TileHeight: CGFloat = 36.0
    
    let gameLayer = SKNode()
    let iconsLayer = SKNode()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) not used")
    }
    
    override init(size: CGSize) {
        super.init(size:size)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let background = SKSpriteNode(imageNamed:"Background")
        background.size = size
        addChild(background)
        addChild(gameLayer)
        
        let layerPosition = CGPoint(
            x: -TileWidth * CGFloat(NumColums) / 2,
            y: -TileHeight * CGFloat(NumRows) / 2)
        
        iconsLayer.position = layerPosition
        gameLayer.addChild(iconsLayer)
    }
    
    func addSprites(for icons: Set<Icons>) {
        for icon in icons {
            let sprite = SKSpriteNode(imageNamed: icon.iconType.spriteName)
            sprite.size = CGSize(width: TileWidth, height: TileHeight)
            sprite.position = pointFor(column: icon.column, row: icon.row)
            iconsLayer.addChild(sprite)
            icon.sprite = sprite
        }
    }
    
    func pointFor(column: Int, row: Int) -> CGPoint {
        return CGPoint(
            x: CFloat(column)*TileWidth + TileHeight/2,
            y: CGFloat(row)*TileHeight + TileHeight/2
        )
    }
}
