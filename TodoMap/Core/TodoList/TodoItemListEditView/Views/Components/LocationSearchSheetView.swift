//
//  LocationSearchSheetView.swift
//  TodoMap
//
//  Created by Suguru on 9/8/23.
//

import SwiftUI

struct LocationSearchSheetView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            PlacesSearchView {
                dismiss()
            }
        }
    }
}

struct LocationSearchSheetView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchSheetView()
            .preferredColorScheme(.dark)
        LocationSearchSheetView()
    }
}
