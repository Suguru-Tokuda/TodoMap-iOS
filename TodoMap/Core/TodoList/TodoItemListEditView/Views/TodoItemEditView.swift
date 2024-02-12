//
//  TodoItemEditView.swift
//  TodoMap
//
//  Created by Suguru on 8/13/23.
//

import SwiftUI
import Combine

struct TodoItemEditView: View {
    @Binding var todoItem: TodoItemModel
    @FocusState var focusField: Int?
    var index: Int
    @Binding var focusIndex: Int
    let onChange: ((String) -> Void)
    
    var body: some View {
        HStack {
            CheckCircleView(selected: $todoItem.completed, width: 25, height: 25) { selected in }
            VStack(spacing: 2) {
                TextField("Item", text: $todoItem.name)
                    .font(.title3)
                    .focused($focusField, equals: index)
                    .onReceive(Just(focusIndex)) { val in
                        focusField = val != -1 && val == index ? val : nil
                    }
                    .onChange(of: todoItem.name) { newValue in
                        onChange(newValue)
                    }
                    .onTapGesture {
                        focusIndex = index
                        focusField = index
                    }
                TextField("Note", text: $todoItem.note)
                    .font(.callout)
                    .foregroundColor(Color.theme.secondaryText)
                    .onTapGesture {
                        focusIndex = -1
                        focusField = nil
                    }
            }
        }
        .frame(height: 50)
        .padding(.horizontal, 5)
        .padding(.vertical, 10)
        .background(Color.theme.background)
    }
}

struct TodoItemEditView_Previews: PreviewProvider {
    @State static var todoItem = dev.todoItems.first!
    @State static var focusIndex: Int = -1
    static var previews: some View {
        TodoItemEditView(todoItem: $todoItem, index: 0, focusIndex: $focusIndex, onChange: { _ in })
            .preferredColorScheme(.dark)
        TodoItemEditView(todoItem: $todoItem, index: 0, focusIndex: $focusIndex, onChange: { _ in })
    }
}
