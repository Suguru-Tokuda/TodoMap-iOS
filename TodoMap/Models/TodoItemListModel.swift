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
}
