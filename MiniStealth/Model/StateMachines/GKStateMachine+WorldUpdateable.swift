//
//  GKStateMachine+WorldUpdateable.swift
//  MiniStealth
//
//  Created by Maarten Engels on 27/03/2022.
//

import Foundation
import GameplayKit

extension GKStateMachine: WorldUpdateable {
    func update(in world: World) {
        guard let currentWorldUpdateableState = currentState as? WorldUpdateable else {
            fatalError("Please only use GKState subclasses that conform to WorldUpdateable")
        }
        
        currentWorldUpdateableState.update(in: world)
    }
}
