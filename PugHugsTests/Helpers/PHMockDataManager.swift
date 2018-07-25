//
//  PHMockDataManager.swift
//  PugHugsTests
//
//  Created by Alexander Scroggins on 7/23/18.
//  Copyright © 2018 HatStick. All rights reserved.
//

import Foundation
@testable import PugHugs

/**
 This provides us a way of mocking our PHCoreDataManager class in order to test
 that it's functions are called during certain events on our viewCon, without
 actually calling them since that's not what we're testing here.
 */
class MockPHDataManager: NSObject, PHCoreDataManagerProtocol {
    var fetchAllDogProfileModelsWasCalled = false
    var saveDogWithItemsWasCalled = false
    var deleteDogProfileModelWasCalled = false
    
    func fetchAllDogProfileModels(success: @escaping ([Dog]) -> (),
                                  failure: (() -> ())?) {
        self.fetchAllDogProfileModelsWasCalled = true
    }
    
    func saveDogWith(image: UIImage?,
                     dogName: String?,
                     ownerName: String?,
                     summary: String?,
                     success: ((Dog) -> ())?,
                     failure: (() -> ())?) {
        self.saveDogWithItemsWasCalled = true
    }
    
    func deleteDogProfileModel(_ dogModel: Dog) {
        self.deleteDogProfileModelWasCalled = true
    }
}
