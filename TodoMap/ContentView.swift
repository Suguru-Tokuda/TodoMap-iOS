//
//  ContentView.swift
//  MapTodo
//
//  Created by Suguru on 8/5/23.
//

import SwiftUI

struct ContentView: View {
    var todoItemGroup: TodoItemGroupModel
    
    init() {
        let todoItems = [
            TodoItemModel(id: UUID(), name: "Wiper Fluid", note: "Get the cheapest wiper fluid", completed: false, created: Date()),
            TodoItemModel(id: UUID(), name: "Kefer", note: "Plain Kefier", completed: true, created: Date()),
            TodoItemModel(id: UUID(), name: "Wiper Fluid", note: "Get the cheapest wiper fluid", completed: false, created: Date()),
            TodoItemModel(id: UUID(), name: "Wiper Fluid", note: "Get the cheapest wiper fluid", completed: true, created: Date())]
        let location = ""
        todoItemGroup = TodoItemGroupModel(
            id: 1, name: "Walmart Shopping List",
            items: todoItems,
            location: location,
            created: Date(),
            status: .active)
    }
    
    var body: some View {
//        TabsView()
        TodoItemGroupEditView(todoItemGroup: todoItemGroup)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
