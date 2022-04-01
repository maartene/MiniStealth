//
//  Heading.swift
//  MiniStealth
//
//  Created by Maarten Engels on 26/03/2022.
//

import Foundation

enum Heading: Int, CaseIterable {
    case North, NorthEast, East, SouthEast, South, SouthWest, West, NorthWest
    
    var toVector: Vector {
        switch self {
        case .North:
            return Vector(x: 0, y: 1)
        case .NorthEast:
            return Vector(x: 1, y: 1)
        case .East:
            return Vector(x: 1, y: 0 )
        case .SouthEast:
            return Vector(x: 1, y: -1 )
        case .South:
            return Vector(x: 0, y: -1)
        case .SouthWest:
            return Vector(x: -1, y: -1)
        case .West:
            return Vector(x: -1, y: 0)
        case .NorthWest:
            return Vector(x: -1, y: 1)
        }
    }
    
    static func vectorToHeading(_ vector: Vector) -> Heading? {
        allCases.first { $0.toVector == vector }
    }
}
