//
//  Double.swift
//  TodoMap
//
//  Created by Suguru on 9/3/23.
//

import Foundation

extension Double {
    private var distanceFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        return formatter
    }
    
    func asNumberString() -> String {
        let number = NSNumber(value: self)
        return distanceFormatter.string(from: number) ?? "0.00"
    }
}
