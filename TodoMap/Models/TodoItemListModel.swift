//
//  TodoItemGroupModel.swift
//  TodoMap
//
//  Created by Suguru on 8/8/23.
//

import Foundation

struct TodoItemListModel: Identifiable, Hashable {
    var id: UUID = UUID()
    var name: String
    var items: [TodoItemModel]
    var location: LocationModel?
    var created: Date
    var status: Status
    
    init() {
        name = ""
        items = []
        created = Date()
        status = .active
    }
    
    init(id: UUID, name: String, items: [TodoItemModel], location: LocationModel, created: Date, status: Status) {
        self.id = id
        self.name = name
        self.items = items
        self.created = created
        self.status = status
    }
    
    init(name: String, items: [TodoItemModel], location: LocationModel, created: Date, status: Status) {
        self.name = name
        self.items = items
        self.location = location
        self.created = created
        self.status = status
    }
    
    init?(from entity: TodoItemListEntity) {
        if let id = entity.id,
           let name = entity.name,
           let created = entity.created {
            self.id = id
            self.name = name
            self.location = LocationModel(from: entity.locationEntity)
            self.created = created
            self.items = []
            self.status = Status(rawValue: entity.status) ?? .inactive
            
            if let items = entity.todoItemEntity,
               let itemSet = items as? Set<TodoItemEntity> {
                itemSet.forEach { item in
                    if let itemModel: TodoItemModel = .init(from: item) {
                        self.items.append(itemModel)
                    }
                }
            }
        } else {
            return nil
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: TodoItemListModel, rhs: TodoItemListModel) -> Bool {
        lhs.id == rhs.id
    }
}
