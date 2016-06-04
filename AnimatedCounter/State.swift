//
//  State.swift
//  AnimatedCounter
//
//  Created by Alexey on 3/06/2016.
//  Copyright © 2016 Alexey Zhilnikov. All rights reserved.
//

enum CounterState {
    // Possible states
    case Stopped, Running, Resetting
    
    // Change state Start <-> Stop
    mutating func toggle() {
        switch self {
        case .Stopped:
            self = Running
            
        case .Running:
            self = Stopped
            
        case .Resetting:
            break
        }
    }
}
