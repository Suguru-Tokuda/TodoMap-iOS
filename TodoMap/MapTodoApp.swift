//
//  MapTodoApp.swift
//  MapTodo
//
//  Created by Suguru on 8/5/23.
//

import SwiftUI

@main
struct MapTodoApp: App {
    let persistentContainer = PersistentController.shared
    
    init() {
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().backgroundColor = UIColor.clear
        UITableViewCell.appearance().backgroundColor = UIColor.clear
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistentContainer.container.viewContext)
        }
    }
}
