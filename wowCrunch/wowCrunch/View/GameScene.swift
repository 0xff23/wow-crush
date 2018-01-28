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
    
    let tileWidth: CGFloat = 32.0
    let tileHeight: CGFloat = 36.0
    
    let gameLayer = SKNode()
    let iconsLayer = SKNode()
    let tilesLayer = SKNode()
    
    private var swipeFromColumn: Int?
    private var swipeFromRow: Int?
    
    var swipeHandler: ((Swap) -> ())?
    
    // MARK: Sound
    let swapSound = SKAction.playSoundFileNamed("Chomp.wav", waitForCompletion: false)
    let invalidSwapSound = SKAction.playSoundFileNamed("Error.wav", waitForCompletion: false)
    let matchSound = SKAction.playSoundFileNamed("Ka-Ching.wav", waitForCompletion: false)
    let fallingCookieSound = SKAction.playSoundFileNamed("Scrape.wav", waitForCompletion: false)
    let addCookieSound = SKAction.playSoundFileNamed("Drip.wav", waitForCompletion: false)
    
    // MARK: Init
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
            x: -tileWidth * CGFloat(numColums) / 2,
            y: -tileHeight * CGFloat(numRows) / 2)
        
        tilesLayer.position = layerPosition
        gameLayer.addChild(tilesLayer)
        
        iconsLayer.position = layerPosition
        gameLayer.addChild(iconsLayer)
        
        swipeFromRow = nil
        swipeFromColumn = nil
    }
    
    func addSprites(for icons: Set<Icons>) {
        for icon in icons {
            let sprite = SKSpriteNode(imageNamed: icon.iconType.spriteName)
            sprite.size = CGSize(width: tileWidth, height: tileHeight)
            sprite.position = pointFor(column: icon.column, row: icon.row)
            iconsLayer.addChild(sprite)
            icon.sprite = sprite
        }
    }
    
    func addTiles() {
        for row in 0..<numRows {
            for column in 0..<numColums {
                if level.tileAt(column: column, row: row) != nil {
                    let tileNode = SKSpriteNode(imageNamed: "Tile")
                    tileNode.size = CGSize(width: tileWidth, height: tileHeight)
                    tileNode.position = pointFor(column: column, row: row)
                    tilesLayer.addChild(tileNode)
                }
            }
        }
    }
    
    func pointFor(column: Int, row: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column)*tileWidth + tileWidth/2,
            y: CGFloat(row)*tileHeight + tileHeight/2
        )
    }
    
    func convertPoint(point: CGPoint) -> (success: Bool, column: Int, row: Int) {
        if point.x >= 0 && point.x < CGFloat(numColums)*tileWidth &&
            point.y >= 0 && point.y < CGFloat(numRows)*tileHeight {
            return (true, Int(point.x / tileWidth), Int(point.y / tileHeight))
        } else {
            return (false, 0,0)
        }
    }
    
    // MARK: - Icons Swapping
    func trySwap(horizontal:Int, vertical: Int) {
        let toColumn = swipeFromColumn! + horizontal
        let toRow = swipeFromRow! + vertical
        
        guard toColumn >= 0 && toColumn < numColums else { return }
        guard toRow >= 0 && toRow < numRows else { return }
        
        if let toIcon = level.iconAt(column: toColumn, row: toRow),
            let fromIcon = level.iconAt(column: swipeFromColumn!, row: swipeFromRow!) {
            if let handler = swipeHandler {
                let swap = Swap(iconA: fromIcon, iconB: toIcon)
                handler(swap)
            }
        }
    }
    // MARK: - Swap animation
    func animate(_ swap: Swap, completion: @escaping () ->()) {
        let spriteIconA = swap.iconA.sprite!
        let spriteIconB = swap.iconB.sprite!
        
        spriteIconA.zPosition = 100
        spriteIconB.zPosition = 90
        
        let duration: TimeInterval = 0.3
        
        let moveA = SKAction.move(to: spriteIconB.position, duration: duration)
        moveA.timingMode = .easeOut
        spriteIconA.run(moveA, completion: completion)
        
        let moveB = SKAction.move(to: spriteIconA.position, duration: duration)
        moveB.timingMode = .easeOut
        spriteIconB.run(moveB, completion: completion)
        
        run(swapSound)
        
    }
    
    func animateInvalidSwap(_ swap: Swap, completion: @escaping () -> ()) {
        let spriteIconA = swap.iconA.sprite!
        let spriteIconB = swap.iconB.sprite!
        
        spriteIconA.zPosition = 100
        spriteIconB.zPosition = 90
        
        let duration: TimeInterval = 0.2
        
        let moveA = SKAction.move(to: spriteIconB.position, duration: duration)
        moveA.timingMode = .easeOut
        
        let moveB = SKAction.move(to: spriteIconA.position, duration: duration)
        moveB.timingMode = .easeOut
        
        spriteIconA.run(SKAction.sequence([moveA, moveB]), completion: completion)
        spriteIconB.run(SKAction.sequence([moveB, moveA]))
        
        run(invalidSwapSound)
    }
    
    // MARK: Icons Swipe Handlers
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: iconsLayer)
        
        let (success, column, row) = convertPoint(point: location)
        if success {
            if let icon = level.iconAt(column: column, row: row) {
                swipeFromColumn = column
                swipeFromRow = row
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard swipeFromColumn != nil else { return }
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: iconsLayer)
        let (success, column, row) = convertPoint(point: location)
        if success {
            var hDelta = 0, vDelta = 0
            if column < swipeFromColumn! {
                hDelta = -1
            } else if column > swipeFromColumn! {
                hDelta = 1
            } else if row < swipeFromRow! {
                vDelta = -1
            } else if row > swipeFromRow! {
                vDelta = 1
            }
            
            if hDelta != 0 || vDelta != 0 {
                trySwap(horizontal:hDelta, vertical: vDelta)
                swipeFromColumn = nil
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        swipeFromRow = nil
        swipeFromColumn = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
}
