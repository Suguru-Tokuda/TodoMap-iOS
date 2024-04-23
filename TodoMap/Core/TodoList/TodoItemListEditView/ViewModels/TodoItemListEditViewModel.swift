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
    @Published var errorOccured: Bool = false
    var coreDataError: CoreDataError?
    var handlingScrollViewTapped: Bool = false
    var cancellables: Set<AnyCancellable> = []
    var saveOnChange: Bool = true
    var coordinatorType: CoordinatorType
    var todoMapCoreDataManager: TodoMapCoreDataActions
    var onLocationSelect: ((LocationModel) -> ())?
    
    init(todoItemGroup: TodoItemListModel?, 
         coordinatorType: CoordinatorType = .todoList,
         saveOnChange: Bool = true,
         todoMapCorreDataManager: TodoMapCoreDataActions = TodoMapCoreDataManager()) {
        self.todoItemList = todoItemGroup != nil ? todoItemGroup! : TodoItemListModel()
        self.todoMapCoreDataManager = todoMapCorreDataManager
        self.saveOnChange = saveOnChange
        self.coordinatorType = coordinatorType
        if saveOnChange { self.addSubscriptions() }
    }
    
    deinit {
        self.cancellables.forEach { $0.cancel() }
    }
    
    // MARK: public functions
    func addTodoItem() {
        DispatchQueue.main.async {
            self.todoItemList.items.append(TodoItemModel(id: UUID(), name: "", note: "", completed: false, created: Date()))
            self.focusIndex = self.todoItemList.items.count - 1
        }
    }
    
    func deleteTodoItem(id: UUID) async {
        if let index = todoItemList.items.firstIndex(where: { $0.id == id }) {
            do {
                try await todoMapCoreDataManager.deleteTodoItem(id: id, entity: nil)
                DispatchQueue.main.async {
                    self.todoItemList.items.remove(at: index)
                }
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
    
    func setLocation(_ location: LocationModel?) {
        self.todoItemList.location = location
    }
    
    // Removes empty items
    func saveDeleteItems() async {
        do {
            for item in todoItemList.items {
                if item.name.isEmpty {
                    try await todoMapCoreDataManager.deleteTodoItem(id: item.id, entity: nil)
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.errorOccured = true
                self.coreDataError = error as? CoreDataError ?? nil
            }
        }
    }
    
    func saveList() async {
        do {
            try await self.todoMapCoreDataManager.saveTodoItemList(list: todoItemList)
        } catch {
            if let error = error as? CoreDataError {
                DispatchQueue.main.async {
                    self.coreDataError = error
                    self.errorOccured = true
                }
            }
        }
    }

    // MARK: Private functions
    private func addSubscriptions() {
        $todoItemList
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self = self else { return }
                
                if !value.name.isEmpty {
                    Task {
                        do {
                            try await self.todoMapCoreDataManager.saveTodoItemList(list: value)
                        } catch {
                            if let error = error as? CoreDataError {
                                DispatchQueue.main.async {
                                    self.coreDataError = error
                                    self.errorOccured = true
                                }
                            }
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func resetFocusIndex() {
        DispatchQueue.main.async {
            self.focusIndex = -1
        }
    }
    
    func addLocationSubscription(subject: inout PassthroughSubject<LocationModel?, Never>) {
        subject
            .receive(on: DispatchQueue.main)
            .sink { location in
                if let location {
                    self.todoItemList.location = location
                    self.onLocationSelect?(location)
                }
            }
            .store(in: &cancellables)
    }
}
