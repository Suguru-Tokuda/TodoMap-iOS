//
//  TodoListContentView.swift
//  TodoMap
//
//  Created by Suguru Tokuda on 2/11/24.
//

import SwiftUI

struct TodoListContentView: View {
    @StateObject var coordinator: TodoListCoordinator = TodoListCoordinator()
        
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(page: .todoList)
                .navigationDestination(for: TodoListPage.self) { page in
                    coordinator.build(page: page)
                }
                .sheet(item: $coordinator.sheet) { sheet in
                    coordinator.build(sheet: sheet)
                }
                .fullScreenCover(item: $coordinator.fullScreenCover) { fullScreenCover in
                    coordinator.build(fullScreenCover: fullScreenCover)
                }
        }
        .environmentObject(coordinator)
    }
}
