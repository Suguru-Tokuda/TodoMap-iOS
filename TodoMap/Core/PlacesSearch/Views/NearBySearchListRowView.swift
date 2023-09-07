//
//  NearBySearchListRowView.swift
//  TodoMap
//
//  Created by Suguru on 9/2/23.
//

import SwiftUI
import MapKit

struct NearBySearchListRowView: View {
    var result: NearbySearchResult
    @Binding var region: MKCoordinateRegion
    var distanceUnit: DistanceUnit = .mile
    
    var body: some View {
        ZStack(alignment: .leading) {
            Color.theme.background
            VStack(alignment: .leading) {
                if let name = result.name,
                   let geometry = result.geometry,
                   let location = geometry.location,
                   let vicinity = result.vicinity
                {
                    Text(name)
                        .font(.headline)
                        .foregroundColor(Color.theme.text)
                    Text("\(distanceUnit.distance(meters: region.getDistance(latitude: location.lat, longitude: location.lng))) \u{2022} \(vicinity)")
                        .font(.callout)
                        .foregroundColor(Color.theme.secondaryText)
                }
            }
            .padding(.horizontal, 5)
        }
        .border(width: 0.5, edges: [.bottom], color: Color.theme.secondaryText)
        .frame(height: 70)
    }
}

struct NearBySearchListRowView_Previews: PreviewProvider {
    static var previews: some View {
        @State var region: MKCoordinateRegion = MKCoordinateRegion(center: MapDetails.startingLocation, span: MapDetails.defaultSpan)
        
        NearBySearchListRowView(result: dev.nearbySearchResults[0], region: $region)
            .preferredColorScheme(.dark)
        NearBySearchListRowView(result: dev.nearbySearchResults[0], region: $region)
    }
}
