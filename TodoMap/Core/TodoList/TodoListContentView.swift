//
//  TodoListContentView.swift
//  TodoMap
//
//  Created by Suguru Tokuda on 2/11/24.
//

import SwiftUI

struct TodoListContentView: View {
    @ObservedObject var coordinator: TodoListCoordinator
    
    init() {
        _coordinator = ObservedObject(wrappedValue: TodoListCoordinator())
    }
    
    var body: some View {
        coordinator.getPage(page: .todoList)
            .navigationDestination(for: TodoListPage.self) { page in
                coordinator.getPage(page: page)
            }
        .environmentObject(coordinator)
    }
}

#Preview {
    TodoListContentView()
}
