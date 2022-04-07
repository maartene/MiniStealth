//
//  Map.swift
//  MiniStealth
//
//  Created by Maarten Engels on 09/03/2022.
//

import Foundation
import GameplayKit

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
    
    let size: Vector
    
    private var vectorNodeMap = [Vector: GKGridGraphNode]()
    private var graph = GKGridGraph<GKGridGraphNode>()
    
    
    
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
        
        var longestLineCount = 0
        for line in lines {
            longestLineCount = max(longestLineCount, line.count)
        }
        
        size = Vector(x: longestLineCount, y: lines.count)
        
        // pathfinding graph
        let result = createPathFindingGraph()
        graph = result.graph
        vectorNodeMap = result.map
    }
    
    @inlinable func getCell(_ coord: Vector) -> Cell {
        cells[coord, default: .void]
    }
    
    // MARK: Pathfinding using GameplayKit
    private func createPathFindingGraph() -> (map: [Vector: GKGridGraphNode], graph: GKGridGraph<GKGridGraphNode>) {
        var nodeMap = [Vector: GKGridGraphNode]()
        
        let graph = GKGridGraph(fromGridStartingAt: vector_int2(x: 0, y: 0), width: Int32(size.x), height: Int32(size.y), diagonalsAllowed: true, nodeClass: GKGridGraphNode.self)
        
        // we now have a graph where all nodes are connected to all 8 surrounding nodes in the grid.
        // I.e. every node is enterable, we'll fix this later.
        
        // We'll populate a map where we can - based on a coordinate (Vector) - map to the node in the graph.
        for node in graph.nodes! {
            let gridNode = node as! GKGridGraphNode
            let coord = Vector(x: gridNode.gridPosition.x, y: gridNode.gridPosition.y)
            nodeMap[coord] = gridNode
        }
        
        // We'll model the parts of the graph that are not enterable by removing those nodes that are not enterable.
        // This also removes their associated connections.
        let nodesToRemove = cells
            .filter { $0.value.enterable == false } // find all cells that are not enterable
            .compactMap { nodeMap[$0.key] } // then find the associated node for those cells
        
        graph.remove(nodesToRemove)
        
        // Note: nodeMap still contains references to all the nodes that are not enterable. This is not really a concern, but if you wish you can remove them as well.
        
        return (nodeMap, graph)
    }
    
    func path(from coord1: Vector, to coord2: Vector) -> [Vector] {
        guard let fromNode = vectorNodeMap[coord1], let toNode = vectorNodeMap[coord2] else {
            print("Failed to convert coordinates to nodes.")
            return []
        }
        
        let path = graph.findPath(from: fromNode, to: toNode)
        return path.map { node in
            let pos = (node as! GKGridGraphNode).gridPosition
            return Vector(x: pos.x, y: pos.y)
        }
        
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
    
    var blocksLight: Bool {
        switch self {
        case .wall:
            return true
        default:
            return false
        }
    }
}
