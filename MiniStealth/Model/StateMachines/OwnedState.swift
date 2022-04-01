//
//  OwnedState.swift
//  MiniStealth
//
//  Created by Maarten Engels on 27/03/2022.
//

import Foundation
import GameplayKit

protocol OwnedState: GKState {
    var owner: MSEntity { get }
}
