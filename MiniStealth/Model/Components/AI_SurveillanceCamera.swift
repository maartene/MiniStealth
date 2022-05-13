//
//  AI_AutoRotate.swift
//  MiniStealth
//
//  Created by Maarten Engels on 06/05/2022.
//

import Foundation
import GameplayKit


final class AI_SurveillanceCamera: GKComponent, WorldUpdateable {
 
    func update(in world: World) {
        let newHeadingRawValue = (msEntity.heading.rawValue + 1) % Heading.allCases.count
        let newHeading = Heading(rawValue: newHeadingRawValue) ?? msEntity.heading
        msEntity.heading = newHeading
        
        if let vc = msEntity.component(ofType: VisibilityComponent.self) {
            if vc.tileVisibility[world.player.position]?.isVisible ?? false {
                Event.eventList.append(.alert(coord: msEntity.position))
            }
        }
    }
}
