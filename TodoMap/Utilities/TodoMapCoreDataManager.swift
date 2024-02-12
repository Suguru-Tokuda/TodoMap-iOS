//
//  CoreDataManager.swift
//  TodoMap
//
//  Created by Suguru Tokuda on 2/9/24.
//

import Foundation
import CoreData

protocol TodoMapCoreDataActions {
    func saveTodoItemList(list: TodoItemListModel, context: NSManagedObjectContext?) async throws
    func getTodoItemListEntities(context: NSManagedObjectContext?) async throws -> [TodoItemListEntity]
    func getTodoItemListEntity(id: UUID, context: NSManagedObjectContext?) async throws -> TodoItemListEntity?
    func getTodoItemList(id: UUID, entity: TodoItemListEntity?, context: NSManagedObjectContext?) async throws -> TodoItemListModel
    func getTodoListItem(id: UUID, context: NSManagedObjectContext?) async throws -> TodoItemEntity?
    func deleteTodoItemList(id: UUID, entity: TodoItemListEntity?, context: NSManagedObjectContext?) async throws
    func clearAllFromDatabase(context: NSManagedObjectContext?) async throws
    func save(context: NSManagedObjectContext?) throws
}

extension TodoMapCoreDataActions {
    func saveTodoItemList(list: TodoItemListModel, context: NSManagedObjectContext? = nil) async throws {
        do {
            let context = context ?? PersistentController.shared.container.newBackgroundContext()

            var listToSave: TodoItemListEntity? = try await self.getTodoItemListEntity(id: list.id, context: context)
            if listToSave == nil { listToSave = TodoItemListEntity(context: context) }
            
            if let listToSave = listToSave {
                listToSave.id = list.id
                listToSave.created = list.created
                listToSave.name = list.name
                listToSave.status = list.status.rawValue
                
                if !list.name.isEmpty {
                    list.items.forEach { item in
                        Task {
                            var createNew = false
                            var todoItemEntity = try await self.getTodoListItem(id: item.id, context: context)
                            
                            if todoItemEntity == nil {
                                todoItemEntity = TodoItemEntity(context: context)
                                createNew = true
                            }
                            
                            if let todoItemEntity {
                                todoItemEntity.id = item.id
                                todoItemEntity.name = item.name
                                todoItemEntity.note = item.note
                                todoItemEntity.created = item.created
                                todoItemEntity.completed = item.completed
                                todoItemEntity.todoItemOrigin = listToSave
                            }
                            
                            if createNew { listToSave.addToTodoItemEntity(todoItemEntity!) }

                        }
                    }
                }
            }
            
            try self.save(context: context)
        } catch {
            throw error
        }
    }
    
    func getTodoItemListEntities(context: NSManagedObjectContext? = nil) async throws -> [TodoItemListEntity] {
        let context = context ?? PersistentController.shared.container.newBackgroundContext()
        let request = NSFetchRequest<TodoItemListEntity>(entityName: TodoListCoreDataEntity.todoList.rawValue)
        
        do {
            let resultSet = try context.fetch(request)
            return resultSet
        } catch {
            throw CoreDataError.get
        }
    }

    func getTodoItemListEntity(id: UUID, context: NSManagedObjectContext? = nil) async throws -> TodoItemListEntity? {
        let context = context ?? PersistentController.shared.container.newBackgroundContext()
        let request = NSFetchRequest<TodoItemListEntity>(entityName: TodoListCoreDataEntity.todoList.rawValue)
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let resultSet = try context.fetch(request)
            return resultSet.first
        } catch {
            throw CoreDataError.get
        }
    }
    
    func getTodoItemList(id: UUID, entity: TodoItemListEntity?, context: NSManagedObjectContext? = nil) async throws -> TodoItemListModel {
        let context = context ?? PersistentController.shared.container.newBackgroundContext()
        if let entity {
            return TodoItemListModel.parseTodoItemListEntity(entity: entity)
        } else {
            do {
                if let entityData = try await getTodoItemListEntity(id: id, context: context) {
                    return TodoItemListModel.parseTodoItemListEntity(entity: entityData)
                } else {
                    throw CoreDataError.get
                }
            } catch {
                throw error
            }
        }
    }
    
    func getTodoListItem(id: UUID, context: NSManagedObjectContext? = nil) async throws -> TodoItemEntity? {
        let context = context ?? PersistentController.shared.container.newBackgroundContext()
        let request = NSFetchRequest<TodoItemEntity>(entityName: TodoListCoreDataEntity.todoItem.rawValue)
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let resultSet = try context.fetch(request)
            return resultSet.first
        } catch {
            throw CoreDataError.get
        }
    }
    
    func deleteTodoItemList(id: UUID, entity: TodoItemListEntity? = nil, context: NSManagedObjectContext? = nil) async throws {
        let context = context ?? PersistentController.shared.container.newBackgroundContext()

        if let entity {
            context.delete(entity)
            try self.save(context: context)
        } else {
            Task {
                let context = PersistentController.shared.container.newBackgroundContext()
                if let existingEntity = try await self.getTodoListItem(id: id, context: context) {
                    context.delete(existingEntity)
                    try self.save(context: context)
                }
            }
        }
    }
    
    func clearAllFromDatabase(context: NSManagedObjectContext? = nil) async throws {
        let context = context ?? PersistentController.shared.container.newBackgroundContext()

        do {
            let allListEntities = try await getTodoItemListEntities(context: context)
            
            allListEntities.forEach { listEntity in
                
                if let items = listEntity.todoItemEntity as? Set<TodoItemEntity> {
                    items.forEach { context.delete($0) }
                }
                
                context.delete(listEntity)
            }
            
            try save(context: context)
        } catch {
            throw CoreDataError.delete
        }
    }
    
    func save(context: NSManagedObjectContext? = nil) throws {
        let context = context ?? PersistentController.shared.container.newBackgroundContext()
        do {
            try context.save()
        } catch {
            throw CoreDataError.save
        }
    }
}

enum TodoListCoreDataEntity: String {
    case todoList = "TodoItemListEntity",
         todoItem = "TodoItemEntity",
         location = "LocationEntity"
}

class TodoMapCoreDataManager: TodoMapCoreDataActions {
    init() {
        pritSqlLocation()
    }

    func pritSqlLocation() {
        let path = FileManager
            .default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)
            .last?
            .absoluteString
            .replacingOccurrences(of: "file://", with: "")
            .removingPercentEncoding
        
        print("Core Data DB Path :: \(path ?? "Not Found")")
    }
}
