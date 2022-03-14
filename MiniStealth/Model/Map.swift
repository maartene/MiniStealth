//
//  Map.swift
//  MiniStealth
//
//  Created by Maarten Engels on 09/03/2022.
//

import Foundation

// MARK: Map struct
struct Map {
    static let mapStrings = [
"""
  #################
  #...............#
  #.......T.......#
  #...............#
  #...............#
  #######...#######
        #...#
        #...#
#########...#########
#...E...............#
#...............E...#
#########...#########
        #...#
        #...#
  #######...#######
  #...............#
  #...............#
  #.......@.......#
  #...............#
  #################
"""
    ]
    
    var cells = [Vector: Cell]()
    
    var playerStartPosition = Vector.zero
    var targetPosition = Vector.zero
    var enemySpawnPositions = [Vector]()
    
    init(mapString: String) {
        let lines = mapString
            .split(separator: "\n")
            .reversed()
        
        var x = 0
        var y = 0
        for line in lines {
            for character in line {
                let coord = Vector(x: x, y: y)
                
                if character == "@" {
                    playerStartPosition = coord
                    // assume there's a floor under the players start position
                    cells[coord] = .floor
                } else if character == "T" {
                    targetPosition = coord
                    // assume there's a floor under the target's position
                    cells[coord] = .floor
                } else if character == "E" {
                    enemySpawnPositions.append(coord)
                    // assume there's a floor under the enemy's start position
                    cells[coord] = .floor
                } else {
                    cells[coord] = Cell(rawValue: character) ?? .void
                }
                x += 1
            }
            y += 1
            x = 0
        }
    }
    
    @inlinable func getCell(_ coord: Vector) -> Cell {
        cells[coord, default: .void]
    }
}

// MARK: Cell enum
enum Cell: Character {
    case void = " "
    case wall = "#"
    case floor = "."
    
    var name: String {
        switch self {
        case .void:
            return "Void"
        case .wall:
            return "Wall"
        case .floor:
            return "Floor"
        }
    }
    
    var enterable: Bool {
        switch self {
        case .floor:
            return true
        default:
            return false
        }
    }
}
