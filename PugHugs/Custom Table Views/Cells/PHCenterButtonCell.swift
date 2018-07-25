//
//  PHCenterButtonCell.swift
//  PugHugs
//
//  Created by Alexander Scroggins on 7/19/18.
//  Copyright © 2018 HatStick. All rights reserved.
//

import UIKit

/**
 Protocols for the CenterButtonCell.
 */
protocol PHCenterButtonCellDelegate: class {
    
    /**
     Handles the pressing of the center button.
     - Parameters:
     - parameter sender: The button that called this function.
     */
    func centerButtonPressed(_ sender: Any)
}

/**
 Represents a cell with a single button in the center. Defaults to "Remove
 Pet Profile" for now.
 */
class PHCenterButtonCell: UITableViewCell {
    
    /**
     A reference to our delegate so we can pass along button presses.
     */
    weak var delegate: PHCenterButtonCellDelegate?
    
    /**
     Handles the pressing of the center button. Attempts to call
     centerButtonPressed on our delegate.
     - Parameters:
     - parameter sender: The button that called this function.
     */
    @IBAction func centerButtonPressed(_ sender: Any) {
        self.delegate?.centerButtonPressed(sender)
    }
}
