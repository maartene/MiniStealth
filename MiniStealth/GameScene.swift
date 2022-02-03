//
//  GameScene.swift
//  MiniStealth
//
//  Created by Maarten Engels on 03/02/2022.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let COL_COUNT = 80
    let ROW_COUNT = 44
    
    var console: SKonsole!
    
    override func didMove(to view: SKView) {
        
        console = SKonsole(colCount: COL_COUNT, rowCount: ROW_COUNT)
        
        addChild(console)
        
        console.clear()
        
        // draw a string
        console.putString("Hello, World!", at: Vector(x: 3, y: 5), fgColor: .green, bgColor: SKColor.red)
        
        // draw a player over a map tile
        console.putForeground("Player", at: Vector(x: 3, y: 8), color: SKColor.green)
        console.putBackground("square_16x16_25pct", at: Vector(x: 3, y: 8), color: SKColor.yellow)
    }
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
