//
//  CoreDataStack.swift
//  Newstack
//
//  Created by Aaron Cleveland on 6/26/20.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()

    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Article")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load persistent stores \(error)")
            }
            container.viewContext.automaticallyMergesChangesFromParent = true
        }
        return container
    }()

    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }

    func save(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) throws {
        var error: Error?
        //This prevents merge conflicts
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        /*
         I'm not sure if this is safe when on the main thread.
         We may need to just have to remember to do this when networking.
         If we get weird CoreData errors, we can test this as a posssibility
         */
        do {
            try context.save()
        } catch let saveError {
            context.reset()
            error = saveError
        }
        if let error = error {throw error}
    }
}
