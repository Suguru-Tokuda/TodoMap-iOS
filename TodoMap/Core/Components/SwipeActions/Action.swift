//
//  Action.swift
//  TodoMap
//
//  Created by Suguru Tokuda on 2/15/24.
//

import SwiftUI

struct Action {
    let color: Color
    let name: String
    let systemIcon: String
    let action: () -> Void
}
