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
    @ObservedObject var mainCoordinator: MainCoordinator = MainCoordinator()
    @ObservedObject var locationManager: LocationManager = LocationManager()
    
    init() {
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().backgroundColor = UIColor.clear
        UITableViewCell.appearance().backgroundColor = UIColor.clear
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistentContainer.container.viewContext)
                .environmentObject(mainCoordinator)
                .environmentObject(locationManager)
                .onAppear {
                    locationManager.checkLocationAuthorization()
                }
        }
    }
}
