//
//  TodoItemModel.swift
//  TodoMap
//
//  Created by Suguru on 8/8/23.
//

import SwiftUI

class TodoItemModel: Identifiable, Hashable {
    var id: UUID
    var name: String
    var note: String
    var completed: Bool
    var created: Date
    
    init(id: UUID, name: String, note: String, completed: Bool, created: Date) {
        self.id = id
        self.name = name
        self.note = note
        self.completed = completed
        self.created = created
    }
    
    init?(from entity: TodoItemEntity) {
        if let id = entity.id,
           let name = entity.name,
           let created = entity.created {
            self.id = id
            self.name = name
            self.note = entity.note ?? ""
            self.completed = entity.completed
            self.created = created
        } else {
            return nil
        }
    }
    
    static func == (lhs: TodoItemModel, rhs: TodoItemModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
