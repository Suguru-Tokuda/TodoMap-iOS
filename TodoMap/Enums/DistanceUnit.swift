//
//  DistanceUnit.swift
//  TodoMap
//
//  Created by Suguru on 9/3/23.
//

import Foundation

enum DistanceUnit {
    case mile
    case meter
    
    func distance(meters: Double) -> String {
        switch self {
        case .meter:
            return "\(meters.asNumberString()) km"
        case .mile:
            return "\(convertMetersToMiles(meters).asNumberString()) mi"
        }
    }
    
    func convertMetersToMiles(_ meters: Double) -> Double {
        return meters / (1000.0 * 1.6)
    }
}
