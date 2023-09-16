//
//  TodoItemNameLocationEditView.swift
//  TodoMap
//
//  Created by Suguru on 8/9/23.
//

import SwiftUI

struct TodoItemNameLocationEditView: View {
    @Binding var name: String
    @Binding var location: String
    @State private var showLocationSearchSheet = false
    
    var body: some View {
        ZStack {
            Color.theme.background
            VStack {
                TextField("Name", text: $name)
                    .font(.system(size: 33))
                    .fontWeight(.bold)
                HStack {
                    TextField("Location", text: $location)
                        .font(.system(size: 25))
                        .fontWeight(.semibold)
                        .foregroundColor(Color.theme.secondaryText)
                    mapBtn
                        .sheet(isPresented: $showLocationSearchSheet) {
                            LocationSearchSheetView()
                        }
                }
            }
        }
        .frame(height: 100)
    }
}

extension TodoItemNameLocationEditView {
    var mapBtn: some View {
        Button {
            showLocationSearchSheet = true
        } label: {
            ZStack {
                Circle()
                    .fill(Color.theme.secondaryBackground)
                    .frame(width: 20, height: 20)
                Image(systemName: "map")
                    .foregroundColor(Color.theme.secondaryText)
                    .frame(width: 20, height: 20)
            }
        }
    }
}

struct TodoItemNameLocationEditView_Previews: PreviewProvider {
    @State static var name: String = ""
    @State static var location: String = ""
    @State static var focusIndex: Int = 0
    
    static var previews: some View {
        TodoItemNameLocationEditView(name: $name, location: $location)
            .preferredColorScheme(.dark)
        TodoItemNameLocationEditView(name: $name, location: $location)
    }
}
