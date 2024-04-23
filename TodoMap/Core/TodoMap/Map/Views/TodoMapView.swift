//
//  TodoMapView.swift
//  TodoMap
//
//  Created by Suguru Tokuda on 8/19/23.
//

import SwiftUI
import MapKit

struct TodoMapView: View {
    @StateObject private var vm: TodoMapViewModel = TodoMapViewModel()
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var mapCoordinator: MapCoordinator
    @EnvironmentObject var mainCoordinator: MainCoordinator

    var body: some View {
        ZStack {
            CustomMapView(
                coordinateRegion: $vm.mapRegion,
                annotations: $vm.annotations,
                showUserLocation: true
            )
                .onTapGesture { coordinate in
                }
                .onLongPressGesture { coordinate in
                    Task {
                        await vm.getLocationDetails(coordinate: coordinate)
                        vm.handleNewCoordinate(coordinate: coordinate)
                    }
                }
                .ignoresSafeArea()
                .onAppear {
                    vm.setLocationManager(locationManager: locationManager)
                    vm.showSelectionSheet = { location in
                        mapCoordinator.showPlaceSelectionSheet(location: location)
                    }
                }
                .onChange(of: mainCoordinator.tabSelection) { newValue in
                    if newValue == .map {
                        vm.focusOnCenter()
                    }                    
                }
        }
    }
}

struct TodoMapView_Previews: PreviewProvider {
    static var previews: some View {
        TodoMapView()
            .preferredColorScheme(.dark)
        TodoMapView()
    }
}
