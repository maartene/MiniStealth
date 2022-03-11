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
    var world: World!
    
    override func didMove(to view: SKView) {
        
        console = SKonsole(colCount: COL_COUNT, rowCount: ROW_COUNT)
        addChild(console)
        
        world = World(mapString: Map.mapStrings[0])
        
        showWorld()
        
        // draw a string
        console.putString("Hello, World!", at: Vector(x: 3, y: 25), fgColor: .green, bgColor: SKColor.red)
        
    }
    
    func showWorld() {
        console.clear()
        
        // NOTE: Copy "square_16x16_25pct" to "Floor"
        
        for tile in world.map.cells {
            if tile.value != .void {
                console.putBackground(tile.value.name, at: tile.key, color: SKColor(calibratedHue: 0.5, saturation: 1, brightness: 1, alpha: 1))
            }
        }
        
        // Next: look at Entities
        for entity in world.entities {
            console.putForeground(entity.name, at: entity.position, color: SKColor(calibratedHue: 0.1, saturation: 1, brightness: 1.0, alpha: 1))
        }
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
