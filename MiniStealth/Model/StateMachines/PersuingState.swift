//
//  PersuingState.swift
//  MiniStealth
//
//  Created by Maarten Engels on 27/03/2022.
//

import Foundation
import GameplayKit

final class PersuingState: GKState, WorldUpdateable, OwnedState {
    let owner: MSEntity
    let target: MSEntity
    
    init(owner: MSEntity, target: MSEntity) {
        self.owner = owner
        self.target = target
        
        super.init()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        stateClass is PatrollingState.Type
    }
    
    func update(in world: World) {
//        var dX = 0
//        var dY = 0
//
//        if target.position.x > owner.position.x {
//            dX = 1
//        }
//
//        if target.position.x < owner.position.x {
//            dX = -1
//        }
//
//        if target.position.y > owner.position.y {
//            dY = 1
//        }
//
//        if target.position.y < owner.position.y {
//            dY = -1
//        }
        
        let path = world.map.path(from: owner.position, to: target.position)
        
        guard path.count > 0 else {
            print("No valid path found from \(owner.position) to \(target.position)")
            return
        }
        
        let direction: Vector
        if path.count == 1 { // either we are already at the right place or the path only contains the target position.
            direction = path[0] - owner.position
        } else {
            direction = path[1] - owner.position
        }
        
        if let newHeading = Heading.vectorToHeading(direction) {
            owner.heading = newHeading
        }
        
        _ = owner.tryMove(direction: owner.heading.toVector, in: world.map)
    }
}
