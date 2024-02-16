//
//  CoreDataManager.swift
//  TodoMap
//
//  Created by Suguru Tokuda on 2/9/24.
//

import Foundation
import CoreData

protocol TodoMapCoreDataActions {
    func saveTodoItemList(list: TodoItemListModel, context: NSManagedObjectContext) async throws
    func getTodoItemListEntities(context: NSManagedObjectContext) async throws -> [TodoItemListEntity]
    func getTodoItemListEntity(id: UUID, context: NSManagedObjectContext) async throws -> TodoItemListEntity?
    func getLocationEntity(id: UUID, context: NSManagedObjectContext) async throws -> LocationEntity?
    func getTodoItemList(id: UUID, entity: TodoItemListEntity?, context: NSManagedObjectContext) async throws -> TodoItemListModel?
    func getTodoListItem(id: UUID, context: NSManagedObjectContext) async throws -> TodoItemEntity?
    func deleteTodoItemList(id: UUID, entity: TodoItemListEntity?, context: NSManagedObjectContext) async throws
    func deleteTodoItem(id: UUID, entity: TodoItemEntity?, context: NSManagedObjectContext) async throws
    func deleteLocation(id: UUID, entity: LocationEntity?, context: NSManagedObjectContext) async throws
    func clearAllFromDatabase(context: NSManagedObjectContext) async throws
    func save(context: NSManagedObjectContext) throws
}

extension TodoMapCoreDataActions {
    func saveTodoItemList(list: TodoItemListModel, context: NSManagedObjectContext = PersistentController.shared.container.newBackgroundContext()) async throws {
        do {
            var listToSave: TodoItemListEntity? = try await self.getTodoItemListEntity(id: list.id, context: context)
            if listToSave == nil { listToSave = TodoItemListEntity(context: context) }
            
            if var listToSave = listToSave {
                listToSave.id = list.id
                listToSave.created = list.created
                listToSave.name = list.name
                listToSave.status = list.status.rawValue
                
                if !list.name.isEmpty {
                    // Manage items
                    try await manageItems(items: list.items, listEntity: &listToSave, context: context)
                }
                
                // Manage location
                listToSave.locationEntity = try await manageLocation(location: list.location, listEntity: &listToSave, context: context)

                try self.save(context: context)
            } else {
                throw CoreDataError.save
            }
        } catch {
            throw error
        }
    }
    
