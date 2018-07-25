//
//  PHDogDetailsCell.swift
//  PugHugs
//
//  Created by Alexander Scroggins on 7/18/18.
//  Copyright © 2018 HatStick. All rights reserved.
//

import UIKit

/**
 Displays the details of a dog's profile.
 */
class PHDogDetailsCell: UITableViewCell {
    
    /**
     The dog's profile image.
     */
    @IBOutlet weak var dogImageView: UIImageView!
    
    /**
     The dog's name, centered in the view above the owner's name.
     */
    @IBOutlet weak var dogNameLabel: UILabel!
    
    /**
     The owner's name, centered below the dog's name.
     */
    @IBOutlet weak var ownerNameLabel: UILabel!
    
    // MARK: - Lifecycle Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupDefaults()
    }
    
    // MARK: - Private Methods
    
    /**
     This function sets the defaults for the cell - this includes fonts/colors.
     */
    private func setupDefaults() {
        let colorMaker = PHColorMaker.shared
        
        self.dogNameLabel.font = UIFont(name: "SFUIDisplay-Medium", size: 15)
        self.dogNameLabel.textColor = colorMaker.mediumDark
        
        self.ownerNameLabel.font = UIFont(name: "SFUIDisplay-Regular", size: 14)
        self.ownerNameLabel.textColor = colorMaker.darkCharcoal
    }
}
