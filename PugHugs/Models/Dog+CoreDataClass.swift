//
//  Dog+CoreDataClass.swift
//  PugHugs
//
//  Created by Alexander Scroggins on 7/21/18.
//  Copyright © 2018 HatStick. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Dog)
public class Dog: NSManagedObject {
    
    /**
     A fully inflated UIImage from the saved Data object.
     */
    var profileImage: UIImage?
    
    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
        
        self.loadProfileImageFromData()
    }
    
    /**
     Attempts to load the saved pictureData into our profileImage variable
     for easy access.
     */
    private func loadProfileImageFromData() {
        guard let data = self.pictureData else {
            return
        }
        
        // Setup our image if it's available.
        if let picture = UIImage(data: data) {
            self.profileImage = picture
        }
    }
}