    private func manageItems(items: [TodoItemModel], listEntity: inout TodoItemListEntity, context: NSManagedObjectContext) async throws {
        do {
            for item in items {
                var createNew = false
                var todoItemEntity = try await self.getTodoListItem(id: item.id, context: context)
                
                guard !item.name.isEmpty || item.note.isEmpty else {
                    if let todoItemEntity {
                        listEntity.removeFromTodoItemEntity(todoItemEntity)
                    }
                    continue
                }

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
                    todoItemEntity.todoItemOrigin = listEntity
                }
                
                if createNew { listEntity.addToTodoItemEntity(todoItemEntity!) }
            }
        } catch {
            throw CoreDataError.save
        }
    }
    
    private func manageLocation(location: LocationModel?, listEntity: inout TodoItemListEntity, context: NSManagedObjectContext) async throws -> LocationEntity? {
        var retVal: LocationEntity?
        
        // location has been removed. remove the location data from database
        if location == nil && listEntity.locationEntity != nil {
            if let locationEntity = listEntity.locationEntity,
               let id = locationEntity.id {
                do {
                    try await deleteLocation(id: id, entity: locationEntity, context: context)
                } catch {
                    throw CoreDataError.delete
                }
            }
        } else if location != nil && listEntity.locationEntity != nil {
            if let locationModel = location,
               let locationEntity = listEntity.locationEntity {
                locationEntity.name = locationModel.name
                locationEntity.locationDescription = locationModel.description
                locationEntity.longitutde = locationModel.coordinates.longitude
                locationEntity.latitude = locationModel.coordinates.latitude
                
                retVal = locationEntity
            }
        } else if location != nil && listEntity.locationEntity == nil {
            let locationEntity = LocationEntity(context: context)
            
            if let locationModel = location {
                locationEntity.id = locationModel.id
                locationEntity.name = locationModel.name
                locationEntity.locationDescription = locationModel.description
                locationEntity.longitutde = locationModel.coordinates.longitude
                locationEntity.latitude = locationModel.coordinates.latitude
                
                retVal = locationEntity
            }
        }
        
        if retVal != nil {
            retVal?.locationOrigin = listEntity
        }

        return retVal
    }
    
    func getTodoItemListEntities(context: NSManagedObjectContext = PersistentController.shared.container.newBackgroundContext()) async throws -> [TodoItemListEntity] {
        let request = NSFetchRequest<TodoItemListEntity>(entityName: TodoListCoreDataEntity.todoList.rawValue)
        
        do {
            let resultSet = try context.fetch(request)
            return resultSet
        } catch {
            throw CoreDataError.get
        }
    }

    func getTodoItemListEntity(id: UUID, context: NSManagedObjectContext = PersistentController.shared.container.newBackgroundContext()) async throws -> TodoItemListEntity? {
        let request = NSFetchRequest<TodoItemListEntity>(entityName: TodoListCoreDataEntity.todoList.rawValue)
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let resultSet = try context.fetch(request)
            return resultSet.first
        } catch {
            throw CoreDataError.get
        }
    }
    
    func getLocationEntity(id: UUID, context: NSManagedObjectContext) async throws -> LocationEntity? {
        let request = NSFetchRequest<LocationEntity>(entityName: TodoListCoreDataEntity.location.rawValue)
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let resultSet = try context.fetch(request)
            return resultSet.first
        } catch {
            throw CoreDataError.get
        }
    }
    
    func getTodoItemList(id: UUID, entity: TodoItemListEntity?, context: NSManagedObjectContext = PersistentController.shared.container.newBackgroundContext()) async throws -> TodoItemListModel? {
        if let entity {
            return .init(from: entity)
        } else {
            do {
                if let entityData = try await getTodoItemListEntity(id: id, context: context) {
                    return .init(from: entityData)
                } else {
                    throw CoreDataError.get
                }
            } catch {
                throw error
            }
        }
    }
    
    func getTodoListItem(id: UUID, context: NSManagedObjectContext = PersistentController.shared.container.newBackgroundContext()) async throws -> TodoItemEntity? {
        let request = NSFetchRequest<TodoItemEntity>(entityName: TodoListCoreDataEntity.todoItem.rawValue)
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let resultSet = try context.fetch(request)
            return resultSet.first
        } catch {
            throw CoreDataError.get
        }
    }
    
    func deleteTodoItemList(id: UUID, entity: TodoItemListEntity? = nil, context: NSManagedObjectContext = PersistentController.shared.container.newBackgroundContext()) async throws {
        var entity = entity
        
        if entity == nil {
            entity = try await self.getTodoItemListEntity(id: id, context: context)
        }
        
        guard let entity else { throw CoreDataError.delete }
        context.delete(entity)
        try self.save(context: context)
    }
    
    func deleteTodoItem(id: UUID, entity: TodoItemEntity? = nil, context: NSManagedObjectContext = PersistentController.shared.container.newBackgroundContext()) async throws {
        var entity = entity
        
        if entity == nil {
            entity = try await self.getTodoListItem(id: id, context: context)
        }
        
        guard let entity else { throw CoreDataError.delete }
        context.delete(entity)
        try self.save(context: context)
    }
    
    func deleteLocation(id: UUID, entity: LocationEntity?, context: NSManagedObjectContext) async throws {
        var entity = entity
        
        if entity == nil {
            entity = try await self.getLocationEntity(id: id, context: context)
        }
        
        guard let entity else { throw CoreDataError.delete }
        context.delete(entity)
        try self.save(context: context)
    }
    
    func clearAllFromDatabase(context: NSManagedObjectContext = PersistentController.shared.container.newBackgroundContext()) async throws {
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
    
    func save(context: NSManagedObjectContext = PersistentController.shared.container.newBackgroundContext()) throws {
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
