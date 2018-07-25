//
//  PHDogDetailsViewController.swift
//  PugHugs
//
//  Created by Alexander Scroggins on 7/18/18.
//  Copyright © 2018 HatStick. All rights reserved.
//

import UIKit

/**
 Setting up delegate protocol so we can inform the delegate when
 we delete a dog profile from this view.
 */
protocol PHDogDetailsViewControllerDelegate: class {
    
    /**
     User deleted a dog model from the dataBase, so we should update
     the dataSource of our tableView.
     - Parameters:
     - parameter dogModel: The Dog model that was deleted.
     */
    func didDeleteDogProfile(_ dogModel: Dog)
}

/**
 This TableViewController displays the details of a selected dog.
 So far that information is limited to the dog's picture, name, owner's
 name and description of the dog.
 
 ## NOTE TO RECRUITERS VIEWING THIS CODE:
 In this class I'm using an UITableViewController instead of an imbeded
 ViewController to display that I have the ability to do it, normally I'd use an
 UITableViewController in this case if we know the view won't change in a way that
 would necessitate using an UIVieController.
 */
class PHDogDetailsViewController: UITableViewController {
    
    /**
     I've created this lazy var so that it's value can be set with
     a mock PHCoreDataManager during UnitTesting.
     */
    lazy var coreDataManager: PHCoreDataManagerProtocol = {
        return PHCoreDataManager.shared
    }()
    
    /**
     This the dog profile that we are currently displaying information for.
     */
    var dogModel: Dog?
    
    /**
     A reference to our delegate so we can inform them of when we've
     deleted this profile.
     */
    var delegate: PHDogDetailsViewControllerDelegate?
    
    /**
     An enum representing the sections contained within this tableView.
     This helps prevent us from passing around magic numbers for sections.
     */
    enum DogDetailsTableSections: Int {
        case dogDetailCell
        case description
        case deleteProfile
        
        // BE SURE TO KEEP THIS AT THE BOTTOM TO MAINTAIN COUNT!
        case count
    }
    
    // MARK: - Lifecycle Methods
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    /**
     This is the prefered way of initing this object, please try to always use
     this constructor.
     - Parameters:
     - parameter dogModel: The model of the dog profile to be displayed in this viewCon.
     */
    convenience public init(withDogModel dogModel: Dog?) {
        self.init(nibName: nil, bundle: nil)
        
        self.dogModel = dogModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupDefaults()
    }
    
    // MARK: - Private Methods
    
    private func setupDefaults() {
        // Hide cells that don't exist
        self.tableView.tableFooterView = UIView(frame: .zero)
        
        self.setupNavBar()
        self.setupTableViewDefaults()
        self.registerCells()
    }
    
    /**
     Sets up the title for our view.
     */
    private func setupNavBar() {
        if let dogName = self.dogModel?.name {
            self.title = dogName
        }
    }
    
    /**
     Sets the defaults properties and colors for our tableView.
     */
    private func setupTableViewDefaults() {
        // Hide cells that don't exist
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.backgroundColor = UIColor.groupTableViewBackground
        self.tableView.separatorColor = PHColorMaker.shared.lightGunmetal
    }
    
    /**
     Register nibs we will use in this table.
     */
    private func registerCells() {
        self.tableView.register(UINib(nibName: "PHCustomHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "CustomHeaderView")
        
        self.tableView.register(UINib(nibName: "PHDogDetailsCell", bundle: nil), forCellReuseIdentifier: "DogDetailsCell")
        self.tableView.register(UINib(nibName: "PHDescriptionCell", bundle: nil), forCellReuseIdentifier: "DescriptionCell")
        self.tableView.register(UINib(nibName: "PHCenterButtonCell", bundle: nil), forCellReuseIdentifier: "CenterButtonCell")
    }
    
    /**
     Creates a dogDetailCell for our tableView. This cell contains the dog's picture
     and basic information.
     - Parameters:
     - parameter tableView: The tableView to create the cell for.
     - parameter indexPath: The indexPath the create the cell for.
     */
    private func createDogDetailCellForTableView(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if let typedCell = tableView.dequeueReusableCell(withIdentifier: "DogDetailsCell", for: indexPath) as? PHDogDetailsCell {
            
            if let picture = self.dogModel?.pictureData {
                typedCell.dogImageView?.image = UIImage(data: picture)
            }
            
            if let dogName = self.dogModel?.name {
                typedCell.dogNameLabel.setPHAttrString(text: dogName, alignment: .center)
            }
            
            if let ownerName = self.dogModel?.owner {
                typedCell.ownerNameLabel.setPHAttrString(text: ownerName, alignment: .center)
            }
            
            return typedCell
        }
        
        return UITableViewCell()
    }
    
    /**
     Creates a descriptionCell for our tableView. A description cell is a view filled with
     a label displaying a description of the dog.
     - Parameters:
     - parameter tableView: The tableView to create the cell for.
     - parameter indexPath: The indexPath the create the cell for.
     */
    private func createDescriptionCellForTableView(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if let typedCell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell", for: indexPath) as? PHDescriptionCell {
            
            if let description = self.dogModel?.summary {
                typedCell.mainLabel.setPHAttrString(text: description, alignment: nil)
            }
            
            return typedCell
        }
        
        return UITableViewCell()
    }
    
    /**
     Creates a centerButtonCell for our tableView. This cell contains a button centered
     in the view and can be used to delete the dog's profile.
     - Parameters:
     - parameter tableView: The tableView to create the cell for.
     - parameter indexPath: The indexPath the create the cell for.
     */
    private func createCenterButtonCellForTableView(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if let typedCell = tableView.dequeueReusableCell(withIdentifier: "CenterButtonCell", for: indexPath) as? PHCenterButtonCell {
            typedCell.delegate = self
            
            return typedCell
        }
        
        return UITableViewCell()
    }
    
    // MARK: - UITableViewDataSource Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return DogDetailsTableSections.count.rawValue
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Currently there's only one each, but we could easily create an enum like we
        // did for the table sections for the tableRows.
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case DogDetailsTableSections.dogDetailCell.rawValue:
            return self.createDogDetailCellForTableView(tableView, indexPath: indexPath)
        case DogDetailsTableSections.description.rawValue:
            return self.createDescriptionCellForTableView(tableView, indexPath: indexPath)
        case DogDetailsTableSections.deleteProfile.rawValue:
            return self.createCenterButtonCellForTableView(tableView, indexPath: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == DogDetailsTableSections.description.rawValue ,
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomHeaderView") as? PHCustomHeaderView {
            headerView.headerLabel.text = "DESCRIPTION"
            return headerView
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        // Only some of our sections should have headers!
        if section == DogDetailsTableSections.description.rawValue ||
            section == DogDetailsTableSections.deleteProfile.rawValue {
            return 44
        }
        
        return 0
    }
}

// MARK: - PHCenterButtonCellDelegate Methods

extension PHDogDetailsViewController: PHCenterButtonCellDelegate {
    
    /**
     Our implementation of the required function, we respond to the
     "Remove Pet Profile" button press by deleting the selected model from CoreData.
     - Parameters:
     - parameter sender: The button that called this function.
     */
    func centerButtonPressed(_ sender: Any) {
        if let model = self.dogModel {
            self.coreDataManager.deleteDogProfileModel(model)
            self.delegate?.didDeleteDogProfile(model)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
}
