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
    
enum TodoListSheet: String, CaseIterable, Identifiable {
    case none
    var id: String { self.rawValue }
}

enum TodoListFullScreenCover: String, CaseIterable, Identifiable {
    case map
    var id: String { self.rawValue }
}

class TodoListCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    @Published var sheet: TodoListSheet?
    @Published var fullScreenCover: TodoListFullScreenCover?
    
    var location: ReverseGeocodeModel?
    var todoListGroup: TodoItemListModel?
    var onLocationSelect: ((LocationModel) -> ())?
    
    func push(_ page: TodoListPage) {
        self.todoListGroup = nil
        path.append(page)
    }
    
    func push(_ page: TodoListPage, todoListGroup: TodoItemListModel? = nil) {
        self.todoListGroup = todoListGroup
        path.append(page)
    }
    
    func presentSheet(_ sheet: TodoListSheet) {
        self.sheet = sheet
    }
    
    func presentFullSreenCover(_ fullScreenCover: TodoListFullScreenCover) {
        self.fullScreenCover = fullScreenCover
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func dismissSheet() {
        self.sheet = nil
    }
    
    func dismissFullScreenCover() {
        self.fullScreenCover = nil
    }
    
    
    func selectLocation(_ location: LocationModel) {
        self.onLocationSelect?(location)
        dismissFullScreenCover()
    }

    @ViewBuilder
    func build(page: TodoListPage) -> some View {
        switch page {
        case .todoList:
            TodoItemGroupListView()
        case .todoListEditor:
            TodoItemListEditView(todoItemGroup: todoListGroup)
        }
    }
    
    @ViewBuilder
    func build(sheet: TodoListSheet) -> some View {
        switch sheet {
        case .none:
            EmptyView()
        }
    }
    
    @ViewBuilder
    func build(fullScreenCover: TodoListFullScreenCover) -> some View {
        switch fullScreenCover {
        case .map:
            LocationSearchSheetView()
        }
    }
}
