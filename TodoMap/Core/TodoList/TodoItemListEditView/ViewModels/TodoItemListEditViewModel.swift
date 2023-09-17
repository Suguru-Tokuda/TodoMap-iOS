//
//  TodoItemGroupCreateViewModel.swift
//  TodoMap
//
//  Created by Suguru on 8/8/23.
//

import Foundation
import Combine

class TodoItemListEditViewModel: ObservableObject {
    @Published var todoItemList: TodoItemListModel
    @Published var focusIndex: Int = -1
    var handlingScrollViewTapped: Bool = false
    var cancellables: Set<AnyCancellable> = []
    
    init(todoItemGroup: TodoItemListModel) {
        self.todoItemList = todoItemGroup
        self.addSubscriptions()
    }
    
    deinit {
        self.cancellables.forEach { cancllable in
            cancllable.cancel()
        }
    }
    
    // MARK: public functions
    func addTodoItem() {
        self.todoItemList.items.append(TodoItemModel(id: UUID(), name: "", note: "", completed: false, created: Date()))
        self.focusIndex = todoItemList.items.count - 1
    }
    
    func isLastItemEmpty() -> Bool {
        if !todoItemList.items.isEmpty {
            if let lastItem = todoItemList.items.last {
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
                self.todoItemList.items.removeLast()
                self.handlingScrollViewTapped = false
            }
        } else if !keyboardVisible && !isLastItemEmpty() {
            addTodoItem()
        }
    }

    // MARK: Private functions
    private func addSubscriptions() {
        $todoItemList
            .receive(on: DispatchQueue.main)
            .sink { value in
                TodoItemService.shared.mergeTodoItemListEntity(list: value)
            }
            .store(in: &cancellables)
    }
    
    private func resetFocusIndex() {
        focusIndex = -1
    }
}
