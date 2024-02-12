//
//  Binding.swift
//  TodoMap
//
//  Created by Suguru Tokuda on 2/9/24.
//

import Foundation
import SwiftUI

extension Binding {
    func optionalBinding<T>() -> Binding<T>? where T? == Value {
        if let wrappedValue = wrappedValue {
            return Binding<T>(
                get: { wrappedValue },
                set: { self.wrappedValue = $0 }
            )
        } else {
            return nil
        }
    }
}
