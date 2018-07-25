//
//  PHCoreDataManager-Tests.swift
//  PugHugsTests
//
//  Created by Alexander Scroggins on 7/21/18.
//  Copyright © 2018 HatStick. All rights reserved.
//

import XCTest
import CoreData
@testable import PugHugs

class PHCoreDataManager_Tests: XCTestCase {
    
    /**
     This is an arbitrary number that isn't too large. The number of Dog
     models we'll init our db with for testing.
     */
    let numberDogModelsToSave = 3
    
    /**
     This is the object we are testing in this test.
     */
    var coreDataManager: PHCoreDataManager!
    
    /**
     A mock dataStack so that we store in-memory rather than on the device.
     */
    var mockCoreDataStack: PHMockCoreDataStack!
    
    /**
     I'm keeping a reference to the saved Dog models created during setup
     so that they can be used during test (like during deletion testing).
     */
    var arrayOfSavedDogModels: [Dog]?
    
    // Mark: - Lifecycle Methods
    
    override func setUp() {
        super.setUp()
        self.arrayOfSavedDogModels = [Dog]()
        
        self.mockCoreDataStack = PHMockCoreDataStack()
        self.coreDataManager = PHCoreDataManager(withManagedContext: mockCoreDataStack.managedObjectContext)
        
        self.populateManagedContext()
    }
    
    override func tearDown() {
        do {
            try self.mockCoreDataStack.storeCoordinator.remove(self.mockCoreDataStack.store)
        } catch {
            XCTFail("Couldn't remove persistent store...")
        }
        
        self.mockCoreDataStack.managedObjectContext = nil
        self.mockCoreDataStack = nil
        self.coreDataManager = nil
        
        self.arrayOfSavedDogModels?.removeAll()
        self.arrayOfSavedDogModels = nil
        
        super.tearDown()
    }
    
    // MARK: - Test Methods
    
    /**
     Tests that the store was setup correctly so that we can fail early
     if applicable.
     */
    func testThatStoreIsSetUp() {
        XCTAssertNotNil(self.mockCoreDataStack.store, "No persistent store.")
    }
    
    /**
     Tests that we get a success response from saving a new Dog model.
     */
    func testSaveDogModels() {
        let expectation = XCTestExpectation(description: "Saving Dog model to CoreData")
        
        self.coreDataManager.saveDogWith(image: nil,
                                       dogName: "Dog",
                                     ownerName: "Owner",
                                       summary: "Brief summary",
                                       success: { (savedModel) in
                                            expectation.fulfill()
                                            XCTAssertNotNil(savedModel, "saveDogWith function returned nil Dog model.")
                                            
        }, failure: {
            expectation.fulfill()
            XCTFail("Failed to fetch dog all models.")
        })
        
        // I'm allowing up to (a generous) 1 second before timing out, the reality is it should
        // take less than 0.05 of a second.
        self.wait(for: [expectation], timeout: 1)
    }
    
    /**
     Fetches all the Dog models that we saved during setup and checks that there are the
     correct number.
     */
    func testFetchAllDogProfileModels() {
        let expectation = XCTestExpectation(description: "Fetching all Dog models from the db")
        
        self.coreDataManager.fetchAllDogProfileModels(success: { (dogArray) in
            expectation.fulfill()
            XCTAssert(dogArray.count == self.numberDogModelsToSave,
                      "Expected number of dog models \(self.numberDogModelsToSave) was not found in db.")
        }, failure: {
            expectation.fulfill()
            XCTFail("Failed to fetch all Dog models from db.")
        })
        
        self.wait(for: [expectation], timeout: 1)
    }
    
    /**
     Deletes a Dog model from the db then checks with fetchAllDogProfileModels that
     the operation completed successfully (in that we have one less model returned).
     */
    func testDeleteDogProfileModel() {
        let expectation = XCTestExpectation(description: "Fetching all Dog models from the db.")
        
        if let dog = self.arrayOfSavedDogModels?.first {
            self.coreDataManager.deleteDogProfileModel(dog)
            
            self.coreDataManager.fetchAllDogProfileModels(success: { (dogArray) in
                expectation.fulfill()
                XCTAssert(dogArray.count == self.numberDogModelsToSave - 1,
                          "Expected to find one less dog model.")
            }, failure: {
                expectation.fulfill()
                XCTFail("Failed to fetch all Dog models from db.")
            })
        }
        
        self.wait(for: [expectation], timeout: 1)
    }
    
    // MARK: - Private Methods
    
    /**
     Creates and saves a number of Dog models to our in-memory db so that we can manipulate
     the data with our tests.
     */
    private func populateManagedContext() {
        guard let mockManagedContext = self.mockCoreDataStack.managedObjectContext else {
            XCTFail("MockManagedContext was nil")
            return
        }
        
        for i in 1...self.numberDogModelsToSave {
            if let dogModel = NSEntityDescription.insertNewObject(forEntityName: "Dog",
                                                                  into: mockManagedContext) as? Dog {
                dogModel.name = "Dog\(i)"
                dogModel.owner = "Owner\(i)"
                dogModel.summary = "Summary\(i)"
                
                self.arrayOfSavedDogModels?.append(dogModel)
            }
        }
        
        do {
            try mockManagedContext.save()
        } catch {
            XCTFail("Failed to populate db in setup.")
        }
    }
}
