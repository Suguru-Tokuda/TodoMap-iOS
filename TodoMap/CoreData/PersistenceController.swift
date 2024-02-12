//
//  Persistence.swift
//  TodoMap
//
//  Created by Suguru on 9/5/23.
//

import CoreData

struct PersistentController {
    // A singleton for our entire app to use
    static let shared = PersistentController()
    // Storage for Core Data
    let container: NSPersistentContainer
        
    static var preview: PersistentController = {
        let result = PersistentController(inMemory: true)
        let viewContainer = result.container.viewContext
        
        return result
    }()
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "TodoMapModel")
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
