//
//  PlacesSearchBarView.swift
//  TodoMap
//
//  Created by Suguru on 8/21/23.
//

import SwiftUI

struct PlacesSearchBarView: View {
    @Binding var text: String
    @Binding var isLoading: Bool
    @State private var isEditing = false
    var handleCancelBtnTapped: (() -> ())?
    
    var body: some View {
        HStack {
            HStack {
                if !isLoading {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color.gray)
                } else {
                    ProgressView()
                }
                TextField("Search...", text: $text)
                    .padding(7)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.6)) {
                            self.isEditing = true
                        }
                    }
            }
            .padding(.horizontal, 10)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            
            if isEditing {
                Button {
                    self.isEditing = false
                    self.text = ""
                    UIApplication.shared.endEditing()
                    handleCancelBtnTapped?()
                } label: {
                    Text("Cancel")
                        .font(.callout)
                }
                .padding(.trailing, 5)
                .opacity(isEditing ? 1 : 0)
            }
        }
    }
}

struct PlacesSearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        @State var text: String = ""
        @State var isLoading: Bool = true

        PlacesSearchBarView(text: $text, isLoading: $isLoading)
            .preferredColorScheme(.dark)
        PlacesSearchBarView(text: $text, isLoading: $isLoading)
    }
}
