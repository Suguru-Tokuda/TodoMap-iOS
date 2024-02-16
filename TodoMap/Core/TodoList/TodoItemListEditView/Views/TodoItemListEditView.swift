//
//  TodoItemGroupView.swift
//  TodoMap
//
//  Created by Suguru on 8/8/23.
//

import SwiftUI

struct TodoItemListEditView: View, KeyboardReadable {
    @EnvironmentObject var coordinator: TodoListCoordinator
    @StateObject var vm: TodoItemListEditViewModel
    @State var keyboardVisible: Bool = false
    
    init(todoItemGroup: TodoItemListModel?) {
        _vm = StateObject(wrappedValue: TodoItemListEditViewModel(todoItemGroup: todoItemGroup))
    }
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            VStack {
                header()
                ZStack {
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            TodoItemNameLocationEditView(vm: vm)
                                .onTapGesture {}
                            TodoItemsEditView(
                                focusIndex: $vm.focusIndex,
                                vm: vm
                            )
                        }
                    }
                }
                .onTapGesture {
                    vm.handleScrollViewTapped(keyboardVisible)
                }
                Spacer()
                if ((vm.todoItemList.items.isEmpty || !vm.isLastItemEmpty()) && !keyboardVisible) {
                    footer()
                }
            }
                .padding(10)
        }
        .onAppear {
            coordinator.onLocationSelect = { location in
                vm.setLocation(location)
                coordinator.dismissSheet()
                coordinator.dismissFullScreenCover()
            }
        }
        .onReceive(keyboardPublisher, perform: { newIsKeyboardVisible in
            if !newIsKeyboardVisible {
                vm.handleScrollViewTapped(keyboardVisible)
            }
            keyboardVisible = newIsKeyboardVisible
        })
        .navigationBarBackButtonHidden()
    }
}

extension TodoItemListEditView {
    @ViewBuilder
    private func header() -> some View {
        HStack {
            Button(action: {
                Task {
                    await vm.saveDeleteItems()
                    coordinator.pop()
                }
            }, label: {
                Image(systemName: "chevron.left")
                Text("Back")
            })
            Spacer()
        }
    }
    
    @ViewBuilder
    private func footer() -> some View {
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
        TodoItemListEditView(todoItemGroup: .init())
            .preferredColorScheme(.dark)
        TodoItemListEditView(todoItemGroup: .init())
    }
}
