//
//  PHBarButtonItem.swift
//  PugHugs
//
//  Created by Alexander Scroggins on 7/21/18.
//  Copyright © 2018 HatStick. All rights reserved.
//

import UIKit

/**
 I created this class in order provide a BarButtonItem that contains the default
 values that we want in the app that are not possible to add through
 UIBarButtonItem.appearance() in the AppDelegate.
 */
class PHBarButtonItem: UIBarButtonItem {
    
    /**
     Determines whether we apply a negative horizontalAlignment or not - it
     changes whether the button is on the left or right of the view.
     */
    var isLeftBarButtonItem = true
    
    /**
     This is the default horizontal spacing a barButtonItem should be from
     it's closest edge per the styleGuide.
     */
    let defaultHorizontalAlignment: CGFloat = 8
    
    // MARK: Lifecycle Methods
    
    /**
     We'll never want to init via this init (at least not for now).
     */
    private override init() {
        super.init()
    }
    
    /**
     This init gives us the default horizontal padding applied to either the left
     or right side of the button.
     - Parameters:
     - parameter title: The title of the UIBarButtonItem.
     - parameter style: The UIBarButtonItemStyle of the item.
     - parameter target: The target of the touch gesture.
     - parameter action: The action of the touch gesture.
     - parameter isLeftBarButtonItem: Whether the button is on the left of the navBar.
     */
    init(title: String?, style: UIBarButtonItemStyle, target: Any?, action: Selector?, isLeftBarButtonItem: Bool) {
        self.init(title: title, style: style, target: target, action: action)
        self.isLeftBarButtonItem = isLeftBarButtonItem
        self.setupDefaults()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    /**
     Sets up the default offset for our BarButtonItem.
     */
    private func setupDefaults() {
        let padding = self.isLeftBarButtonItem ? -self.defaultHorizontalAlignment :
                                                    self.defaultHorizontalAlignment
        let offset = UIOffset(horizontal: padding, vertical: 0)
        self.setTitlePositionAdjustment(offset, for: .default)
    }
}
