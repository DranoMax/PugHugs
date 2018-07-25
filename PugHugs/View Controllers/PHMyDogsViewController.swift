//
//  PHMyDogViewController.swift
//  PugHugs
//
//  Created by Alexander Scroggins on 7/17/18.
//  Copyright © 2018 HatStick. All rights reserved.
//

import UIKit
import CoreData

/**
 Entrance to the app, this viewCon displays a tableView containing all of the
 user's saved dog profiles. There's also a button that allows the user to add
 additional dogs to the collection.
 */
class PHMyDogsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    /**
     Our dataSource - an array of Dog models.
     */
    var dogArray: [Dog] = [Dog]()
    
    /**
     I've created this lazy var so that it's value can be set with
     a mock PHCoreDataManager during UnitTesting.
     */
    lazy var coreDataManager: PHCoreDataManagerProtocol = {
        return PHCoreDataManager.shared
    }()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavCon()
        self.registerCells()
        self.setupTableViewDefaults()
        self.loadDogsFromCoreDataIntoDataSource()
    }
    
    // MARK: - Private Methods
    
    /**
     Sets the default values for our navCon including buttons and titles.
     */
    private func setupNavCon() {
        self.title = "My Dogs"
        
        let addDogButton = PHBarButtonItem(title: "Add Dog",
                                           style: .plain,
                                           target: self,
                                           action: #selector(addDogButtonTapped(_:)),
                                           isLeftBarButtonItem: false)

        self.navigationItem.setRightBarButton(addDogButton, animated: false)
    }
    
    /**
     Register nibs we will use in this table.
     */
    private func registerCells() {
        self.tableView.register(UINib(nibName: "PHMyDogCell", bundle: nil),
                                forCellReuseIdentifier: "MyDogCell")
    }
    
    /**
     Sets the defaults properties and colors for our tableView.
     */
    private func setupTableViewDefaults() {
        // Hide cells that don't exist
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.separatorColor = PHColorMaker.shared.lightGunmetal
    }
    
    /**
     Sends a fetch request to CoreData for ALL Dog models and attempts to load
     them into our tableView.
     */
    private func loadDogsFromCoreDataIntoDataSource() {
        self.coreDataManager.fetchAllDogProfileModels(success: { (dogArray) in
            self.dogArray = dogArray
            self.sortAndReloadTableView()
        }, failure: nil)
    }
    
    /**
     Sorts the dataSource of our tableView by dog name in decending order
     and then reloads the tableView.
     */
    private func sortAndReloadTableView() {
        // Sort Decending by dog name
        self.dogArray = dogArray.sorted(by: { (dogA, dogB) -> Bool in
            guard let nameA = dogA.name, let nameB = dogB.name else {
                return false
            }
            
            return nameA < nameB
        })
        
        self.tableView.reloadData()
    }
    
    // MARK: - Gesture Callback Methods
    
    /**
     Handles the tapping of the addDog button.
     - Parameters:
     - parameter sender: The UIBarButtonItem that was tapped.
     */
    @objc func addDogButtonTapped(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let addDogViewCon = storyboard.instantiateViewController(withIdentifier: "AddDogViewController") as? PHAddDogViewController else {
            return
        }
        
        addDogViewCon.delegate = self
        
        let navCon = UINavigationController(rootViewController: addDogViewCon)
        self.navigationController?.present(navCon, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate Methods

extension PHMyDogsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewCon = PHDogDetailsViewController(withDogModel: self.dogArray[indexPath.row])
        
        viewCon.delegate = self
        self.navigationController?.pushViewController(viewCon, animated: true)
    }
}

// MARK: - UITableViewDataSource Methods

extension PHMyDogsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dogArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let typedCell = tableView.dequeueReusableCell(withIdentifier: "MyDogCell", for: indexPath) as? PHMyDogCell {
            let dogModel = self.dogArray[indexPath.row]
            
            typedCell.dogImageView.image = nil
            
            if let image = dogModel.profileImage {
                typedCell.dogImageView.image = image
            }
            
            if let name = dogModel.name {
                typedCell.nameLabel.setPHAttrString(text: name, alignment: nil)
            }
            
            if let summary = dogModel.summary {
                typedCell.summaryLabel.setPHAttrString(text: summary, alignment: nil)
            }
            
            // Extend the separators to the edges of the tableView to match style guide
            typedCell.preservesSuperviewLayoutMargins = false
            typedCell.separatorInset = UIEdgeInsets.zero
            typedCell.layoutMargins = UIEdgeInsets.zero
            
            return typedCell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive,
                                          title: "Delete") { (action, indexPath) in
                                            // Delete action
                                            let dogModel = self.dogArray[indexPath.row]
                                            self.coreDataManager.deleteDogProfileModel(dogModel)
                                            self.dogArray.remove(at: indexPath.row)
                                            tableView.deleteRows(at: [indexPath], with: .fade)
        }

        return [delete]
    }
}

// MARK: - PHAddDogViewControllerDelegate Methods

extension PHMyDogsViewController: PHAddDogViewControllerDelegate {
    func savedNewDogModel(_ model: Dog) {
        self.dogArray.append(model)
        self.sortAndReloadTableView()
    }
}

// MARK: - PHDogDetailsViewControllerDelegate Methods

extension PHMyDogsViewController: PHDogDetailsViewControllerDelegate {
    func didDeleteDogProfile(_ dogModel: Dog) {
        guard let deletedDogIndex = self.dogArray.index(of: dogModel) else {
            return
        }
        
        self.dogArray.remove(at: deletedDogIndex)
        self.tableView.reloadData()
    }
}
