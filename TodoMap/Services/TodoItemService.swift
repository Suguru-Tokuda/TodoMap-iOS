//
//  TodoItemService.swift
//  TodoMap
//
//  Created by Suguru on 9/5/23.
//

import CoreData

class TodoItemService {
    static let shared = TodoItemService()
    let container: NSPersistentContainer
    let todoListEntityName = "TodoItemListEntity"
    let todoItemEntityName = "TodoItemEntity"
    let locationEntityName = "LocationEntity"
    @Published var savedTodoItemGrouops: [TodoItemListEntity] = []
    /*
        Used to track TodoItemListEntity to achieve O(1) access
     */
    var todoItemListDict: [UUID : TodoItemListEntity] = [:]
    
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
    
    func getTodoLists() -> [TodoItemListEntity] {
        let request = NSFetchRequest<TodoItemListEntity>(entityName: todoListEntityName)
        do {
            let resultSet = try container.viewContext.fetch(request)
            
            resultSet.forEach { list in
                if let id = list.id {
                    todoItemListDict[id] = list
                }
            }
            
            return resultSet
        } catch let error {
            print("Error fetching todo list entities. \(error)")
        }
        
        return []
    }
    
    func getTodoListEntity(id: UUID) -> TodoItemListEntity? {
        if let item = todoItemListDict[id] {
            return item
        }
    
        let request = NSFetchRequest<TodoItemListEntity>(entityName: todoListEntityName)
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let resultSet = try container.viewContext.fetch(request)
            if !resultSet.isEmpty {
                return resultSet[0]
            } else {
                return nil
            }
        } catch let error {
            print("Error fetching todo list entity. \(error)")
        }
        
        return nil
    }
    
    /*
        Create a new TodoItemListEntity if it does not exist in the Core Data
        If exists, then it simply updates the entity.
     */
    func mergeTodoItemListEntity(list: TodoItemListModel) {
        // find an existing eitnty first to avoid duplicate entities.
        var itemToSave: TodoItemListEntity? = getTodoListEntity(id: list.id)
        if itemToSave == nil { itemToSave = TodoItemListEntity(context: container.viewContext) }
        
        if let itemToSave = itemToSave {
            itemToSave.id = list.id
            itemToSave.created = list.created
            itemToSave.name = list.name
            itemToSave.status = list.status.rawValue
            applyChanges()
            todoItemListDict[list.id] = itemToSave
        }
    }
    
    func deleteTodoItemListEntity(id: UUID, entity: TodoItemListEntity?) {
        if entity != nil {
            container.viewContext.delete(entity!)
            applyChanges()
        } else {
            var existingEntity: TodoItemListEntity? = todoItemListDict[id]
            
            if existingEntity == nil {
                existingEntity = getTodoListEntity(id: id)
            }
            
            container.viewContext.delete(entity!)
            applyChanges()
        }
        
        todoItemListDict.removeValue(forKey: id)
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving to Core Data. \(error)")
        }
    }
    
    private func applyChanges() {
        save()
    }
}
