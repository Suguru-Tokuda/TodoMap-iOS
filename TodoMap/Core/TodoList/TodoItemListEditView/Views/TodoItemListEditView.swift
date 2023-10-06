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
                .ignoresSafeArea()

            VStack {
                ZStack {
                    List {
                        TodoItemNameLocationEditView(
                            name: $vm.todoItemList.name,
                            location: $vm.todoItemList.location
                        )
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.theme.background)
                        TodoItemsEditView(
                            todoItems: $vm.todoItemList.items,
                            focusIndex: $vm.focusIndex
                        )
                        .overlay(Group {
                            if vm.todoItemList.items.isEmpty {
                                Color.theme.background.ignoresSafeArea()
                            }
                        })
                        .environmentObject(vm)
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(PlainListStyle())
                    Rectangle()
                        .fill(Color.theme.background)
                        .opacity(0.00001)
                        .padding(.trailing, 0)
                        .padding(.top, CGFloat(vm.todoItemList.items.count) * CGFloat(50) + CGFloat(100))
                        .onTapGesture {
                            vm.handleScrollViewTapped(keyboardVisible)
                        }
                }
                Spacer()
                if ((vm.todoItemList.items.isEmpty || !vm.isLastItemEmpty()) && !keyboardVisible) {
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
//        .onAppear {
//            Task {
//                let list = TodoItemService.shared.getTodoLists()
//                list.forEach { el in
//                    if let items = el.todoItemEntity {
//                        let arr = items as! Set<TodoItemEntity>
//                        
//                        arr.forEach { item in
//                            if let name = item.name {
//                                print(name)
//                            }
//                        }
//                    }
//                }
//                print(list.count)
//            }
//        }
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
