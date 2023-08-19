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
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(0..<todoItems.count, id: \.self) { i in
                    if i < todoItems.count {
                        TodoItemEditView(
                            todoItem: $todoItems[i],
                            index: i,
                            focusIndex: $focusIndex
                        ) { val in
                            handleValueChanged(value: val, index: i)
                        }
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
        TodoItemsEditView(todoItems: $todoItems, focusIndex: $focusIndex)
    }
}
