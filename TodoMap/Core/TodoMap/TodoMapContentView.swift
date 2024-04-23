//
//  MapsContentView.swift
//  TodoMap
//
//  Created by Suguru Tokuda on 2/12/24.
//

import SwiftUI

struct TodoMapContentView: View {
    @StateObject var coordinator: TodoMapCoordinator = TodoMapCoordinator()
    @EnvironmentObject var mainCoordinator: MainCoordinator
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(page: .placesSearch)
                .navigationDestination(for: TodoMapPage.self) { page in
                    coordinator.build(page: page)
                }
                .fullScreenCover(item: $coordinator.fullCoverSheet) { fullScreenCover in
                    coordinator.build(fullCoverSheet: fullScreenCover)
                }
        }
        .onAppear {
//            coordinator.onLocationSelect = { location in
//                mainCoordinator.selectLocation(location: location)                
//            }
        }
        .environmentObject(coordinator)
    }
}

#Preview {
    TodoMapContentView()
}
