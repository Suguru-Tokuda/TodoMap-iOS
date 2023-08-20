//
//  TodoItemModel.swift
//  TodoMap
//
//  Created by Suguru on 8/8/23.
//

import Foundation

struct TodoItemModel: Identifiable, Hashable {
    var id: UUID
    var name: String
    var note: String
    var completed: Bool
    var created: Date
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
