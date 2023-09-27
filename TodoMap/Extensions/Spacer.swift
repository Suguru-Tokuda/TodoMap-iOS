//
//  Spacer.swift
//  TodoMap
//
//  Created by Suguru on 9/20/23.
//

import Foundation
import SwiftUI

extension Spacer {
    public func onTapGesture(count: Int = 1, perform action: @escaping () -> Void) -> some View {
        ZStack {
            Color.black.opacity(0.001).onTapGesture(count: count, perform: action)
            self
        }
    }
}
