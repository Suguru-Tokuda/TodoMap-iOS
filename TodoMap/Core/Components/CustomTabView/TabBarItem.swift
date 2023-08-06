//
//  TabBarItem.swift
//  MapTodo
//
//  Created by Suguru on 8/5/23.
//

import Foundation
import SwiftUI

enum TabBarItem: Hashable {
    case todo, map
    
    var iconName: String {
        switch self {
        case .todo: return "list.clipboard"
        case .map: return "map"
        }
    }
    
    var title: String {
        switch self {
        case .todo: return String.constants.todo
        case .map: return String.constants.map
        }
    }
}
