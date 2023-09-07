//
//  TodoListView.swift
//  TodoMap
//
//  Created by Suguru on 8/8/23.
//

import SwiftUI

struct TodoItemGroupListView: View {
    @StateObject var vm: TodosViewModel
    @State private var path: [TodoItemListModel] = []
    
    init(todoItemGroups: [TodoItemListModel] = []) {
        _vm = StateObject(wrappedValue: TodosViewModel(todoItemGroups: todoItemGroups))
    }

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color.theme.background
                    .ignoresSafeArea()
                VStack {
                    header.padding(10)
                    itemList
                }
            }
        }
    }
}

extension TodoItemGroupListView {
    private var header: some View {
        ZStack {
            HStack {
                Spacer()
                Button {
                    
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
                            path.append(item)
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
        TodoItemGroupListView(todoItemGroups: dev.todoItemGroups)
            .preferredColorScheme(.dark)
        TodoItemGroupListView(todoItemGroups: dev.todoItemGroups)
    }
}
