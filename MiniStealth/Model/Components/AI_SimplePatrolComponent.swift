//
//  AI_SimplePatrolComponent.swift
//  MiniStealth
//
//  Created by Maarten Engels on 26/03/2022.
//

import Foundation
import GameplayKit

final class AI_SimplePatrolComponent: GKComponent, WorldUpdateable {
    
    let stateMachine: GKStateMachine
    
    let target: MSEntity
    
    init(owner: MSEntity, target: MSEntity) {
        self.target = target
        
        stateMachine = GKStateMachine(states: [
            PatrollingState(owner: owner, target: target),
            PersuingState(owner: owner, target: target)
        ])
        
        stateMachine.enter(PatrollingState.self)
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(in world: World) {
        stateMachine.update(in: world)
    }
}
