//
//  CheckCircleView.swift
//  TodoMap
//
//  Created by Suguru on 8/14/23.
//

import SwiftUI

struct CheckCircleView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var selected: Bool
    var width: CGFloat = 50
    var height: CGFloat = 50
    var onSelectChange: (_ selected: Bool) -> Void
        
    var body: some View {
        ZStack {
            Circle()
                .stroke(.blue, lineWidth: 1.5)
                .frame(width: width, height: height)
            if selected {
                Image(systemName: "checkmark")
                    .resizable()
                    .bold()
                    .frame(width: (width * 0.7), height: (height * 0.6))
                    .foregroundColor(colorScheme == .light ? Color.theme.background : Color.white)
            }
        }
        .onTapGesture {
            selected.toggle()
            onSelectChange(selected)
        }
    }
}

struct CheckCircleView_Previews: PreviewProvider {
    static var previews: some View {
        CheckCircleView(selected: .constant(true), onSelectChange: { selected in })
            .preferredColorScheme(.dark)
        CheckCircleView(selected: .constant(false), onSelectChange: { selected in })
            .preferredColorScheme(.dark)
        CheckCircleView(selected: .constant(true), onSelectChange: { selected in })
        CheckCircleView(selected: .constant(false), onSelectChange: { selected in })
    }
}
