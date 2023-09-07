//
//  PlacesSearchListRowView.swift
//  TodoMap
//
//  Created by Suguru on 8/21/23.
//

import SwiftUI

struct AutoCompleteListRowView: View {
    var prediction: Prediction
    
    var body: some View {
        ZStack(alignment: .leading) {
            Color.theme.background
            VStack(alignment: .leading) {
                if let structuredFormatting = prediction.structuredFormatting,
                   let mainText = structuredFormatting.mainText,
                   let secondaryText = structuredFormatting.secondaryText {
                    Text(mainText)
                        .font(.headline)
                        .foregroundColor(Color.theme.text)
                    Text(secondaryText)
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

struct PlacesSearchListRowView_Previews: PreviewProvider {
    static var previews: some View {
        AutoCompleteListRowView(prediction: dev.placePredictions.first!)
            .preferredColorScheme(.dark)
        AutoCompleteListRowView(prediction: dev.placePredictions.first!)
    }
}
