//
//  Event.swift
//  MiniStealth
//
//  Created by Maarten Engels on 07/04/2022.
//

import Foundation

enum Event {
    static var eventList = [Event]()
    
    case alert(coord: Vector)
}
