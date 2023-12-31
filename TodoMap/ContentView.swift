//
//  ContentView.swift
//  MapTodo
//
//  Created by Suguru on 8/5/23.
//

import SwiftUI

struct ContentView: View {
    var todoItemGroup: TodoItemListModel
    
    init() {
//        let todoItems = [
//            TodoItemModel(id: UUID(), name: "Wiper Fluid", note: "Get the cheapest wiper fluid", completed: false, created: Date()),
//            TodoItemModel(id: UUID(), name: "Kefer", note: "Plain Kefier", completed: true, created: Date()),
//            TodoItemModel(id: UUID(), name: "Wiper Fluid", note: "Get the cheapest wiper fluid", completed: false, created: Date()),
//            TodoItemModel(id: UUID(), name: "Wiper Fluid", note: "Get the cheapest wiper fluid", completed: true, created: Date())]
        let location = ""
        todoItemGroup = TodoItemListModel(
            id: UUID(),
            name: "",
            items: [],
            location: location,
            created: Date(),
            status: .active
        )
    }
    
    var body: some View {
//        TabsView()
        TodoItemListEditView(todoItemGroup: todoItemGroup)
//        TodoMapView()
//        PlacesSearchView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
