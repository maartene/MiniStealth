//
//  World.swift
//  MiniStealth
//
//  Created by Maarten Engels on 09/03/2022.
//

import Foundation
import GameplayKit

final class World {
    let map: Map
    
    var entities = [MSEntity]()
    let player: MSEntity
    
    var state = GameState.playing
    
    init(mapString: String) {
        map = Map(mapString: mapString)
        
        player = MSEntity(name: "Player", startPosition: map.playerStartPosition)
        player.addComponent(VisibilityComponent(visionRange: 10, headingRelevant: false))
        entities.append(player)
        
        let target = MSEntity(name: "Treasure", startPosition: map.targetPosition)
        entities.append(target)
        
        for esp in map.enemySpawnPositions {
            let enemy = MSEntity(name: "Enemy", startPosition: esp)
            enemy.addComponent(VisibilityComponent(visionRange: 7, headingRelevant: true))
            enemy.addComponent(AI_SimplePatrolComponent(owner: enemy, target: player))
            entities.append(enemy)
        }
        
    }
    
    func update() {
        for entity in entities {
            entity.update(in: self)
        }
        
        // let's see wether we won the game or not
        let ruleSystem = GKRuleSystem()
        ruleSystem.add([
            makeEnemyCaughtPlayerRule(),
            makePlayerReachedTreasureRule()
        ])
        
        ruleSystem.state["world"] = self
        
        ruleSystem.evaluate()
        
        let mappedFacts =   ruleSystem.facts.compactMap { $0 as? NSString }
        
        // Lose takes highest priority
        if mappedFacts.contains("playerCaught") {
            print("Lost")
            state = .lost
        } else if mappedFacts.contains("treasureReached") {
            print("Won")
            state = .won
        }
    }
    
    // MARK: Make rules
    func makeEnemyCaughtPlayerRule() -> GKRule {
        GKRule(
            blockPredicate: { ruleSystem in
                guard let world = ruleSystem.state["world"] as? World else {
                    fatalError("This rule requires that a World instance is part of the state.")
                }
                
                let enemies = world.entities.filter { $0.name == "Enemy" }
                for enemy in enemies {
                    if enemy.position == world.player.position {
                        return true
                    }
                }
                return false
            },
            action: { ruleSystem in
                ruleSystem.assertFact(NSString(stringLiteral: "playerCaught"))
            }
        )
    }
    
    func makePlayerReachedTreasureRule() -> GKRule {
        GKRule(
            blockPredicate: { ruleSystem in
                guard let world = ruleSystem.state["world"] as? World else {
                    fatalError("This rule requires that a World instance is part of the state.")
                }
                
                guard let treasure = world.entities.first(where: { $0.name == "Treasure"}) else {
                    fatalError("This rule requires that an entity named 'Treasure' can be found in the world.")
                }
                
                return treasure.position == world.player.position
            },
            action: { ruleSystem in
                ruleSystem.assertFact(NSString(stringLiteral: "treasureReached"))
            }
        )
    }
}

enum GameState {
    case playing
    case won
    case lost
}
