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
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistentContainer.container.viewContext)
        }
    }
}
