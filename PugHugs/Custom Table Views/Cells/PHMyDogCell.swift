//
//  PHMyDogCell.swift
//  PugHugs
//
//  Created by Alexander Scroggins on 7/17/18.
//  Copyright © 2018 HatStick. All rights reserved.
//

import UIKit

/**
 A dog cell complete with the dog's picture on the left and their name
 and summery on the right.
 */
class PHMyDogCell: UITableViewCell {
    
    /**
     An 56x56 image of the dog.
     */
    @IBOutlet weak var dogImageView: UIImageView!
    
    /**
     The dog's name in bold at the top of the cell.
     */
    @IBOutlet weak var nameLabel: UILabel!
    
    /**
     A label containing a short description of the dog.
     */
    @IBOutlet weak var summaryLabel: UILabel!
    
    // MARK: - Lifecycle Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupDefaults()
    }
    
    // MARK: - Private Methods
    
    /**
     This function sets the defaults for the cell - this includes fonts/colors
     and the corner radius of our imageView.
     */
    private func setupDefaults() {
        let colorMaker = PHColorMaker.shared
        
        self.nameLabel.font = UIFont(name: "SFUIDisplay-Medium", size: 15)
        self.nameLabel.textColor = colorMaker.mediumDark
        
        self.summaryLabel.font = UIFont(name: "SFUIDisplay-Regular", size: 14)
        self.summaryLabel.textColor = colorMaker.darkCharcoal
        
        // This wasn't mentioned in the mockups other than visually - this is
        // a best guess to the value of the corner radius but it does look nicer
        // than none at all.
        self.dogImageView.layer.cornerRadius = 2.0
        self.dogImageView.clipsToBounds = true
    }
}
