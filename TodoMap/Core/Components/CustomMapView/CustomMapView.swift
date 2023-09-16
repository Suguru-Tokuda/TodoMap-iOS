//
//  CustomMapView.swift
//  TodoMap
//
//  Created by Suguru Tokuda on 8/19/23.
//

import SwiftUI
import MapKit

struct CustomMapView: UIViewRepresentable, View {
    @Binding var coordinateRegion: MKCoordinateRegion?
    @Binding var annotations: [MKPointAnnotation]
    @State var customMapView: MKMapView? = nil
    private var onTap: ((_ coordinate: CLLocationCoordinate2D) -> Void)? = nil
    private var onLongPress: ((_ coordinate: CLLocationCoordinate2D) -> Void)? = nil
    private var onAnnotationTap: ((_ annotation: MKPointAnnotation) -> Void)? = nil
    var showUserLocation: Bool
    @State var animateOnCenter: Bool = false
    
    init(coordinateRegion: Binding<MKCoordinateRegion?>, annotations: Binding<[MKPointAnnotation]>, showUserLocation: Bool) {
        self._coordinateRegion = coordinateRegion
        self._annotations = annotations
        self.showUserLocation = showUserLocation
    }
    
    func makeUIView(context: UIViewRepresentableContext<CustomMapView>) -> MKMapView {
        var mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator
        mapView.addAnnotations(annotations)
        if let region = coordinateRegion {
            mapView.setRegion(region, animated: false)
        }
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
        return Coordinator(self, coordinateRegion: $coordinateRegion, annotations: $annotations, showUserLocation: showUserLocation)
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if let region = coordinateRegion {
            uiView.setRegion(region, animated: animateOnCenter)
        }
        
        if annotations.isEmpty {
            uiView.removeAnnotations(uiView.annotations)
        } else {
            uiView.addAnnotations(annotations)
        }
        
        uiView.showsUserLocation = showUserLocation
    }
        
    class Coordinator: NSObject, MKMapViewDelegate {
        @Binding var coordinateRegion: MKCoordinateRegion?
        @Binding var annotations: [MKPointAnnotation]
        var showUserLocation: Bool
        var control: CustomMapView
        
        init(_ control: CustomMapView, coordinateRegion: Binding<MKCoordinateRegion?>, annotations: Binding<[MKPointAnnotation]>, showUserLocation: Bool) {
            self.control = control
            _coordinateRegion = coordinateRegion
            _annotations = annotations
            self.showUserLocation = showUserLocation
        }
        
        private func getCoordinate(point: CGPoint) -> CLLocationCoordinate2D? {
            return control.customMapView?.convert(point, toCoordinateFrom: control.customMapView)
        }

        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            control.animateOnCenter = true
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if let annotation = view.annotation {
                mapView.setCenter(annotation.coordinate, animated: true)
            }
        }
        
        @objc func getCoordinateTapGesture(_ sender: UITapGestureRecognizer) {
            if sender.state == .ended {
                let point = sender.location(in: control.customMapView)
                let coordinate = getCoordinate(point: point)
                
                if let coordinate = coordinate {
                    control.onTap!(coordinate)
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
    ///
    /// Custom event handler for tap gesture to return a coordinate on the map.
    ///
    func onTapGesture(perform action: ((_ coordinate: CLLocationCoordinate2D) -> Void)? = nil) -> CustomMapView {
        var new = self
        new.onTap = action
        return new
    }
    
    /// Custom event handler for long press gesture to return a coordinate on the map.
    func onLongPressGesture(perform action: ((_ coordinate: CLLocationCoordinate2D) -> Void)? = nil) -> CustomMapView {
        var new = self
        new.onLongPress = action
        return new
    }
}
