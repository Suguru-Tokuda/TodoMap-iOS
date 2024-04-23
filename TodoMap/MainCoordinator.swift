//
//  Coordinator.swift
//  TodoMap
//
//  Created by Suguru Tokuda on 2/11/24.
//

import SwiftUI
import Combine

enum MainPage: String, CaseIterable, Identifiable {
    case tabs
    var id: String { self.rawValue }
}

enum CoordinatorType: String {
    case main,
         tabs,
         todoMap,
         todoList
}

class MainCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    @Published var tabSelection: TabBarItem = .todo

    @ViewBuilder
    func build(page: MainPage) -> some View {
        switch page {
        case .tabs:
            TabsView()
        }
    }
    
    func selectLocation(_: LocationModel) {
    }
}
