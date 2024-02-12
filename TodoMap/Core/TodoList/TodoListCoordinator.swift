//
//  TodoListCoordinator.swift
//  TodoMap
//
//  Created by Suguru Tokuda on 2/11/24.
//

import Foundation
import SwiftUI

@MainActor
class TodoListCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    
    func startCoordinator() {
        path.append(TodoListPage.todoList)
    }
    
    @ViewBuilder
    func getPage(page: TodoListPage) -> some View {
        switch page {
        case .todoList:
            TodoItemGroupListView()
        }
    }
}

enum TodoListPage: String, CaseIterable, Identifiable {
    case todoList
    var id: String { self.rawValue }
}
