//
//  Coordinator.swift
//  TodoMap
//
//  Created by Suguru Tokuda on 2/11/24.
//

import SwiftUI

enum MainPage: String, CaseIterable, Identifiable {
    case tabs
    var id: String { self.rawValue }
}


class MainCoordinator: ObservableObject {
    @Published var path = NavigationPath()

    @ViewBuilder
    func build(page: MainPage) -> some View {
        switch page {
        case .tabs:
            TabsView()
        }
    }
}
