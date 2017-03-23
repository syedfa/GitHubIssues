//
//  CoreDataManager.swift
//  InterviewProject
//
//  Created by Fayyazuddin Syed on 2017-03-12.
//  Copyright © 2017 Fayyazuddin Syed. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    var managedObjectContext: NSManagedObjectContext!
    
    func initializeCoreDataStack() {
        
        guard let modelURL = Bundle.main.url(forResource: "GitHubModel", withExtension: "momd") else {
            fatalError("GitHubDataModel not found")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to initialize ManagedObjectModel")
        }
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        let fileManager = FileManager()
        
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Unable to get documents URL")
        }
        
        let storeURL = documentsURL.appendingPathComponent("GitHub.sqlite")
        print(storeURL)
        
        try! persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        
        let type = NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType
        self.managedObjectContext = NSManagedObjectContext(concurrencyType: type)
        self.managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
    }
    
    func saveContext() {
        guard self.managedObjectContext.hasChanges else { return }
        
        do {
            try self.managedObjectContext.save()
        }   catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
}
