//
//  VisibilityComponent.swift
//  MiniStealth
//
//  Created by Maarten Engels on 14/03/2022.
//

import Foundation
import GameplayKit

final class VisibilityComponent: GKComponent, WorldUpdateable {
    let visionRange: Int
    
    var tileVisibility = [Vector: Visibility]()
    
    init(visionRange: Int) {
        self.visionRange = visionRange
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(in world: World) {
        updateVisibility(map: world.map)
    }
    
    func clearVisibility() {
        for tile in tileVisibility {
            tileVisibility[tile.key] = .visited
        }
    }
    
    func updateVisibility(map: Map) {
        clearVisibility()
        
        for i in 0 ... 7 {
            refreshOctant(map: map, octant: i)
        }
    }
    
    // MARK: Shadowcasting
    /// Based on the explanation and Dart code:  https://journal.stuffwithstuff.com/2015/09/07/what-the-hero-sees/
    /// Translated to Swift
    private func transformOctant(row: Int, col: Int, octant: Int) -> Vector {
        switch octant {
        case 0:
            return Vector( x: col, y: -row)
        case 1:
            return Vector( x: row, y: -col)
        case 2:
            return Vector( x: row,  y: col)
        case 3:
            return Vector( x: col,  y: row)
        case 4:
            return Vector(x: -col,  y: row)
        case 5:
            return Vector(x: -row,  y: col)
        case 6:
            return Vector(x: -row, y: -col)
        case 7:
            return Vector(x: -col, y: -row)
        default:
            return Vector(x: col, y: row)
        }
    }
    
    private func refreshOctant(map: Map, octant: Int) {
        let line =  ShadowLine()
        var fullShadow = false
        let hero = msEntity.position
        
        for row in 0 ..< visionRange {
            // Stop once we go out of bounds.
            //let pos = hero + transformOctant(row: row, col: 0, octant: octant);
            
            for col in 0 ... row {
                let pos = hero + transformOctant(row: row, col: col, octant: octant)
                let distance = Vector.distance(pos, hero)
                if distance <= Double(visionRange) {
                    if fullShadow {
                        // world.map[pos.x, pos.y, levelIndex].visible = false
                    } else {
                        let projection = Shadow.projectTile(row: row, col: col)
                        
                        // Set the visibility of this tile.
                        let visible = line.isInShadow(projection) == false
                        //world.map[pos.x, pos.y, levelIndex].visible = visible;
                        if visible {
                            let light = 1.0 / (distance)
                            tileVisibility[pos] = .visible(lit: light)
                        }
                        
                        // Add any opaque tiles to the shadow map.
                        if visible && map.getCell(pos).blocksLight == true {
                            line.add(projection);
                            fullShadow = line.isFullShadow
                        }
                    }
                }
            }
        }
    }

    private final class ShadowLine {
        var shadows = [Shadow]()
        
        var isFullShadow: Bool {
            return shadows.count == 1 && shadows[0].start == 0 && shadows[0].end == 1
        }
        
        func isInShadow(_ projection: Shadow) -> Bool {
            for shadow in shadows {
                if shadow.contains(other: projection) {
                    return true
                }
            }
            return false
        }
        
        func add(_ shadow: Shadow) {
            // Figure out where to slot the new shadow in the list.
            var index = 0
            while index < shadows.count {
                // Stop when we hit the insertion point.
                if (shadows[index].start >= shadow.start) {
                    break
                }
                index += 1
            }
            
            // The new shadow is going here. See if it overlaps the
            // previous or next.
            var overlappingPrevious: Shadow?
            if index > 0 && shadows[index - 1].end > shadow.start {
                overlappingPrevious = shadows[index - 1];
            }
            
            var overlappingNext: Shadow?
            if index < shadows.count && shadows[index].start < shadow.end {
                overlappingNext = shadows[index];
            }
            
            // Insert and unify with overlapping shadows.
            if overlappingNext != nil {
                if overlappingPrevious != nil {
                    // Overlaps both, so unify one and delete the other.
                    overlappingPrevious!.end = overlappingNext!.end
                    shadows.remove(at: index)
                    } else {
                        // Overlaps the next one, so unify it with that.
                        overlappingNext!.start = shadow.start
                    }
                } else {
                    if overlappingPrevious != nil {
                        // Overlaps the previous one, so unify it with that.
                        overlappingPrevious!.end = shadow.end
                    } else {
                        // Does not overlap anything, so insert.
                        shadows.insert(shadow, at: index)
                }
            }
        }
    }

    private final class Shadow {
        var start: Double
        var end: Double
        
        init(start: Double, end: Double) {
            self.start = start
            self.end = end
        }
        
        /// Creates a [Shadow] that corresponds to the projected
        /// silhouette of the tile at [row], [col].
        static func projectTile(row: Int, col: Int) -> Shadow {
            let c = Double(col)
            let r = Double(row)
            let topLeft = c / (r + 2)
            let bottomRight = (c + 1) / (r + 1)
            return Shadow(start: topLeft, end: bottomRight)
        }
        
        /// Returns `true` if [other] is completely covered by this shadow.
        func contains(other: Shadow) -> Bool {
            return start <= other.start && end >= other.end
        }
        
    }
}


enum Visibility {
    case notVisited                 // a tile that was never visited
    case visited                    // a tile that was once visible, but no longer
    case visible(lit: Double)       // a tile we can currently see
}
