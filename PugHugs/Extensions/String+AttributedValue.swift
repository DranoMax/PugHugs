//
//  String+AttributedValue.swift
//  PugHugs
//
//  Created by Alexander Scroggins on 7/21/18.
//  Copyright © 2018 HatStick. All rights reserved.
//

import Foundation

extension String {
    
    /**
     This function provides a convenient way to apply the default lineHeight of 1.6 to
     every string throughout the app.
     - Parameters:
     - parameter text: The text of the attributed string.
     - parameter color: The color of the text that you want.
     - parameter font: The font of the attributed string.
     - parameter alignment: The alignment of the label (ie centered)
     - returns: The built NSAttributedString with the default 1.6 line spacing.
     */
    func getPHAttrStringWith(color: UIColor, font: UIFont, alignment: NSTextAlignment?) -> NSAttributedString {
        // Need to apply default lineHeight of 1.6 to all strings throughout the app as
        // per style guide.
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.6
        
        if let alignment = alignment {
            paragraphStyle.alignment = alignment
        }
        
        let attributes: [NSAttributedStringKey: Any] = [.paragraphStyle: paragraphStyle,
                                                        .font: font,
                                                        .foregroundColor: color]
        
        return NSAttributedString(string: self, attributes: attributes)
    }
}
