//
//  PHColorMaker.swift
//  PugHugs
//
//  Created by Alexander Scroggins on 7/17/18.
//  Copyright © 2018 HatStick. All rights reserved.
//

import UIKit

/**
 This class acts as a singleton containing all possible custom colors
 used in the app. Keeping all the options in one place reduces the chance
 of using a color outside the style guide.
 */
class PHColorMaker: NSObject {
    
    /**
     This class is intended to be used as a Singleton, please use this
     variable.
     */
    static let shared = PHColorMaker()
    
    // MARK: - Lifecycle Methods
    
    /**
     This class is intended to be used as a singleton, so I've made the init private,
     please use the shared instance above.
     */
    private override init() {
        super.init()
    }
    
    // MARK: - Public Methods
    
    /**
     - returns: UIColor for hex value "78C352"
     */
    lazy var pugHugGreen: UIColor = {
        return UIColor.hexStringToUIColor(hex: "78C352")
    }()
    
    // MARK: - Greyscale Colors
    
    /**
     - returns: UIColor for hex value "989898"
     */
    lazy var darkCharcoal: UIColor = {
        return UIColor.hexStringToUIColor(hex: "989898")
    }()
    
    /**
     - returns: UIColor for hex value "777777"
     */
    lazy var darkGunmetal: UIColor = {
        return UIColor.hexStringToUIColor(hex: "777777")
    }()
    
    
    /**
     - returns: UIColor for hex value "555555"
     */
    lazy var mediumDark: UIColor = {
        return UIColor.hexStringToUIColor(hex: "555555")
    }()
    
    /**
     - returns: UIColor for hex value "DFDFDF"
     */
    lazy var lightGunmetal: UIColor = {
        return UIColor.hexStringToUIColor(hex: "DFDFDF")
    }()
}
