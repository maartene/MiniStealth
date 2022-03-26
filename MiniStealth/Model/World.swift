//
//  World.swift
//  MiniStealth
//
//  Created by Maarten Engels on 09/03/2022.
//

import Foundation

final class World {
    let map: Map
    
    var entities = [MSEntity]()
    let player: MSEntity
    
    init(mapString: String) {
        map = Map(mapString: mapString)
        
        player = MSEntity(name: "Player", startPosition: map.playerStartPosition)
        player.addComponent(VisibilityComponent(visionRange: 10))
        entities.append(player)
        
        let target = MSEntity(name: "Treasure", startPosition: map.targetPosition)
        entities.append(target)
        
        for esp in map.enemySpawnPositions {
            let enemy = MSEntity(name: "Enemy", startPosition: esp)
            enemy.addComponent(VisibilityComponent(visionRange: 7))
            enemy.addComponent(AI_SimplePatrolComponent(target: player))
            entities.append(enemy)
        }
        
    }
    
    func update() {
        for entity in entities {
            entity.update(in: self)
        }
    }
}
