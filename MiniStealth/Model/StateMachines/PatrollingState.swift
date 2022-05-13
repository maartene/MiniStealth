//
//  PatrollingState.swift
//  MiniStealth
//
//  Created by Maarten Engels on 27/03/2022.
//

import Foundation
import GameplayKit

final class PatrollingState: GKState, WorldUpdateable, OwnedState {
    let owner: MSEntity
    let target: MSEntity
    
    init(owner: MSEntity, target: MSEntity) {
        self.owner = owner
        self.target = target
        
        super.init()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        stateClass is PersuingState.Type
    }
    
    func update(in world: World) {
        // Can we spot the target?
        if canWeSpotThePlayer(in: world) || canASurveilanceCameraSeeThePlayer(in: world) {
            _ = stateMachine?.enter(PersuingState.self)
            Event.eventList.append(.alert(coord: owner.position))
            return
        }
        
        // Patrol
        if owner.tryMove(direction: owner.heading.toVector, in: world.map) == false {
            // if we can't move in our current heading, we'll rotate 90 degrees.
            let newHeadingRawValue = (owner.heading.rawValue + 2) % Heading.allCases.count
            
            owner.heading = Heading(rawValue: newHeadingRawValue) ?? owner.heading
        }
    }
    
    private func canWeSpotThePlayer(in world: World) -> Bool {
        // Can we spot the target?
        if let vc = owner.component(ofType: VisibilityComponent.self) {
            if vc.tileVisibility[target.position]?.isVisible ?? false {
                return true
            }
        }
        
        return false
    }
    
    private func canASurveilanceCameraSeeThePlayer(in world: World) -> Bool {
        let surveillanceCameras = world.entities.filter { $0.name == "Surveillance Camera"}
        for camera in surveillanceCameras {
            if let vc = camera.component(ofType: VisibilityComponent.self) {
                if vc.tileVisibility[world.player.position]?.isVisible ?? false {
                    return true
                }
            }
        }
        return false
    }
}
