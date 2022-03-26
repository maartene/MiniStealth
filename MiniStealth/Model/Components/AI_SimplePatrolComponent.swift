//
//  AI_SimplePatrolComponent.swift
//  MiniStealth
//
//  Created by Maarten Engels on 26/03/2022.
//

import Foundation
import GameplayKit

final class AI_SimplePatrolComponent: GKComponent, WorldUpdateable {
    
    enum PatrolState {
        case patrolling
        case persuing
    }
    
    var state = PatrolState.patrolling
    
    let target: MSEntity
    
    init(target: MSEntity) {
        self.target = target
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(in world: World) {
        switch state {
        case .patrolling:
            patrol(in: world)
        case .persuing:
            persui(in: world)
        }
    }
    
    func patrol(in world: World) {
        // Can we spot the target?
        if let vc = msEntity.component(ofType: VisibilityComponent.self) {
            if vc.tileVisibility[target.position]?.isVisible ?? false {
                state = .persuing
                return
            }
        }
        
        // Patrol
        if msEntity.tryMove(direction: msEntity.heading.toVector, in: world.map) == false {
            // if we can't move in our current heading, we'll rotate 90 degrees.
            let newHeadingRawValue = (msEntity.heading.rawValue + 2) % Heading.allCases.count
            
            msEntity.heading = Heading(rawValue: newHeadingRawValue) ?? msEntity.heading
        }
    }
    
    func persui(in world: World) {
        var dX = 0
        var dY = 0

        if target.position.x > msEntity.position.x {
            dX = 1
        }

        if target.position.x < msEntity.position.x {
            dX = -1
        }

        if target.position.y > msEntity.position.y {
            dY = 1
        }

        if target.position.y < msEntity.position.y {
            dY = -1
        }
        
        let direction = Vector(x: dX, y: dY)
        
        if let newHeading = Heading.vectorToHeading(direction) {
            msEntity.heading = newHeading
        }
        
        _ = msEntity.tryMove(direction: msEntity.heading.toVector, in: world.map)
    }
    
}
