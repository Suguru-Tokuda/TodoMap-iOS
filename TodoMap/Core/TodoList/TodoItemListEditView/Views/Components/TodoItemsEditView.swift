//
//  TodoItemsEditView.swift
//  TodoMap
//
//  Created by Suguru on 8/13/23.
//

import SwiftUI

struct TodoItemsEditView: View{
    @Binding var focusIndex: Int
    @ObservedObject var vm: TodoItemListEditViewModel
    
    var body: some View {
        let todoItems = vm.todoItemList.items

        ForEach(Array(zip(vm.todoItemList.items.indices, vm.todoItemList.items)), id: \.1.id) { index, item in
            if index < todoItems.count {
                TodoItemEditView(
                    todoItem: $vm.todoItemList.items[index],
                    index: index,
                    focusIndex: $focusIndex
                ) { val in
                    handleValueChanged(value: val, index: index)
                }
                .swipeActions(actions: [Action(color: .red, name: "Delete", systemIcon: "trash.fill", action: {
                    Task {
                        let id = item.id
                        await vm.deleteTodoItem(id: id)
                    }
                })])
            }
        }
        .scrollDismissesKeyboard(.interactively)
    }
}

extension TodoItemsEditView {
    func handleValueChanged(value: String, index: Int) {
        if index < vm.todoItemList.items.count - 1 && value.isEmpty {
            vm.todoItemList.items.remove(at: index)
        }
    }
}

struct TodoItemsEditView_Previews: PreviewProvider {
    @State static var focusIndex: Int = 0

    static var previews: some View {
        TodoItemsEditView(focusIndex: $focusIndex, vm: .init(todoItemGroup: nil))
            .preferredColorScheme(.dark)
            .environmentObject(TodoItemListEditViewModel(todoItemGroup: dev.todoItemGroup!))
        TodoItemsEditView(focusIndex: $focusIndex, vm: .init(todoItemGroup: nil))
            .environmentObject(TodoItemListEditViewModel(todoItemGroup: dev.todoItemGroup!))
    }
}
