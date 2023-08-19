//
//  TodosViewModel.swift
//  TodoMap
//
//  Created by Suguru on 8/8/23.
//

import Foundation

class TodosViewModel: ObservableObject {
    @Published var todoItemGroups: [TodoItemGroupModel] = []
    
    init(todoItemGroups: [TodoItemGroupModel]) {
        self.todoItemGroups = todoItemGroups
    }
}
