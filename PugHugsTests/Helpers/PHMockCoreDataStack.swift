//
//  PHMockCoreDataStack.swift
//  PugHugsTests
//
//  Created by Alexander Scroggins on 7/23/18.
//  Copyright © 2018 HatStick. All rights reserved.
//

import Foundation
import CoreData

/**
 An in-memory CoreData stack that we can use for testing as it won't
 overwrite the data stored on the device.
 */
class PHMockCoreDataStack: NSObject {
    var storeCoordinator: NSPersistentStoreCoordinator!
    var managedObjectContext: NSManagedObjectContext!
    var managedObjectModel: NSManagedObjectModel!
    var store: NSPersistentStore!
    
    override init() {
        super.init()
        
        self.setupInMemoryCoreDataStack()
    }
    
    /**
     Sets up a CoreData stack in-memory so that we don't mess with the CoreData
     info saved on the device we deploy to.
     */
    private func setupInMemoryCoreDataStack() {
        self.managedObjectModel = NSManagedObjectModel.mergedModel(from: nil)
        self.storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        do {
            self.store = try storeCoordinator.addPersistentStore(ofType: NSInMemoryStoreType,
                                                                 configurationName: nil,
                                                                 at: nil,
                                                                 options: nil)
        } catch {
            print("Failed to setup coreData stack")
        }
        
        self.managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.managedObjectContext.persistentStoreCoordinator = storeCoordinator
    }
}
