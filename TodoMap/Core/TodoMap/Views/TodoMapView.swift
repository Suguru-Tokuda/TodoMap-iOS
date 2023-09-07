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
            CustomMapView(coordinateRegion: $vm.mapRegion, annotations: $vm.annotations, showUserLocation: true)
                .onTapGesture { coordinate in
                }
                .onLongPressGesture { coordinate in
                }
                .ignoresSafeArea()
                .onAppear {
                    vm.checkIfLocationServicesIsEnabled()
                }
        }
    }
}

struct TodoMapView_Previews: PreviewProvider {
    static var previews: some View {
        TodoMapView()
    }
}
