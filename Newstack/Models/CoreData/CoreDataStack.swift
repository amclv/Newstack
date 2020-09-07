//
//  CoreDataStack.swift
//  Newstack
//
//  Created by Aaron Cleveland on 9/6/20.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    var mainContext: NSManagedObjectContext { return container.viewContext }
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Newstack" as String)
        container.loadPersistentStores() { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    func save(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        context.performAndWait {
            do {
                try context.save()
            } catch {
                NSLog("Unable to save context: \(error)")
                context.reset()
            }
        }
    }
}
