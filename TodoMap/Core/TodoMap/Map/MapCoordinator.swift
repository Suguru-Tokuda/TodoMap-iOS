//
//  MapCoordinator.swift
//  TodoMap
//
//  Created by Suguru Tokuda on 2/16/24.
//

import SwiftUI

enum MapPage: String, CaseIterable, Identifiable {
    case map
    var id: String { self.rawValue }
}

enum MapSheet: String, Identifiable {
    case placeSelection
    var id: String { self.rawValue }
}

class MapCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    @Published var sheet: MapSheet?
    var location: ReverseGeocodeModel?
    var onLocationSelect: ((LocationModel) -> ())?
    
    func showPlaceSelectionSheet(location: ReverseGeocodeModel) {
        self.sheet = .placeSelection
        self.location = location
    }
    
    func dismissSheet() {
        self.sheet = nil
    }
    
    @ViewBuilder
    func build(page: MapPage) -> some View {
        switch page {
        case .map:
            PlacesSearchView { location in
                self.onLocationSelect?(location)
                self.dismissSheet()
            }
        }
    }

    @ViewBuilder
    func build(sheet: MapSheet) -> some View {
        switch sheet {
        case .placeSelection:
            PlaceSelectionView(location: location) { location in
                self.onLocationSelect?(location)
                self.dismissSheet()
            }
        }
    }
}
