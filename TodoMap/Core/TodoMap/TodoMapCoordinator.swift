//
//  PlacesSearchCoordinator.swift
//  TodoMap
//
//  Created by Suguru Tokuda on 2/12/24.
//

import SwiftUI
import Combine

enum TodoMapPage: String, CaseIterable, Identifiable {
    case placesSearch
    var id: String { self.rawValue }
}

enum TodoMapSheet: String, CaseIterable, Identifiable {
    case placeSelection
    var id: String { self.rawValue }
}

class TodoMapCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    @Published var sheet: TodoMapSheet?
    
    func push(_ page: TodoMapPage) {
        path.append(page)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    @ViewBuilder
    func build(page: TodoMapPage) -> some View {
        switch page {
        case .placesSearch:
            PlacesSearchView()
        }
    }
    
    @ViewBuilder
    func build(sheet: TodoMapSheet) -> some View {
        switch sheet {
        case .placeSelection:
            PlaceSelectionView()
        }
    }
}
