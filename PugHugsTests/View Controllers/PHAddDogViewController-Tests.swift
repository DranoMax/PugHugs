//
//  PHAddDogViewController-Tests.swift
//  PugHugsTests
//
//  Created by Alexander Scroggins on 7/23/18.
//  Copyright © 2018 HatStick. All rights reserved.
//

import XCTest
@testable import PugHugs

class PHAddDogViewController_Tests: XCTestCase {
    
    /**
     We want to use the mock datamanager because we don't care to test
     whether things actually save in CoreData - that is handled in
     PHCoreDataManager-Tests.
     */
    var coreDataManager: MockPHDataManager!
    
    /**
     The viewCon being tested in this test.
     */
    var addDogViewCon: PHAddDogViewController!
    
    override func setUp() {
        super.setUp()
        
        self.coreDataManager = MockPHDataManager()
        self.addDogViewCon = UIStoryboard(name: "Main",
                                          bundle: nil).instantiateViewController(withIdentifier: "AddDogViewController") as! PHAddDogViewController
        self.addDogViewCon.coreDataManager = self.coreDataManager
    }
    
    override func tearDown() {
        self.coreDataManager = nil
        self.addDogViewCon = nil
        
        super.tearDown()
    }
    
    /**
     This tests to make sure that the save button attempts to save the Dog model
     provided a dog name was given.
     */
    func testSaveButtonTapped() {
        // Filling the textField with a name so that the form validates properly
        let _ = self.addDogViewCon.view
        self.addDogViewCon.dogNameTextField.text = "Dog1"
        self.addDogViewCon.saveButtonTapped(UIBarButtonItem())
        
        // Make sure we made a call to save the dog profile model as expected.
        XCTAssertTrue(self.coreDataManager.saveDogWithItemsWasCalled, "Dog model was saved.")
    }
}
