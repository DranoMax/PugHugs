//
//  PHAddDogViewController.swift
//  PugHugs
//
//  Created by Alexander Scroggins on 7/17/18.
//  Copyright © 2018 HatStick. All rights reserved.
//

import UIKit
import CoreData
import CropViewController

/**
 This protocol gives us the ability to pass our new dog model back
 to a delegate (PHDogVieController in this case).
 */
protocol PHAddDogViewControllerDelegate: class {
    
    /**
     We pass the new Dog model to this function when the user hits
     the save button.
     - Parameters:
     - parameters model: The new Dog model.
     */
    func savedNewDogModel(_ model: Dog)
}

/**
 This is where users can save a new Dog profile to their account.
 That profile can include an image, their name, their owner's name and
 a brief summary.
 */
class PHAddDogViewController: UIViewController {
    @IBOutlet weak var dogNameLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var dogImageView: UIImageView!
    @IBOutlet weak var addPhotoImageView: UIImageView!
    @IBOutlet weak var dogNameTextField: UITextField!
    @IBOutlet weak var ownerTextField: UITextField!
    @IBOutlet weak var summaryTextView: UITextView!
    
    /**
     An activity indicator to show the user that we are in the middle of saving
     when they tap the save button. The truth is that the save function happens
     so fast that you won't even see the indicator, but I wanted to show I know
     how to add one :P.
     */
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    /**
     We need to a delegate so that we call tell them when we've saved a new dog.
     */
    weak var delegate: PHAddDogViewControllerDelegate?
    
    /**
     I've created this lazy var so that it's value can be set with
     a mock PHCoreDataManager during UnitTesting.
     */
    lazy var coreDataManager: PHCoreDataManagerProtocol = {
        return PHCoreDataManager.shared
    }()
    
