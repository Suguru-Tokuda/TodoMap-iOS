//
//  TodoListCoordinator.swift
//  TodoMap
//
//  Created by Suguru Tokuda on 2/11/24.
//

import SwiftUI

enum TodoListPage: String, CaseIterable, Identifiable {
    case todoList,
         todoListEditor
    var id: String { self.rawValue }
}
    
//enum TodoListSheet: String, Identifiable {
//    case someSheet
//    var id: String { self.rawValue }
//}
//
//enum TodoListFullScreenCover: String, Identifiable {
//    case someFullScreenSheet
//    var id: String { self.rawValue }
//}

class TodoListCoordinator: ObservableObject {
    @Published var path = NavigationPath()
//    @Published var sheet: TodoListSheet?
//    @Published var fullScreenCover: TodoListFullScreenCover?
    var todoListGroup: TodoItemListModel?
    
    func push(_ page: TodoListPage, todoListGroup: TodoItemListModel? = nil) {
        self.todoListGroup = todoListGroup
        path.append(page)
    }
    
//    func presentSheet(_ sheet: TodoListSheet) {
//        self.sheet = sheet
//    }
//    
//    func presentFullSreenCover(_ fullScreenCover: TodoListFullScreenCover) {
//        self.fullScreenCover = fullScreenCover
//    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
//    func dismissSheet() {
//        self.sheet = nil
//    }
//    
//    func dismissFullScreenCover() {
//        self.fullScreenCover = nil
//    }

    @ViewBuilder
    func build(page: TodoListPage) -> some View {
        switch page {
        case .todoList:
            TodoItemGroupListView(todoItemGroups: [])
        case .todoListEditor:
            TodoItemListEditView(todoItemGroup: todoListGroup)
        }
    }
}
