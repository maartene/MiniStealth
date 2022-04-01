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
        
        world.update()
        
        if let vc = world.player.component(ofType: VisibilityComponent.self) {
            for tile in vc.tileVisibility {
                let mapCell = world.map.getCell(tile.key)
                
                switch tile.value {
                case .notVisited:
                    break
                case .visited:
                    console.putBackground(mapCell.name, at: tile.key, color: .darkGray)
                case .visible(let lit):
                    console.putBackground(mapCell.name, at: tile.key, color: SKColor(calibratedHue: 0.5, saturation: 1, brightness: lit, alpha: 1))
                }
            }
            
            // color tiles where visibility between player and other entities overlaps in a different colour.
            let otherVCs = world.entities.filter { $0 !== world.player }.compactMap { $0.component(ofType: VisibilityComponent.self) }

            for otherVC in otherVCs {
                let overlappingTiles = overlappingTiles(vc.tileVisibility, otherVC.tileVisibility)

                for tile in overlappingTiles {
                    let mapCell = world.map.getCell(tile.key)
                    
                    switch tile.value {
                    case .notVisited:
                        break
                    case .visited:
                        break
                    case .visible(let lit):
                        console.putBackground(mapCell.name, at: tile.key, color: SKColor(calibratedHue: 0.1, saturation: 1, brightness: lit, alpha: 1))
                    }
                }
            }
            
            // Next: look at Entities
            for entity in world.entities {
                let visibility = vc.tileVisibility[entity.position, default: .notVisited]
                switch visibility {
                case .notVisited:
                    break
                case .visited:
                    break
                case .visible(let lit):
                    console.putForeground(entity.name, at: entity.position, color: SKColor(calibratedHue: 0.2, saturation: 1, brightness: lit, alpha: 1))
                }
            }
        }
    }
    
    func overlappingTiles(_ tiles1: [Vector: Visibility], _ tiles2: [Vector: Visibility]) -> [Vector: Visibility] {
        let visibleTiles1 = tiles1.filter { $0.value.isVisible }
        let visibleTiles2 = tiles2.filter { $0.value.isVisible }
        
        let coordSet1 = Set<Vector>(visibleTiles1.keys)
        let coordSet2 = Set<Vector>(visibleTiles2.keys)
        
        let intersection = coordSet1.intersection(coordSet2)
        
        var result = [Vector: Visibility]()
        for coord in intersection {
            result[coord] = tiles1[coord]
        }
        return result
    }
    
    override func keyDown(with event: NSEvent) {
        var direction = Vector.zero
        
        switch event.keyCode {
        // left arrow
        case 123:
            direction = Vector.left
        // right arrow
        case 124:
            direction = Vector.right
        // down arrow
        case 125:
            direction = Vector.down
        // up arrow
        case 126:
            direction = Vector.up
            
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
        
        if world.player.tryMove(direction: direction, in: world.map) {
            showWorld()
        } else {
            console.putString("BOINK!", at: Vector.zero, fgColor: .white, bgColor: .red)
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
