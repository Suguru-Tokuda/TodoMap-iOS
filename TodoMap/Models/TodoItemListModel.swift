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
    var location: String
    var created: Date
    var status: Status
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: TodoItemListModel, rhs: TodoItemListModel) -> Bool {
        lhs.id == rhs.id
    }
    
    static func parseTodoItemListEntity(entity: TodoItemListEntity) -> TodoItemListModel {
        var retVal = TodoItemListModel(
            name: entity.name ?? "",
            items: [],
            location: "",
            created: entity.created ?? Date(),
            status: Status(rawValue: entity.status) ?? Status.active
        )
        
        retVal.id = entity.id ?? UUID()
        
        if let items = entity.todoItemEntity,
           let itemSet = items as? Set<TodoItemEntity> {
            itemSet.forEach { item in
                if let id = item.id,
                   let name = item.name,
                   let created = item.created {
                    retVal.items.append(TodoItemModel(id: id,
                                                      name: name,
                                                      note: item.note ?? "",
                                                      completed: item.completed,
                                                      created: created))
                }
            }
        }
        
        return retVal
    }
}
