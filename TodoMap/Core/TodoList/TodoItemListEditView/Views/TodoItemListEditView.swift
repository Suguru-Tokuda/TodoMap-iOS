//
//  TodoItemGroupView.swift
//  TodoMap
//
//  Created by Suguru on 8/8/23.
//

import SwiftUI

struct TodoItemListEditView: View, KeyboardReadable {
    @StateObject var vm: TodoItemListEditViewModel
    @State var keyboardVisible: Bool = false
    
    init(todoItemGroup: TodoItemListModel) {
        _vm = StateObject(wrappedValue: TodoItemListEditViewModel(todoItemGroup: todoItemGroup))
    }
    
    var body: some View {
        ZStack {
            Color.theme.background
            VStack {
                TodoItemNameLocationEditView(
                    name: $vm.todoItemGroup.name,
                    location: $vm.todoItemGroup.location
                )
                TodoItemsEditView(
                    todoItems: $vm.todoItemGroup.items,
                    focusIndex: $vm.focusIndex
                )
                    .onTapGesture {
                        vm.handleScrollViewTapped(keyboardVisible)
                    }
                Spacer()
                if !vm.isLastItemEmpty() && !keyboardVisible {
                    footer                        
                }
            }
            .padding(10)
        }
        .onReceive(keyboardPublisher, perform: { newIsKeyboardVisible in
            if !newIsKeyboardVisible {
                vm.handleScrollViewTapped(keyboardVisible)
            }
            keyboardVisible = newIsKeyboardVisible
        })        
    }
}

extension TodoItemListEditView {
    private var footer: some View {
        HStack {
            Button {
                vm.addTodoItem()
            } label: {
                HStack {
                    ZStack {
                        Circle()
                            .fill(.blue)
                            .frame(width: 20, height: 20)
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .frame(width: 20, height: 20)
                    }
                    Text("New Item")
                        .font(.subheadline)
                        .foregroundColor(Color.theme.text)
                    Spacer()
                }
            }
        }
    }
}

struct TodoItemGroupEditView_Previews: PreviewProvider {
    static var previews: some View {
        TodoItemListEditView(todoItemGroup: dev.todoItemGroup!)
            .preferredColorScheme(.dark)
        TodoItemListEditView(todoItemGroup: dev.todoItemGroup!)
    }
}
