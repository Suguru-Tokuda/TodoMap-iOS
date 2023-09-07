//
//  PreviewProvider.swift
//  TodoMap
//
//  Created by Suguru on 8/8/23.
//

import Foundation
import SwiftUI
import MapKit

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.shared
    }
}

class DeveloperPreview {
    static let shared = DeveloperPreview()
    var todoItems: [TodoItemModel] = [
        TodoItemModel(id: UUID(), name: "Wiper Fluid", note: "Get the cheapest wiper fluid", completed: false, created: Date()),
        TodoItemModel(id: UUID(), name: "Kefer", note: "Plain Kefier", completed: true, created: Date()),
        TodoItemModel(id: UUID(), name: "Wiper Fluid", note: "Get the cheapest wiper fluid", completed: false, created: Date()),
        TodoItemModel(id: UUID(), name: "Wiper Fluid", note: "Get the cheapest wiper fluid", completed: true, created: Date())]
    
//    var location: LocationModel = LocationModel(name: "Walmart", coordinates: CLLocationCoordinate2D(latitude: 42.01542, longitude: -87.76869))
    var location: String = ""
    
    var todoItemGroup: TodoItemListModel?
    var todoItemGroups: [TodoItemListModel] = []
    
    var placePredictions: [Prediction] = [
        Prediction(
            description: "Apple Union Square, Post Street, San Francisco, CA, USA",
            matchedSubstrings: [MatchedSubstring(length: 5, offset: 0)],
            placeId: "ChIJZZ3SqIiAhYARdxDXMalu6mY",
            reference: "ChIJZZ3SqIiAhYARdxDXMalu6mY",
            structuredFormatting: StructuredFormatting(mainText: "Apple Union Square", mainTextMatchedSubstrings: [MatchedSubstring(length: 5, offset: 0)], secondaryText: "Post Street, San Francisco, CA, USA"),
            terms: [Term(offset: 0, value: "Apple Union Square")],
            types: [
                "electronics_store",
                "store",
                "point_of_interest",
                "establishment"
            ]
       )
    ]
    
    var nearbySearchResults: [NearbySearchResult] = [
        NearbySearchResult(
            businessStatus: "OPERATIONAL",
            geometry: Geometry(
                location: Location(lat: -33.5857323, lng: 151.2100055),
                viewport: Viewport(
                    northeast: Location(lat: -33.85739847010727, lng: 151.2112436298927),
                    southwest: Location(lat: -33.86009812989271, lng: 151.2085439701072)
                    )
                ),
            icon: "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/bar-71.png",
            iconBackgroundColor: "#FF9E67",
            iconMaskBaseURI: "https://maps.gstatic.com/mapfiles/place_api/icons/v2/bar_pinlet",
            name: "Cruise Bar",
            openingHours: OpeningHours(openNow: true),
            photos: [
                Photo(
                    height: 575,
                    photoReference: "AUacShgUBpbYJQacDejTsqJYESJPIEulVqNpnLGetp0ykU8_tjDYU7gEhjayyRzNXdv9aDz_NcFDeKmusx2nkLXcDiMsZFPJyZLUjMNHYOoCKSAOcqwxkY3GEq7dltfUG4fuT68L4Vloe3UsrozsTeEdWRBSu61MhwDZNpDdpdDRGNL8W7I2",
                    width: 766)
            ],
            placeId: "ChIJi6C1MxquEmsR9-c-3O48ykI",
            priceLevel: 4,
            rating: 2,
            reference: "ChIJi6C1MxquEmsR9-c-3O48ykI",
            types: [
                "bar",
                "restaurant",
                "food",
                "point_of_interest",
                "establishment"
            ],
            userRatingsTotal: 1538,
            vicinity: "Level 1, 2 and 3, Overseas Passenger Terminal, Circular Quay W, The Rocks"
        )
    ]
    
    init() {
        todoItemGroup = TodoItemListModel(
            id: UUID(), name: "Walmart Shopping List",
            items: todoItems,
            location: location,
            created: Date(),
            status: .active)
                
        for _ in 0...20 {
            var item: TodoItemListModel = todoItemGroup!
            item.id = UUID()
            self.todoItemGroups.append(item)
        }
    }
}
