//
//  UIApplication.swift
//  TodoMap
//
//  Created by Suguru on 8/18/23.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
