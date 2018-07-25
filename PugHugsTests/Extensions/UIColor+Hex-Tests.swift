//
//  UIColor+Hex-Tests.swift
//  PugHugsTests
//
//  Created by Alexander Scroggins on 7/21/18.
//  Copyright © 2018 HatStick. All rights reserved.
//

import XCTest
@testable import PugHugs

class UIColor_Hex_Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /**
     Here we test out the generation of several UIColors from hex strings, comparing them
     to their expected UIColor equivelent.
     */
    func testHexStringToUIColor() {
        let blackhexString = "000000"
        let redhexString = "FF0000"
        let yellowhexString = "FFFF00"
        
        XCTAssert(UIColor.black.isRGBAndAlphaEqualTo(color: UIColor.hexStringToUIColor(hex: blackhexString)),
                  "Failed to convert to expected UIColor black.")
        XCTAssert(UIColor.red.isRGBAndAlphaEqualTo(color: UIColor.hexStringToUIColor(hex: redhexString)),
                  "Failed to convert to expected UIColor red.")
        XCTAssert(UIColor.yellow.isRGBAndAlphaEqualTo(color: UIColor.hexStringToUIColor(hex: yellowhexString)),
                  "Failed to convert to expected UIColor yellow.")
    }
}
