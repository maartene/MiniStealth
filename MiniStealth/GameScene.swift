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
        
        console.putString("WELCOME TO MINI-STEALTH!", at: Vector(x: 0, y: ROW_COUNT - 1), fgColor: .white, bgColor: .blue, alignment: .center)
        console.putString("========================", at: Vector(x: 0, y: ROW_COUNT - 2), alignment: .center)
        console.putString("Arrow keys to move.", at: Vector(x: 0, y: ROW_COUNT - 3), alignment: .center)
        console.putString("Capture the treasure. And don't get caught!", at: Vector(x: 0, y: ROW_COUNT - 4), alignment: .center)
    }
    
    func showWorld() {
        // center the map on the screen by calculating an offset to apply to all map coordinates
        let offset = Vector(x: COL_COUNT / 2 - world.map.size.x
                             / 2,
                            y: ROW_COUNT / 2 - world.map.size.y / 2)
        
        console.clear()
        
        world.update()
        
        if let vc = world.player.component(ofType: VisibilityComponent.self) {
            for tile in vc.tileVisibility {
                let mapCell = world.map.getCell(tile.key)
                
                switch tile.value {
                case .notVisited:
                    break
                case .visited:
                    console.putBackground(mapCell.name, at: tile.key + offset, color: .darkGray)
                case .visible(let lit):
                    console.putBackground(mapCell.name, at: tile.key + offset, color: SKColor(calibratedHue: 0.5, saturation: 1, brightness: lit, alpha: 1))
                }
            }
            
            // color tiles where visibility between player and other entities overlaps in a different colour.
            let otherVCs = world.entities
                .filter { $0 !== world.player } // we want all entities except the player
                .compactMap { $0.component(ofType: VisibilityComponent.self) } // we only want the visual components

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
                        console.putBackground(mapCell.name, at: tile.key + offset, color: SKColor(calibratedHue: 0.1, saturation: 1, brightness: lit, alpha: 1))
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
                    console.putForeground(entity.name, at: entity.position + offset, color: SKColor(calibratedHue: 0.2, saturation: 1, brightness: lit, alpha: 1))
                }
            }
        }
        
        // Process events
        for event in Event.eventList {
            switch event {
            case .alert(let coord):
                console.putChar("!", at: coord + offset, fgColor: .white, bgColor: .red)
                playSound(named: "Metal Gear Alert Sound Effect.aiff")
            default:
                console.putString("Received event: \(event).", at: Vector(x: 1, y: 1))
            }
        }
        
        Event.eventList.removeAll()
        
        // Show player position on screen.
        console.putString("Player position: \(world.player.position.x),\(world.player.position.y)", at: Vector.zero)
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
        // 'r'
        case 15:
            restart()
            
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
        
        if world.state == .playing {
            if world.player.tryMove(direction: direction, in: world.map) {
                showWorld()
                
                if world.state == .won {
                    console.putString("You Won! Press 'r' to play again.", at: Vector(x: 0, y: ROW_COUNT / 2), fgColor: .white, bgColor: .green, alignment: .center)
                } else if world.state == .lost {
                    console.putString("You Lost :(. Press 'r' to try again.", at: Vector(x: 0, y: ROW_COUNT / 2), fgColor: .white, bgColor: .red, alignment: .center)
                }
            } else {
                console.putString("BOINK!", at: Vector.zero, fgColor: .white, bgColor: .red)
            }
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func restart() {
        //print("Current level index \(currentLevelIndex)")
        world = World(mapString: Map.mapStrings[0])
        
        showWorld()
    }
    
    func playSound(named filename: String) {
        let action = SKAction.playSoundFileNamed(filename, waitForCompletion: false)
        run(action)
    }
}
