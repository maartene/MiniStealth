//
//  MSEntity.swift
//  MiniStealth
//
//  Created by Maarten Engels on 09/03/2022.
//

import Foundation
import GameplayKit

class MSEntity: GKEntity {
    
    var position: Vector
    let name: String
    
    init(name: String, startPosition: Vector = .zero) {
        self.name = name
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
}
