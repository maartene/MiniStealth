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
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    init(x: Int32, y: Int32) {
        self.x = Int(x)
        self.y = Int(y)
    }
    
    // MARK: computed properties to quickly get common values
    static var zero: Vector {
        Vector(x: 0, y: 0)
    }
    
    static var left: Vector {
        Vector(x: -1, y: 0)
    }
    
    static var right: Vector {
        Vector(x: 1, y: 0)
    }
    
    static var up: Vector {
        Vector(x: 0, y: 1)
    }
    
    static var down: Vector {
        Vector(x: 0, y: -1)
    }
    
    // MARK: vector arithmatic
    static func +(lhs: Vector, rhs: Vector) -> Vector {
        Vector(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func -(lhs: Vector, rhs: Vector) -> Vector {
        Vector(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    static func distance(_ v1: Vector, _ v2: Vector) -> Double {
        let vector = v1 - v2
        return sqrt(Double(vector.x * vector.x + vector.y * vector.y))
    }
    
    
}

extension Vector: Hashable {}
