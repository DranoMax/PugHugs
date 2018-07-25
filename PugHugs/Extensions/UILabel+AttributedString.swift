//
//  UILabel+AttributedString.swift
//  PugHugs
//
//  Created by Alexander Scroggins on 7/20/18.
//  Copyright © 2018 HatStick. All rights reserved.
//

import UIKit

extension UILabel {
    
    /**
     Convenience method for setting the correct attributed string for a label.
     If you've already set the font and textColor for the label then simply
     send a string to this and it will do the rest. This also applies the default
     1.6 line spacing.
     - Parameters:
     - parameter text: The text of the attributed string.
     */
    func setPHAttrString(text: String, alignment: NSTextAlignment?) {
        self.attributedText = text.getPHAttrStringWith(color: self.textColor,
                                                       font: self.font,
                                                       alignment: alignment)
    }
}
