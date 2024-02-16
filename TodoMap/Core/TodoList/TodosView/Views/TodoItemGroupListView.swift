//
//  TodoListView.swift
//  TodoMap
//
//  Created by Suguru on 8/8/23.
//

import SwiftUI
import Combine
import CoreData

struct TodoItemGroupListView: View {
    @StateObject var vm: TodosViewModel = TodosViewModel()
    @EnvironmentObject var coordinator: TodoListCoordinator
        
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            VStack {
                header()
                    .padding(10)
                itemList()
            }
        }
        .task {
            await vm.getAllLists()
        }
        .alert(isPresented: $vm.errorOccured, error: vm.coreDataError) {
            Button(action: {
                vm.supressError()
            }, label: {
                Text("OK")
            })
        }
    }
}

extension TodoItemGroupListView {
    @ViewBuilder
    private func header() -> some View {
        ZStack {
            HStack {
                Spacer()
                Button {
                    coordinator.push(.todoListEditor)
                } label: {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 20, height: 20, alignment: .trailing)
                        .foregroundColor(Color.theme.secondaryText)
                }
            }
            Text("Todo List")
                .font(.headline)
                .fontWeight(.semibold)
        }
    }
    
    @ViewBuilder
    private func itemList() -> some View {
        List {
            ForEach(Array(zip(vm.todoItemGroups.indices, vm.todoItemGroups)), id: \.0) { index, list in
                TodoListCellView(todoItemGroup: list, itemCount: list.items.count)
                    .onTapGesture {
                        coordinator.push(.todoListEditor, todoListGroup: list)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            Task(priority: .userInitiated) {
                                await vm.deleteList(list, index)
                            }                            
                        } label: {
                            Image(systemName: "trash.fill")
                        }
                    }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoItemGroupListView()
            .preferredColorScheme(.dark)
        TodoItemGroupListView()
    }
}
