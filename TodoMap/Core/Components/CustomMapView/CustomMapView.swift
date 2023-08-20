//
//  CustomMapView.swift
//  TodoMap
//
//  Created by Suguru Tokuda on 8/19/23.
//

import SwiftUI
import MapKit

struct CustomMapView: UIViewRepresentable, View {
    @Binding var coordinateRegion: MKCoordinateRegion
    @State var customMapView: MKMapView?
    var onTap: ((_ coordinate: CLLocationCoordinate2D) -> Void)?
    var onLongPress: ((_ coordinate: CLLocationCoordinate2D) -> Void)?
    var showUserLocation: Bool
    
    func makeUIView(context: UIViewRepresentableContext<CustomMapView>) -> MKMapView {
        var mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator
        addGestures(context: context, mapView: &mapView)
        
        DispatchQueue.main.async {
            customMapView = mapView
        }
        
        return mapView
    }
    
    private func addGestures(context: UIViewRepresentableContext<CustomMapView>, mapView: inout MKMapView) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.getCoordinateTapGesture(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.numberOfTouchesRequired = 1
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.getCoordinateLongPressGesture(_:)))
        longPressGestureRecognizer.minimumPressDuration = 0.5
        
        mapView.addGestureRecognizer(tapGestureRecognizer)
        mapView.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    func makeCoordinator() -> CustomMapView.Coordinator {
        return Coordinator(self, coordinateRegion: $coordinateRegion, showUserLocation: showUserLocation)
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.region = coordinateRegion
        uiView.showsUserLocation = showUserLocation
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        @Binding var coordinateRegion: MKCoordinateRegion
        var showUserLocation: Bool
        var control: CustomMapView
        
        init(_ control: CustomMapView, coordinateRegion: Binding<MKCoordinateRegion>, showUserLocation: Bool) {
            self.control = control
            _coordinateRegion = coordinateRegion
            self.showUserLocation = showUserLocation
        }
        
        private func getCoordinate(point: CGPoint) -> CLLocationCoordinate2D? {
            return control.customMapView?.convert(point, toCoordinateFrom: control.customMapView)
        }
        
        @objc func getCoordinateTapGesture(_ sender: UITapGestureRecognizer) {
            print("tapped")
            if sender.state == .ended {
                let point = sender.location(in: control.customMapView)
                let coordinate = getCoordinate(point: point)
                
                if let coordinate = coordinate {
                    print(coordinate)
                }
            }
        }
        
        @objc func getCoordinateLongPressGesture(_ sender: UILongPressGestureRecognizer) {
            if sender.state == .began {
                let point = sender.location(in: control.customMapView)
                let coordinate = getCoordinate(point: point)
                
                if let coordinate = coordinate {
                    control.onLongPress?(coordinate)
                }
            }
        }
    }
}

extension CustomMapView {
    func onTap(perform action: ((_ coordinate: CLLocationCoordinate2D) -> Void)? = nil) -> CustomMapView {
        var new = self
        new.onTap = action
        return new
    }
    
    func onLongPress(perform action: ((_ coordinate: CLLocationCoordinate2D) -> Void)? = nil) -> CustomMapView {
        var new = self
        new.onLongPress = action
        return new
    }
}
