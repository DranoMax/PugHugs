//
//  String+AttributedValue-Tests.swift
//  PugHugsTests
//
//  Created by Alexander Scroggins on 7/21/18.
//  Copyright © 2018 HatStick. All rights reserved.
//

import XCTest
@testable import PugHugs

class String_AttributedValue_Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    /**
     Test that the created AttributedString created in our extension has the expected
     1.6 line-height and applied font and color.
     */
    func testGetPHAttrString() {
        let fontName = "SFUIDisplay-Regular"
        let fontSize: CGFloat = 15
        let textColor = UIColor.red
        
        guard let testFont = UIFont(name: fontName, size: 15)  else {
            return
        }
        
        let testString = "This is a test."
        
        // Test that the string hasn't changed
        let testAttrString = testString.getPHAttrStringWith(color: textColor, font: testFont, alignment: nil)
        XCTAssert(testAttrString.string == testString, "String of created AttrString has changed")
        
        // Test that attributes are correct
        let attributes = testAttrString.attributes(at: 0,
                                                   longestEffectiveRange: nil,
                                                   in: NSRange(location: 0, length: testAttrString.length))
        
        // Double check the font
        if let resultFont = attributes[.font] as? UIFont {
            XCTAssert(resultFont.fontName == fontName, "Wrong font name found in created AttrString")
            XCTAssert(resultFont.pointSize == fontSize, "Wrong font size found in created AttrString")
        } else {
            XCTFail("Failed to find font on created AttrString")
        }
        
        // Double check the paragraph style
        if let paragraphStyle = attributes[.paragraphStyle] as? NSParagraphStyle {
            XCTAssert(paragraphStyle.lineHeightMultiple == 1.6, "Created AttrString doesn't have 1.6 lineHeight")
        } else {
            XCTFail("Failed to find paragraphStyle on created AttrString")
        }
        
        // Double check the foregroundColor
        if let resultColor = attributes[.foregroundColor] as? UIColor {
            XCTAssert(resultColor.isRGBAndAlphaEqualTo(color: textColor), "Created AttrString doesn't have the expected text color")
        } else {
            XCTFail("Failed to find foregroundColor on created AttrString")
        }
    }
}
