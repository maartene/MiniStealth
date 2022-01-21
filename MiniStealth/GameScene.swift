//
//  GameScene.swift
//  MiniStealth
//
//  Created by Maarten Engels on 21/01/2022.
//

import SpriteKit

class GameScene: SKScene {
    let COL_COUNT = 80
    let ROW_COUNT = 44
    
    
    var console: SKonsole!
    
    override func didMove(to view: SKView) {
        
        console = SKonsole(colCount: COL_COUNT, rowCount: ROW_COUNT)
        
        addChild(console)
        
        console.putChar("1", at: Vector(x: 20,y: 20), fgColor: .green)
        console.putString("Hello, World!", at: Vector(x: 1, y: 5))
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
    }
}
