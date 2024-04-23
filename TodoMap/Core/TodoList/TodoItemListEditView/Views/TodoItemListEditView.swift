//
//  TodoItemGroupView.swift
//  TodoMap
//
//  Created by Suguru on 8/8/23.
//

import SwiftUI
import Combine

struct TodoItemListEditView: View, KeyboardReadable {
    @EnvironmentObject var coordinator: TodoListCoordinator
    @EnvironmentObject var todoMapCoordinator: TodoMapCoordinator
    @StateObject var vm: TodoItemListEditViewModel
    @State var keyboardVisible: Bool = false
    var saveOnChange: Bool = false
    var coordinatorType: CoordinatorType
    var cancellables = Set<AnyCancellable>()
    
    init(todoItemGroup: TodoItemListModel?, coordinatorType: CoordinatorType = .todoList, saveOnChange: Bool = true) {
        self.coordinatorType = coordinatorType
        self.saveOnChange = saveOnChange
        _vm = StateObject(wrappedValue: TodoItemListEditViewModel(todoItemGroup: todoItemGroup, saveOnChange: saveOnChange))
    }
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            VStack {
                switch coordinatorType {
                case .todoMap:
                    headerForTodoMap()
                case .todoList:
                    backButtonHeader()
                default:
                    backButtonHeader()
                }

                ZStack {
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            TodoItemNameLocationEditView(vm: vm, coordinatorType: coordinatorType)
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
            if saveOnChange {
                coordinator.onLocationSelect = { location in
                    vm.setLocation(location)
                    coordinator.dismissSheet()
                    coordinator.dismissFullScreenCover()
                }
            }
            
            self.addSubscriptions()
            
            vm.onLocationSelect = { location in
                coordinator.dismissFullScreenCover()
            }
        }
        .onDisappear {
            removeSubscriptions()
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
    private func addSubscriptions() {
        if coordinatorType == .todoList {
            vm.addLocationSubscription(subject: &coordinator.locationSubject)
        }
    }
    
    private func removeSubscriptions() {
        cancellables.forEach { $0.cancel() }
    }
}

extension TodoItemListEditView {
    @ViewBuilder
    private func backButtonHeader() -> some View {
        HStack {
            Button(action: {
                Task {
                    await vm.saveDeleteItems()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        coordinator.pop()
                    }
                }
            }, label: {
                Image(systemName: "chevron.left")
                Text("Back")
            })
            Spacer()
        }
    }
    
    @ViewBuilder
    private func headerForTodoMap() -> some View {
        HStack {
            Button(action: {
                todoMapCoordinator.dismissFullCover()
            }, label: {
                Image(systemName: "xmark")
            })
            Spacer()
            Button(action: {
                Task {
                    await vm.saveList()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        todoMapCoordinator.dismissFullCover()
                    }
                }
            }, label: {
                Text("Save")
            })
            .disabled(vm.todoItemList.name.isEmpty)
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
