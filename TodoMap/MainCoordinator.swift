//
//  Coordinator.swift
//  TodoMap
//
//  Created by Suguru Tokuda on 2/11/24.
//

import Foundation
import SwiftUI

@MainActor
class MainCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    
    func startCoordinateor() {
        path.append(Page.tabs)
    }
    
    @ViewBuilder
    func getPage(page: Page) -> some View {
        switch page {
        case .tabs:
            TabsView()
        }
    }
}

enum Page: String, CaseIterable, Identifiable {
    case tabs
    var id: String { self.rawValue }
}
