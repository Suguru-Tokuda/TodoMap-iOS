//
//  SwipeActionModifier.swift
//  TodoMap
//
//  Created by Suguru Tokuda on 2/15/24.
//

import SwiftUI

struct SwipeActionModifier: ViewModifier {
    let actions: [Action]
    
    func body(content: Content) -> some View {
        SwipeActionsView(actions: actions, content: {
            content
        })
    }
}

extension View {
    func swipeActions(actions: [Action]) -> some View {
        self
            .modifier(SwipeActionModifier(actions: actions))
    }
}
