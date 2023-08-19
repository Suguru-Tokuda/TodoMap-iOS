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
    
    var todoItemGroup: TodoItemGroupModel?
    var todoItemGroups: [TodoItemGroupModel] = []
    
    init() {
        todoItemGroup = TodoItemGroupModel(
            id: 1, name: "Walmart Shopping List",
            items: todoItems,
            location: location,
            created: Date(),
            status: .active)
                
        for i in 0...20 {
            var item: TodoItemGroupModel = todoItemGroup!
            item.id = (i + 1)
            self.todoItemGroups.append(item)
        }
    }
}
