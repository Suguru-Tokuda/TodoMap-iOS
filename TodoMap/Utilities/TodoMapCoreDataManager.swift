//
//  CoreDataManager.swift
//  TodoMap
//
//  Created by Suguru Tokuda on 2/9/24.
//

import CoreData

enum TodoListCoreDataEntity: String {
    case todoList = "TodoItemListEntity",
         todoItem = "TodoItemEntity",
         location = "LocationEntity"
}

protocol TodoMapCoreDataActions {
    func saveTodoItemList(list: TodoItemListModel) async throws
    func getTodoItemListEntities() async throws -> [TodoItemListEntity]
    func getTodoItemListEntity(id: UUID) async throws -> TodoItemListEntity?
    func getLocationEntity(id: UUID) async throws -> LocationEntity?
    func getTodoItemList(id: UUID, entity: TodoItemListEntity?) async throws -> TodoItemListModel?
    func getTodoListItem(id: UUID) async throws -> TodoItemEntity?
    func deleteTodoItemList(id: UUID, entity: TodoItemListEntity?) async throws
    func deleteTodoItem(id: UUID, entity: TodoItemEntity?) async throws
    func deleteLocation(id: UUID, entity: LocationEntity?) async throws
    func clearAllFromDatabase() async throws
    func save() throws
}

class TodoMapCoreDataManager: TodoMapCoreDataActions {
    let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistentController.shared.container.newBackgroundContext()) {
        self.context = context
        printSqlLocation()
    }

    func saveTodoItemList(list: TodoItemListModel) async throws {
        do {
            var listToSave: TodoItemListEntity? = try await self.getTodoItemListEntity(id: list.id)
            if listToSave == nil { listToSave = TodoItemListEntity(context: context) }
            
            if var listToSave = listToSave {
                listToSave.id = list.id
                listToSave.created = list.created
                listToSave.name = list.name
                listToSave.status = list.status.rawValue
                
                if !list.name.isEmpty {
                    // Manage items
                    try await manageItems(items: list.items, listEntity: &listToSave)
                }
                
                // Manage location
                listToSave.locationEntity = try await manageLocation(location: list.location, listEntity: &listToSave)

                try self.save()
            } else {
                throw CoreDataError.save
            }
        } catch {
            throw error
        }
    }
    
    private func manageItems(items: [TodoItemModel], listEntity: inout TodoItemListEntity) async throws {
        do {
            for item in items {
                var createNew = false
                var todoItemEntity = try await self.getTodoListItem(id: item.id)
                
                guard !item.name.isEmpty || item.note.isEmpty else {
                    if let todoItemEntity {
                        listEntity.removeFromTodoItemEntity(todoItemEntity)
                    }
                    continue
                }

                if todoItemEntity == nil {
                    todoItemEntity = TodoItemEntity()
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
    
    private func manageLocation(location: LocationModel?, listEntity: inout TodoItemListEntity) async throws -> LocationEntity? {
        var retVal: LocationEntity?
        
        // location has been removed. remove the location data from database
        if location == nil && listEntity.locationEntity != nil {
            if let locationEntity = listEntity.locationEntity,
               let id = locationEntity.id {
                do {
                    try await deleteLocation(id: id, entity: locationEntity)
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
            let locationEntity = LocationEntity()
            
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
    
    func getTodoItemListEntities() async throws -> [TodoItemListEntity] {
        let request = NSFetchRequest<TodoItemListEntity>(entityName: TodoListCoreDataEntity.todoList.rawValue)
        
        do {
            let resultSet = try context.fetch(request)
            return resultSet
        } catch {
            throw CoreDataError.get
        }
    }

    func getTodoItemListEntity(id: UUID) async throws -> TodoItemListEntity? {
        let request = NSFetchRequest<TodoItemListEntity>(entityName: TodoListCoreDataEntity.todoList.rawValue)
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let resultSet = try context.fetch(request)
            return resultSet.first
        } catch {
            throw CoreDataError.get
        }
    }
    
    func getLocationEntity(id: UUID) async throws -> LocationEntity? {
        let request = NSFetchRequest<LocationEntity>(entityName: TodoListCoreDataEntity.location.rawValue)
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let resultSet = try context.fetch(request)
            return resultSet.first
        } catch {
            throw CoreDataError.get
        }
    }
    
    func getTodoItemList(id: UUID, entity: TodoItemListEntity?) async throws -> TodoItemListModel? {
        if let entity {
            return .init(from: entity)
        } else {
            do {
                if let entityData = try await getTodoItemListEntity(id: id) {
                    return .init(from: entityData)
                } else {
                    throw CoreDataError.get
                }
            } catch {
                throw error
            }
        }
    }
    
    func getTodoListItem(id: UUID) async throws -> TodoItemEntity? {
        let request = NSFetchRequest<TodoItemEntity>(entityName: TodoListCoreDataEntity.todoItem.rawValue)
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let resultSet = try context.fetch(request)
            return resultSet.first
        } catch {
            throw CoreDataError.get
        }
    }
    
    func deleteTodoItemList(id: UUID, entity: TodoItemListEntity? = nil) async throws {
        var entity = entity
        
        if entity == nil {
            entity = try await self.getTodoItemListEntity(id: id)
        }
        
        guard let entity else { throw CoreDataError.delete }
        
        if let items = entity.todoItemEntity as? Set<TodoItemEntity> {
            for item in items {
                if let id = item.id {
                    try await deleteTodoItem(id: id, entity: item)
                }
            }
        }
        
        if let locationEntity = entity.locationEntity,
           let id = locationEntity.id {
            try await deleteLocation(id: id, entity: locationEntity)
        }
        
        context.delete(entity)
        try self.save()
    }
    
    func deleteTodoItem(id: UUID, entity: TodoItemEntity? = nil) async throws {
        var entity = entity
        
        if entity == nil {
            entity = try await self.getTodoListItem(id: id)
        }
        
        guard let entity else { throw CoreDataError.delete }
        context.delete(entity)
        try self.save()
    }
    
    func deleteLocation(id: UUID, entity: LocationEntity?) async throws {
        var entity = entity
        
        if entity == nil {
            entity = try await self.getLocationEntity(id: id)
        }
        
        guard let entity else { throw CoreDataError.delete }
        context.delete(entity)
        try self.save()
    }
    
    func clearAllFromDatabase() async throws {
        do {
            let allListEntities = try await getTodoItemListEntities()
            
            allListEntities.forEach { listEntity in
                
                if let items = listEntity.todoItemEntity as? Set<TodoItemEntity> {
                    items.forEach { context.delete($0) }
                }
                
                context.delete(listEntity)
            }
            
            try save()
        } catch {
            throw CoreDataError.delete
        }
    }
    
    func save() throws {
        do {
            try context.save()
        } catch {
            throw CoreDataError.save
        }
    }

    func printSqlLocation() {
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
