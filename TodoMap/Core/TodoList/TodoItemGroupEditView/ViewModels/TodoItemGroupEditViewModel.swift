//
//  TodoItemGroupCreateViewModel.swift
//  TodoMap
//
//  Created by Suguru on 8/8/23.
//

import Foundation

class TodoItemGroupEditViewModel: ObservableObject {
    @Published var todoItemGroup: TodoItemGroupModel
    @Published var focusIndex: Int = -1
    var handlingScrollViewTapped: Bool = false
//    @Published var name: String = ""
//    @Published var items: [TodoItemModel] = [
//        TodoItemModel(
//            id: UUID(),
//            name: "",
//            description: "",
//            status: .active,
//            created: Date())
//    ]
    
    init(todoItemGroup: TodoItemGroupModel) {
        self.todoItemGroup = todoItemGroup
    }
    
    // MARK: public functions
    func addTodoItem() {
        self.todoItemGroup.items.append(TodoItemModel(id: UUID(), name: "", note: "", completed: false, created: Date()))
        self.focusIndex = todoItemGroup.items.count - 1
    }
    
    func isLastItemEmpty() -> Bool {
        if !todoItemGroup.items.isEmpty {
            if let lastItem = todoItemGroup.items.last {
                return lastItem.name.isEmpty
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func handleScrollViewTapped(_ keyboardVisible: Bool) {
        resetFocusIndex()
        
        if !handlingScrollViewTapped && isLastItemEmpty() {
            handlingScrollViewTapped = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.todoItemGroup.items.removeLast()
                self.handlingScrollViewTapped = false
            }
        } else if !keyboardVisible && !isLastItemEmpty() {
            addTodoItem()
        }
    }

    // MARK: Private functions
    private func resetFocusIndex() {
        focusIndex = -1
    }
}
