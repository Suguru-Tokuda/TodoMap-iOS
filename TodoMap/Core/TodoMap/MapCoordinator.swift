//
//  PlacesSearchCoordinator.swift
//  TodoMap
//
//  Created by Suguru Tokuda on 2/12/24.
//

import SwiftUI
import Combine

enum MapPage: String, CaseIterable, Identifiable {
    case placesSearch
    var id: String { self.rawValue }
}

class MapCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    
    func push(_ page: MapPage) {
        path.append(page)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    @ViewBuilder
    func build(page: MapPage) -> some View {
        switch page {
        case .placesSearch:
            PlacesSearchView()
        }
    }
}
