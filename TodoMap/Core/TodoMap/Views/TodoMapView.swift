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
                        do {
                            try await vm.getLocationDetails(coordinate: coordinate)
                            let annotation = MKPointAnnotation()
                            annotation.coordinate = coordinate
                            
                            if let location = vm.location,
                               location.results.count > 0
                            {
                                let result = location.results[0]
                                annotation.title = result.formattedAddress
                                annotation.accessibilityValue = result.placeId
                            }
                            
                            LocationService.shared.center = MKCoordinateRegion(center: coordinate, span: MapDetails.defaultSpan)
                            vm.addAnnotation(annotation: annotation, reset: true)
                        } catch {
                            // TODO: show an error alert
                        }
                    }
                }
                .ignoresSafeArea()
                .onAppear {
                    vm.checkIfLocationServicesIsEnabled()
                }
                .sheet(isPresented: $vm.locationSelectionSheeetPresented) {
                    if let location = vm.location {
                        PlaceSelectionView(location: location) { (location, locationName) in
                            print(location)
                            print(locationName)
                        }
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
