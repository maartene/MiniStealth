//
//  MSEntity.swift
//  MiniStealth
//
//  Created by Maarten Engels on 09/03/2022.
//

import Foundation
import GameplayKit

class MSEntity: GKEntity {
    
    var position = Vector.zero
    let name: String
    
    init(name: String, startPosition: Vector = .zero) {
        self.name = name
        self.position = startPosition
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
