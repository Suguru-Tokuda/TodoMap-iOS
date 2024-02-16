//
//  PlaceSelectionView.swift
//  TodoMap
//
//  Created by Suguru on 9/11/23.
//

import SwiftUI
import MapKit

struct PlaceSelectionView: View {
    var location: ReverseGeocodeModel?
    var onLocationSelect: ((LocationModel) -> ())?
    @State var locationName: String = ""
    
    var body: some View {
        ZStack {
            Color.theme.background
                .background(ignoresSafeAreaEdges: .bottom)
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    if let location = location,
                       location.results.count > 0 {
                        getLocationLabel(location: location)
                    }
                    customLocationNameField
                }
                .padding(.top, 20)
                Spacer()
                selectBtn
                .padding(.bottom, 20)
            }
            .padding(.horizontal, 10)
        }
        .presentationDetents([.height(250)])
        .presentationDragIndicator(.visible)
    }
}

extension PlaceSelectionView {
    private func getLocationLabel(location: ReverseGeocodeModel) -> some View {
        Text(location.results[0].formattedAddress)
            .foregroundColor(Color.theme.text)
            .font(.title2)
            .fontWeight(.bold)
    }
    
    private var customLocationNameField: some View {
        TextField("Custom Location Name (Optional)", text: $locationName)
            .font(.title3)
    }
    
    private var selectBtn: some View {
        Button {
            if let location,
               let result = location.results.first,
               let geoLocation = result.geometry.location {
                let locationModel = LocationModel(name: locationName.isEmpty ? result.formattedAddress : locationName,
                                                  coordinates: CLLocationCoordinate2D(latitude: geoLocation.lat,
                                                                                      longitude: geoLocation.lng))
                onLocationSelect?(locationModel)
            }
        } label: {
            Text("Select")
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity)
                .frame(height: 25)
                .fontWeight(.bold)
                .background(Color.theme.blue)
                .cornerRadius(10.0)
                .overlay(
                    RoundedRectangle(cornerRadius: 10.0)
                        .stroke(lineWidth: 2.0)
                )
        }
    }
}

struct PlaceSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceSelectionView()
            .frame(maxHeight: 250)
            .preferredColorScheme(.dark)
        PlaceSelectionView()
            .frame(maxHeight: 250)
    }
}
