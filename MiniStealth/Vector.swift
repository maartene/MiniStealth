//
//  Vector.swift
//  MiniStealth
//
//  Created by Maarten Engels on 03/02/2022.
//

import Foundation

struct Vector {
    var x: Int
    var y: Int
    
    static var zero: Vector {
        Vector(x: 0, y: 0)
    }
}

extension Vector: Hashable {}
