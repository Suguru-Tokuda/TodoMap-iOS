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
            return !resultSet.isEmpty ? resultSet[0] : nil
        } catch let error {
            print("Error fetching todo list entity. \(error)")
        }
        
        return nil
    }
    
    func getTodoListItemEntities(list: TodoItemListEntity) -> [TodoItemEntity] {
        let request = NSFetchRequest<TodoItemEntity>(entityName: todoItemEntityName)
        request.predicate = NSPredicate(format: "todoItemOrigin = %@", list)
        
        do {
            let resultSet = try container.viewContext.fetch(request)
            return resultSet
        } catch let error {
            print("Error fetching todo list item entities. \(error)")
        }
        
        return []
    }
    
    func getTodoListItem(id: UUID) -> TodoItemEntity? {
        let request = NSFetchRequest<TodoItemEntity>(entityName: todoItemEntityName)
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let resultSet = try container.viewContext.fetch(request)
            return !resultSet.isEmpty ? resultSet[0] : nil
        } catch let error {
            print("Error fetching todo list item entity. \(error)")
        }

        return nil
    }
    
    /*
        Create a new TodoItemListEntity if it does not exist in the Core Data
        If exists, then it simply updates the entity.
     */
    func mergeTodoItemListEntity(list: TodoItemListModel) {
        // find an existing eitnty first to avoid duplicate entities.
        var listToSave: TodoItemListEntity? = getTodoListEntity(id: list.id)
        if listToSave == nil { listToSave = TodoItemListEntity(context: container.viewContext) }
        
        if let listToSave = listToSave {
            listToSave.id = list.id
            listToSave.created = list.created
            listToSave.name = list.name
            listToSave.status = list.status.rawValue
            
            if !list.name.isEmpty {
                list.items.forEach { item in
                    if !item.name.isEmpty {
                        var createNew = false
                        var todoItemEntity = getTodoListItem(id: item.id)

                        if todoItemEntity == nil {
                            createNew = true
                            todoItemEntity = TodoItemEntity(context: container.viewContext)
                        }
                        
                        if todoItemEntity != nil {
                            todoItemEntity!.id = item.id
                            todoItemEntity!.name = item.name
                            todoItemEntity!.note = item.note
                            todoItemEntity!.created = item.created
                            todoItemEntity!.completed = item.completed
                            todoItemEntity!.todoItemOrigin = listToSave
                        }
                        
                        if createNew {
                            listToSave.addToTodoItemEntity(todoItemEntity!)
                        }
                    }
                }
            }
            
            applyChanges()
            todoItemListDict[list.id] = listToSave
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
    
    func deleteTodoItemEntity(id: UUID, entity: TodoItemEntity? = nil) {
        if entity != nil {
            container.viewContext.delete(entity!)
            applyChanges()
        } else {
            if let existingEntity = getTodoListItem(id: id) {
                container.viewContext.delete(existingEntity)
                applyChanges()
            }
        }
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
