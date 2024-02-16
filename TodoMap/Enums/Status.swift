//
//  Status.swift
//  TodoMap
//
//  Created by Suguru on 8/8/23.
//

import Foundation

enum Status: Int64 {
    case active = 1
    case completed = 2
    case inactive = 3
    
    static func getStatus(statusNum: Int64) -> Status {
        switch statusNum {
        case 1:
            return .active
        case 2:
            return .completed
        case 3:
            return .inactive
        default:
            return .inactive
        }
    }
}
