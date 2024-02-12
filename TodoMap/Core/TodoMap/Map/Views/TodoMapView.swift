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
                .sheet(isPresented: $vm.locationSelectionSheeetPresented) {
                    if let location = vm.location {
                        PlaceSelectionView(location: location) { (location, locationName) in
                            print(location)
                            print(locationName)
                        }
                    }
                }
                .onAppear {
                    vm.setLocationManager(locationManager: locationManager)
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