    /**
     A third party image picker that gives us the added bonus of cropping for free!
     */
    var imagePicker: UIImagePickerController?
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDefaults()
    }
    
    // MARK: - Private Methods
    
    /**
     Sets up all the default values for this viewController - only call on viewDidLoad.
     */
    private func setupDefaults() {
        self.setupNavController()
        self.registerForNotifications()
        self.setupDogImageView()
        self.setupImagePicker()
        self.setupFontsAndTextColors()
    }
    
    /**
     Sets the default values of our navCon including title and buttons.
     */
    private func setupNavController() {
        self.title = "New Dog"
        
        let cancelButton = PHBarButtonItem(title: "Cancel",
                                           style: .plain,
                                           target: self,
                                           action: #selector(cancelButtonTapped(_:)),
                                           isLeftBarButtonItem: true)

        let saveButton = PHBarButtonItem(title: "Save",
                                         style: .plain,
                                         target: self,
                                         action: #selector(saveButtonTapped(_:)),
                                         isLeftBarButtonItem: false)
        
        self.navigationItem.setLeftBarButton(cancelButton, animated: false)
        self.navigationItem.setRightBarButton(saveButton, animated: false)
    }
    
    /**
     Adds observers to the notificationCenter necessary for this class. In this case,
     we only need to listen for when coreData finishes saving.
     */
    private func registerForNotifications() {
        let notifCenter = NotificationCenter.default
        
        notifCenter.addObserver(self,
                                selector: #selector(coreDataDidSave(_:)),
                                name: .NSManagedObjectContextDidSave,
                                object: nil)
    }
    
    /**
     Setups up the default values for the dog's imageView. We also add a tapGestureRecognizer
     so that the user can tap the imageView and add a new photo.
     */
    private func setupDogImageView() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dogImageViewTapped(_:)))
        
        self.dogImageView.isUserInteractionEnabled = true
        self.dogImageView.addGestureRecognizer(tapRecognizer)
        self.dogImageView.backgroundColor = PHColorMaker.shared.mediumDark
    }
    
    /**
     Sets up the 3rd party image picker for us for use when a user taps the dog
     imageView.
     */
    private func setupImagePicker() {
        self.imagePicker = UIImagePickerController()
        self.imagePicker?.delegate = self
    }
    
    /**
     Sets up the default fonts and text colors for all labels and textFields in this
     viewCon.
     */
    private func setupFontsAndTextColors() {
        // NOTE: I'd like to eventually move the initing of fonts and possible color
        // pairs into it's own class to reduce the amount of reused code here.
        let colorMaker = PHColorMaker.shared
        
        self.dogNameLabel.font = UIFont(name: "SFUIDisplay-Medium", size: 15)
        self.dogNameLabel.textColor = colorMaker.mediumDark
        
        self.dogNameTextField.font = UIFont(name: "SFUIDisplay-Regular", size: 15)
        self.dogNameTextField.textColor = colorMaker.darkGunmetal
        
        self.ownerLabel.font = UIFont(name: "SFUIDisplay-Medium", size: 15)
        self.ownerLabel.textColor = colorMaker.mediumDark
        
        self.ownerTextField.font = UIFont(name: "SFUIDisplay-Regular", size: 15)
        self.ownerTextField.textColor = colorMaker.darkGunmetal
        
        self.summaryTextView.font = UIFont(name: "SFUIDisplay-Regular", size: 15)
        self.summaryTextView.textColor = colorMaker.darkGunmetal

        // This is dumb but we need an unwrapped font here, I'd prefer the solution in the comment
        // above.
        if let regularFont = UIFont(name: "SFUIDisplay-Regular", size: 15) {
            // Setup summaryTextView's placeholder defaults
            let placeholder = "Add a brief dog bio".getPHAttrStringWith(color: colorMaker.darkGunmetal,
                                                                        font: regularFont,
                                                                        alignment: nil)
            
            self.summaryTextView.attributedPlaceholder = placeholder
        }
    }
    
    /**
     Checks that we have at least a dog's name before saving (so we don't
     end up with empty cells).
     - returns: Whether the user has filled out at least the dog's name.
     */
    private func isDogProfileValid() -> Bool {
        guard let dogName = self.dogNameTextField.text, dogName.count > 0 else {
            return false
        }
        
        return true
    }
    
    /**
     Pops the alert letting the user know they need to fill out a dog's name
     in order to save the profile.
     */
    private func showSaveErrorAlert() {
        let alert = UIAlertController(title: "Error",
                                      message: "Sorry, but you must fill out the Dog Name field in order to save.",
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Notification Callbacks
    
    /**
     Handles the notification that is fired by the OS when CoreData finishes saving
     a model.
     - Parameters:
     - parameter notification: The NSManagedObjectContextDidSave notification that called this function.
     */
    @objc func coreDataDidSave(_ notification: Notification) {
        self.activityIndicator?.stopAnimating()
    }
    
    // MARK: - Gesture Callbacks
    
    /**
     Handles the tapping of the dog imageView. Causes us to open the 3rd party image
     picker so that users can choose and crop a profile pic for their dog.
     - Parameters:
     - parameter sender: The UIView that was tapped to call this function.
     */
    @objc func dogImageViewTapped(_ sender: UIImageView) {
        guard let imagePicker = self.imagePicker else {
            // In the future I should add an alert to let user's know what's wrong.
            return
        }
        
        let alert = UIAlertController(title: "Upload a photo",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        
        // Camera Action
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let takePhotoAction = UIAlertAction(title: "Take a photo",
                                                style: .default) { (action) in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }
            
            alert.addAction(takePhotoAction)
        }
        
        // Photo Library Action
        let choosePhotoAction = UIAlertAction(title: "Choose existing photo",
                                              style: .default) { (action) in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        // Cancel Action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(choosePhotoAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    /**
     Handles the tapping of the cancel button, simply closes the viewCon.
     - Parameters:
     - parameter sender: The UIBarButtonItem that was tapped to call this function.
     */
    @objc func cancelButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /**
     Handles the tapping of the save button. Checks to see if the fields are valid
     before attempting to save and popping an ActivityIndicatorView at the same time.
     - Parameters:
     - parameter sender: The UIBarButtonItem that was tapped to call this function.
     */
    @objc func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard self.isDogProfileValid() else {
            self.showSaveErrorAlert()
            return
        }
        
        // Stop spinning the activityIndicator and dismiss the viewCon
        let dismissalBlock = {
            self.activityIndicator.stopAnimating()
            self.dismiss(animated: true, completion: nil)
        }
        
        self.coreDataManager.saveDogWith(image: self.dogImageView.image,
                                         dogName: self.dogNameTextField.text,
                                         ownerName: self.ownerTextField.text,
                                         summary: self.ownerTextField.text,
                                         success: { (newDog) in
                                            // On success, let's inform our delegate!
                                            self.delegate?.savedNewDogModel(newDog)
                                            dismissalBlock()
        }, failure: {
            self.activityIndicator.stopAnimating()
            dismissalBlock()
        })
    }
}

// MARK: - UINavigationControllerDelegate Methods
// MARK: - UIImagePickerControllerDelegate Methods

extension PHAddDogViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            dismiss(animated: true) {
                // After the user has chosen a photo, force them to crop it to a 16x9 aspect ratio
                let cropViewController = CropViewController(image: chosenImage)
                cropViewController.aspectRatioPreset = .preset16x9
                cropViewController.resetAspectRatioEnabled = false
                cropViewController.aspectRatioLockEnabled = true
                cropViewController.delegate = self
                self.present(cropViewController, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - CropViewControllerDelegate Methods

extension PHAddDogViewController: CropViewControllerDelegate {
    func cropViewController(_ cropViewController: CropViewController,
                            didCropToImage image: UIImage,
                            withRect cropRect: CGRect,
                            angle: Int) {
        self.dogImageView.image = image
        dismiss(animated: true, completion: nil)
    }
}

