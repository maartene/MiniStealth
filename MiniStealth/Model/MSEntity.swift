//
//  MSEntity.swift
//  MiniStealth
//
//  Created by Maarten Engels on 09/03/2022.
//

import Foundation
import GameplayKit

class MSEntity: GKEntity, WorldUpdateable {
    
    var position: Vector
    let name: String
    let team: Team
    var heading: Heading = .North
    
    init(name: String, team: Team, startPosition: Vector = .zero) {
        self.name = name
        self.team = team
        self.position = startPosition
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tryMove(direction: Vector, in map: Map) -> Bool {
        let newPosition = position + direction
        
        if map.getCell(newPosition).enterable {
            position = newPosition
            return true
        } else {
            return false
        }
    }
        
    var worldUpdateableComponents: [WorldUpdateable] {
        components.compactMap { $0 as? WorldUpdateable }
    }
    
    func update(in world: World) {
        for component in worldUpdateableComponents {
            component.update(in: world)
        }
    }
}


extension GKComponent {
    var msEntity: MSEntity {
        guard let msEntity = entity as? MSEntity else {
            fatalError("You should only use MSEntities in this game.")
        }
        
        return msEntity
    }
}

enum Team {
    case Player, Enemy, Neutral
}
