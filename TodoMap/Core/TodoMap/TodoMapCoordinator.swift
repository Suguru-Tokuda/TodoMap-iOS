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

enum TodoMapFullCoverSheet: String, CaseIterable, Identifiable {
    case todoListEditor
    var id: String { self.rawValue }
}

class TodoMapCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    @Published var fullCoverSheet: TodoMapFullCoverSheet?
    
    var onLocationSelect: ((LocationModel) -> Void)?
    var location: LocationModel?
    
    func push(_ page: TodoMapPage) {
        path.append(page)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func dismissFullCover() {
        self.fullCoverSheet = nil
    }
       
    @ViewBuilder
    func build(page: TodoMapPage) -> some View {
        switch page {
        case .placesSearch:
            placesSearchView()
        }
    }
    
    @ViewBuilder
    func build(fullCoverSheet: TodoMapFullCoverSheet) -> some View {
        switch fullCoverSheet {
        case .todoListEditor:
            TodoItemListEditView(todoItemGroup: .init(name: "", 
                                                      items: [],
                                                      location: self.location,
                                                      created: Date(),
                                                      status: .active),
                                 coordinatorType: .todoMap,
                                 saveOnChange: false)
        }
    }
    
    @ViewBuilder
    func placesSearchView() -> some View {
        PlacesSearchView(
            onLocationSelect: { location in
                self.location = location
                self.fullCoverSheet = .todoListEditor
            },
            handleBackBtnTapped: {
                self.dismissFullCover()
            })
    }
}
