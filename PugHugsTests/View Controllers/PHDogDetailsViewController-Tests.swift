//
//  PHDogDetailsViewController-Tests.swift
//  PugHugsTests
//
//  Created by Alexander Scroggins on 7/23/18.
//  Copyright © 2018 HatStick. All rights reserved.
//

import XCTest
import CoreData
@testable import PugHugs

class PHDogDetailsViewController_Tests: XCTestCase {
    
    /**
     We want to use the mock datamanager because we don't care to test
     whether things actually save in CoreData - that is handled in
     PHCoreDataManager-Tests.
     */
    var coreDataManager: MockPHDataManager!
    
    /**
     We need a reference to a mockCoreDataStack so that we can init a Dog
     model for test.
     */
    var mockCoreDataStack: PHMockCoreDataStack!
    
    /**
     The DogDetails viewCon that we are testing.
     */
    var dogDetailsViewCon: PHDogDetailsViewController!
    
    override func setUp() {
        super.setUp()
        
        self.mockCoreDataStack = PHMockCoreDataStack()
        self.coreDataManager = MockPHDataManager()
        self.dogDetailsViewCon = PHDogDetailsViewController(withDogModel: nil)
        self.dogDetailsViewCon.coreDataManager = self.coreDataManager
        
        // Make sure that the viewCon has a Dog model or it won't work properly
        if let mockManagedContext = self.mockCoreDataStack.managedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Dog", in: mockManagedContext),
            let newDog = NSManagedObject(entity: entity, insertInto: mockManagedContext) as? Dog {
            newDog.name = "Dog1"
            self.dogDetailsViewCon.dogModel = newDog
        }
    }
    
    override func tearDown() {
        do {
            try self.mockCoreDataStack.storeCoordinator.remove(self.mockCoreDataStack.store)
        } catch {
            XCTFail("Couldn't remove persistent store...")
        }
        
        self.mockCoreDataStack.managedObjectContext = nil
        self.mockCoreDataStack = nil
        self.dogDetailsViewCon = nil
        
        super.tearDown()
    }
    
    /**
     This tests to make sure that we are always fetching all dog models from
     our PHCoreDataManager on viewDidLoad.
     */
    func testCenterButtonPressed() {
        self.dogDetailsViewCon.centerButtonPressed(UIButton())

        // Make sure we made a call to save the dog profile model as expected.
        XCTAssertTrue(self.coreDataManager.deleteDogProfileModelWasCalled, "Dog model was deleted.")
    }
}
