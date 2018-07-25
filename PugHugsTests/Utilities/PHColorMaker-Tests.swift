//
//  PHColorMaker-Tests.swift
//  PugHugsTests
//
//  Created by Alexander Scroggins on 7/21/18.
//  Copyright © 2018 HatStick. All rights reserved.
//

import XCTest
@testable import PugHugs

class PHColorMaker_Tests: XCTestCase {
    
    var colorMaker: PHColorMaker!
    
    override func setUp() {
        super.setUp()
        
        self.colorMaker = PHColorMaker.shared
    }
    
    override func tearDown() {
        super.tearDown()
        
        self.colorMaker = nil
    }
    
    /**
     Tests all colors available in PHColorMaker to make sure they haven't been modified from
     the point of truth (style guide) values and that they load as expected.
     */
    func testColorVars() {
        let expectedPugHugGreen = UIColor.hexStringToUIColor(hex: "78C352")
        let expectedDarkCharcoal = UIColor.hexStringToUIColor(hex: "989898")
        let expectedDarkGunmetal = UIColor.hexStringToUIColor(hex: "777777")
        let expectedMediumDark = UIColor.hexStringToUIColor(hex: "555555")
        let expectedLightGunmetal = UIColor.hexStringToUIColor(hex: "DFDFDF")
        
        XCTAssert(expectedPugHugGreen.isRGBAndAlphaEqualTo(color: self.colorMaker.pugHugGreen),
                  "Failed to convert to expected UIColor black.")
        XCTAssert(expectedDarkCharcoal.isRGBAndAlphaEqualTo(color: self.colorMaker.darkCharcoal),
                  "Failed to convert to expected UIColor black.")
        XCTAssert(expectedDarkGunmetal.isRGBAndAlphaEqualTo(color: self.colorMaker.darkGunmetal),
                  "Failed to convert to expected UIColor black.")
        XCTAssert(expectedMediumDark.isRGBAndAlphaEqualTo(color: self.colorMaker.mediumDark),
                  "Failed to convert to expected UIColor black.")
        XCTAssert(expectedLightGunmetal.isRGBAndAlphaEqualTo(color: self.colorMaker.lightGunmetal),
                  "Failed to convert to expected UIColor black.")
    }
}
