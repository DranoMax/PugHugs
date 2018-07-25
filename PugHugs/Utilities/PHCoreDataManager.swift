//
//  PHCoreDataManager.swift
//  PugHugs
//
//  Created by Alexander Scroggins on 7/20/18.
//  Copyright © 2018 HatStick. All rights reserved.
//

import Foundation
import CoreData

/**
 I'm defining a protocol for this class mostly so that I can mock it during
 Unit testing.
 */
protocol PHCoreDataManagerProtocol: class {
    func fetchAllDogProfileModels(success: @escaping ([Dog])->(),
                                  failure: (()->())?)
    func saveDogWith(image: UIImage?, dogName: String?,
                     ownerName: String?, summary: String?,
                     success: ((Dog)->())?,
                     failure: (()->())?)
    func deleteDogProfileModel(_ dogModel: Dog)
}

/**
 A place to contain all of our CoreData operations so that it doesn't
 litter the app.
 */
class PHCoreDataManager: NSObject, PHCoreDataManagerProtocol {
    
    /**
     This class is intended to be used as a Singleton, please use this
     variable.
     */
    static let shared = PHCoreDataManager()
    
    private var managedContext: NSManagedObjectContext?
    
    // MARK: - Lifecycle Methods
    
    /**
     This class is intended to be used as a singleton, so I've made the init private,
     please use the shared instance above.
     */
    private override init() {
        super.init()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        self.managedContext = appDelegate.persistentContainer.viewContext
    }
    
    /**
     This constructor should ONLY be used for test, otherwise you need to use the
     shared instance. I've made this constructor so we can use a modeled managedContext
     for testing.
     - Parameters:
     - parameter managedContext: An in-memory managedContext for testing only.
     */
    public init(withManagedContext managedContext: NSManagedObjectContext) {
        super.init()
        
        self.managedContext = managedContext
    }
    
    /**
     Attempts to fetch all Dog models from our CoreData database. If successful,
     we'll return them into the passed success block.
     - Parameters:
     - parameter success: A non optional success block, you'll need to use the passed in Dog array.
     - parameter failure: An optional failure block.
     */
    func fetchAllDogProfileModels(success: @escaping ([Dog])->(), failure: (()->())?) {
        guard let managedContext = self.managedContext else {
            return
        }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Dog")
        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (fetchResult) in
            DispatchQueue.main.async {
                if let dogs = fetchResult.finalResult as? [Dog] {
                    success(dogs)
                }
            }
        }
        
        do {
            // Execute Asynchronous Fetch Request
            _ = try managedContext.execute(asyncFetchRequest)
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
            
            if let failure = failure {
                failure()
            }
        }
    }
    
    /**
     Attempts to save a Dog model for the passed information.
     - Parameters:
     - parameter image: An optional profile image for the dog.
     - parameter dogName: The dog's name.
     - parameter ownerName: The owner's name.
     - parameter summary: A short description of the dog.
     - parameter success: An optional success block.
     - parameter failure: An optional failure block.
     */
    func saveDogWith(image: UIImage?, dogName: String?,
                     ownerName: String?, summary: String?,
                     success: ((Dog)->())?,
                     failure: (()->())?) {
        guard let managedContext = self.managedContext else {
            return
        }
        
        if let entity = NSEntityDescription.entity(forEntityName: "Dog", in: managedContext),
            let newDog = NSManagedObject(entity: entity, insertInto: managedContext) as? Dog {
            
            newDog.uuid = UUID().uuidString
            
            if let image = image {
                newDog.profileImage = image
                newDog.pictureData = UIImagePNGRepresentation(image)
            }
            
            if let name = dogName {
                newDog.name = name
            }
            
            if let owner = ownerName {
                newDog.owner = owner
            }
            
            if let summary = summary {
                newDog.summary = summary
            }
            
            do {
                try managedContext.save()
                
                if let success = success {
                    success(newDog)
                }
            } catch {
                print("Failed to save new dog!!")
                
                if let failure = failure {
                    failure()
                }
            }
        }
    }
    
    /**
     Deletes the passed Dog model from our CoreData database.
     - Parameters:
     - parameter dogModel: The dog model to delete.
     */
    func deleteDogProfileModel(_ dogModel: Dog) {
        guard let managedContext = self.managedContext else {
            return
        }
        
        managedContext.delete(dogModel)
    }
}
