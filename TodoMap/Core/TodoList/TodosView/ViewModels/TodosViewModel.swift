//
//  TodosViewModel.swift
//  TodoMap
//
//  Created by Suguru on 8/8/23.
//

import SwiftUI

class TodosViewModel: ObservableObject {
    @Published var todoItemGroups: [TodoItemListModel] = []
    @Published var errorOccured = false
    var coreDataError: CoreDataError?
    var coreDataManager: TodoMapCoreDataActions
    
    init(coreDataManager: TodoMapCoreDataActions = TodoMapCoreDataManager()) {
        self.coreDataManager = coreDataManager
    }
    
    func parseTodoItemListEntities(_ entities: FetchedResults<TodoItemListEntity>) {
        DispatchQueue.main.async {
            var todoItemGroups: [TodoItemListModel] = []
            
            entities.forEach { entity in
                if let model: TodoItemListModel = .init(from: entity) {
                    todoItemGroups.append(model)
                }
            }
            
            self.todoItemGroups = todoItemGroups
        }
    }
    
    func getAllLists() async {
        do {
            let list = try await coreDataManager.getTodoItemListEntities()
            let parsedList = list.compactMap { TodoItemListModel.init(from: $0) }
            
            DispatchQueue.main.async {
                self.todoItemGroups = parsedList
                
                parsedList.forEach { list in
                    print(list.name)
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.coreDataError = error as? CoreDataError ?? nil
                self.errorOccured = self.coreDataError != nil
            }
        }
    }
    
    func deleteList(_ list: TodoItemListModel) async {
        do {
            for item in list.items {
                try await coreDataManager.deleteTodoItem(id: item.id, entity: nil)
            }
            
            try await coreDataManager.deleteTodoItemList(id: list.id, entity: nil)
        } catch {
            DispatchQueue.main.async {
                self.coreDataError = error as? CoreDataError ?? nil
                self.errorOccured = self.coreDataError != nil
            }
        }
    }
    
    func supressError() {
        DispatchQueue.main.async {
            self.coreDataError = nil
            self.errorOccured = false
        }
    }
}
