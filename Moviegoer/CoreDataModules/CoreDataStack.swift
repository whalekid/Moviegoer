//
//  CoreDataStack.swift
//  Moviegoer
//
//  Created by кит on 14/11/2021.
//  Copyright © 2021 kitaev. All rights reserved.
//

import Foundation
import CoreData
class CoreDataStack {
    
    private init() {}
    static let shared = CoreDataStack()
    
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Moviegoer")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
      let context = persistentContainer.viewContext
      if context.hasChanges {
        do {
          try context.save()
        } catch {
          let nserror = error as NSError
          fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
      }
    }
}
