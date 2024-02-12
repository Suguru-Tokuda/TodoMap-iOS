//
//  TodoItemsEditView.swift
//  TodoMap
//
//  Created by Suguru on 8/13/23.
//

import SwiftUI

struct TodoItemsEditView: View{
    @Binding var todoItems: [TodoItemModel]
    @Binding var focusIndex: Int
    @EnvironmentObject var vm: TodoItemListEditViewModel
    
    var body: some View {
        ForEach(0..<todoItems.count, id: \.self) { i in
            if i < todoItems.count {
                TodoItemEditView(
                    todoItem: $todoItems[i],
                    index: i,
                    focusIndex: $focusIndex
                ) { val in
                    handleValueChanged(value: val, index: i)
                }
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.theme.background)
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        Task {
                            let id = todoItems[i].id
                            await vm.deleteTodoItem(id: id)
                        }
                    } label: {
                        Text("Delete")
                    }
                }
            }
        }
        .scrollDismissesKeyboard(.interactively)
    }
}

extension TodoItemsEditView {
    func handleValueChanged(value: String, index: Int) {
        if index < todoItems.count - 1 && value.isEmpty {
            todoItems.remove(at: index)
        }
    }
}

struct TodoItemsEditView_Previews: PreviewProvider {
    @State static var todoItems = dev.todoItems
    @State static var focusIndex: Int = 0

    static var previews: some View {
        TodoItemsEditView(todoItems: $todoItems, focusIndex: $focusIndex)
            .preferredColorScheme(.dark)
            .environmentObject(TodoItemListEditViewModel(todoItemGroup: dev.todoItemGroup!))
        TodoItemsEditView(todoItems: $todoItems, focusIndex: $focusIndex)
            .environmentObject(TodoItemListEditViewModel(todoItemGroup: dev.todoItemGroup!))

    }
}
