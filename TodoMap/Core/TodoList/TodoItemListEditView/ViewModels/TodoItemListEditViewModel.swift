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
    @Published var coreDataError: CoreDataError?
    var handlingScrollViewTapped: Bool = false
    var cancellables: Set<AnyCancellable> = []
    var todoMapCoreDataManager: TodoMapCoreDataActions
    
    init(todoItemGroup: TodoItemListModel?, todoMapCorreDataManager: TodoMapCoreDataActions = TodoMapCoreDataManager()) {
        self.todoItemList = todoItemGroup != nil ? todoItemGroup! : TodoItemListModel()
        self.todoMapCoreDataManager = todoMapCorreDataManager
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
    
    func deleteTodoItem(id: UUID) async {
        if let index = todoItemList.items.firstIndex(where: { $0.id == id }) {
            do {
                try await todoMapCoreDataManager.deleteTodoItemList(id: id)
                todoItemList.items.remove(at: index)
            } catch {
                if let error = error as? CoreDataError {
                    self.coreDataError = error
                }
            }
        }        
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
                Task {
                    do {
                        try await self.todoMapCoreDataManager.saveTodoItemList(list: value)
                    } catch {
                        if let error = error as? CoreDataError {
                            self.coreDataError = error
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func resetFocusIndex() {
        focusIndex = -1
    }
}
