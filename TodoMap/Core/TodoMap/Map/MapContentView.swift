//
//  MapContentView.swift
//  TodoMap
//
//  Created by Suguru Tokuda on 2/16/24.
//

import SwiftUI

struct MapContentView: View {
    @StateObject var coordinator: MapCoordinator = MapCoordinator()
    var onLocationSelect: ((LocationModel) -> ())?
    
    var body: some View {
        TodoMapView()
            .sheet(item: $coordinator.sheet) { sheet in
                coordinator.build(sheet: sheet)
            }
            .environmentObject(coordinator)
            .onAppear {
                coordinator.onLocationSelect = self.onLocationSelect
            }
    }
}
