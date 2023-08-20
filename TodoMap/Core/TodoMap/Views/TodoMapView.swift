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
            CustomMapView(coordinateRegion: $vm.mapRegion, showUserLocation: true)
                .onTap { coordinate in
                    print(coordinate)
                }
                .onLongPress { coordinate in
                    print(coordinate)
                }
                .ignoresSafeArea()
                .onAppear {
                    vm.checkIfLocationServicesIsEnabled()
                }
//            Map(coordinateRegion: $vm.mapRegion, interactionModes: .all, showsUserLocation: true)
//                .ignoresSafeArea()
//                .onAppear {
//                    vm.checkIfLocationServicesIsEnabled()
//                }
//                .onTapGesture(perform: <#T##(CGPoint) -> Void#>)
//                .onTapGesture { val in
//                    print(val)
//                }
        }
    }
}

extension TodoMapView {
//    func logPress() -> some Gesture {
//        LogPress
//    }
}

struct TodoMapView_Previews: PreviewProvider {
    static var previews: some View {
        TodoMapView()
    }
}
