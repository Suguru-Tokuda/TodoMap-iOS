//
//  TodoItemService.swift
//  TodoMap
//
//  Created by Suguru on 9/5/23.
//

import CoreData

class TodoItemService {
    let shared = TodoItemService()
    let container: NSPersistentContainer
    @Published var savedTodoItemGrouops: [TodoItemListEntity] = []
    
    init() {
        container = NSPersistentContainer(name: "TodoMapModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("ERROR LOADING CORE DATA. \(error)")
            } else {
                print("Successfully loaded core data!")
            }
        }
    }
    
    func fetchTodoItemGroups() {
        let request = NSFetchRequest<TodoItemListEntity>(entityName: "TodoItemGroup")
        do {
            let _ = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching. \(error)")
        }
    }
    
    func addTodoItemListEntity() {
        // TOOD
    }
}
