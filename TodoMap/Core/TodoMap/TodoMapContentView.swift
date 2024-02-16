//
//  MapsContentView.swift
//  TodoMap
//
//  Created by Suguru Tokuda on 2/12/24.
//

import SwiftUI

struct TodoMapContentView: View {
    @StateObject var coordinator: TodoMapCoordinator = TodoMapCoordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(page: .placesSearch)
                .navigationDestination(for: TodoMapPage.self) { page in
                    coordinator.build(page: page)
                }
        }
        .environmentObject(coordinator)
    }
}

#Preview {
    TodoMapContentView()
}
