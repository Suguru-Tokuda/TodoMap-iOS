//
//  Color.swift
//  MapTodo
//
//  Created by Suguru on 8/5/23.
//

import Foundation
import SwiftUI

extension Color {
    static let theme = ColorTheme()
    
    struct ColorTheme {
        let background = Color("Background")
        let secondaryBackground = Color("SecondaryBackground")
        let text = Color("TextColor")
        let secondaryText = Color("SecondaryTextColor")
        let blue = Color("BlueColor")
    }
}
