//
//  TodoListView.swift
//  TodoMap
//
//  Created by Suguru on 8/8/23.
//

import SwiftUI
import Combine

struct TodoItemGroupListView: View {
    @StateObject var vm: TodosViewModel
    @EnvironmentObject var coordinator: TodoListCoordinator
    
    init(todoItemGroups: [TodoItemListModel]) {
        _vm = StateObject(wrappedValue: TodosViewModel(todoItemGroups: todoItemGroups))
    }
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            VStack {
                header()
                    .padding(10)
                itemList
            }
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
    
    private var itemList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(vm.todoItemGroups, id: \.self) { item in
                    TodoRowView(todoItemGroup: item)
                        .onTapGesture {
                            coordinator.push(.todoListEditor)
//                            path.append(item)
                        }
                }
            }
        }
        .navigationDestination(for: TodoItemListModel.self, destination: { item in
            Text(item.name)
        })
        .scrollContentBackground(.hidden)
        .listStyle(PlainListStyle())
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoItemGroupListView(todoItemGroups: [])
            .preferredColorScheme(.dark)
        TodoItemGroupListView(todoItemGroups: [])
    }
}
