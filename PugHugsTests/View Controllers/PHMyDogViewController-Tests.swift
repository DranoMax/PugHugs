//
//  PHMyDogViewController-Tests.swift
//  PugHugsTests
//
//  Created by Alexander Scroggins on 7/22/18.
//  Copyright © 2018 HatStick. All rights reserved.
//

import XCTest
@testable import PugHugs

class PHMyDogViewController_Tests: XCTestCase {
    
    /**
     We want to use the mock datamanager because we don't care to test
     whether things actually save in CoreData - that is handled in
     PHCoreDataManager-Tests.
     */
    var coreDataManager: MockPHDataManager!

    /**
     The MyDogs viewCon being tested here.
     */
    var myDogsViewCon: PHMyDogsViewController!
    
    override func setUp() {
        super.setUp()
        
        self.coreDataManager = MockPHDataManager()
        self.myDogsViewCon = UIStoryboard(name: "Main",
                                          bundle: nil).instantiateViewController(withIdentifier: "MyDogsViewController") as! PHMyDogsViewController
        self.myDogsViewCon.coreDataManager = self.coreDataManager
    }
    
    override func tearDown() {
        self.coreDataManager = nil
        self.myDogsViewCon = nil
        
        super.tearDown()
    }
    
    /**
     This tests to make sure that we are always fetching all dog models from
     our PHCoreDataManager on viewDidLoad.
     */
    func testViewDidLoadCallsFetchAllDogProfileModels() {
        // This causes viewDidLoad to be called
        let _ = myDogsViewCon.view
        
        // Make sure we're fetching all dog models like we expect
        XCTAssertTrue(self.coreDataManager.fetchAllDogProfileModelsWasCalled, "Fetch all dog models was never called.")
    }
}
