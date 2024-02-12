//
//  MapsContentView.swift
//  TodoMap
//
//  Created by Suguru Tokuda on 2/12/24.
//

import SwiftUI

struct MapsContentView: View {
    @ObservedObject var coordinator: MapCoordinator = MapCoordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(page: .placesSearch)
                .navigationDestination(for: MapPage.self) { page in
                    coordinator.build(page: page)
                }
        }
        .environmentObject(coordinator)
    }
}

#Preview {
    MapsContentView()
}
