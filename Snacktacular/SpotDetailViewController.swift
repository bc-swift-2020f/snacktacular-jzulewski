//
//  SpotDetailViewController.swift
//  Snacktacular
//
//  Created by John Zulewski on 11/2/20.
import UIKit

class SpotDetailViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var ratingLabel: UILabel!
    
    var spot: Spot!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if spot == nil {
            spot = Spot()
        }
    }
    
    func updateUserInterface() {
        nameField.text = spot.name
        addressTextField.text = spot.address
    }
    
    func updateFromInterface() {
        spot.name = nameField.text!
        spot.address = addressTextField.text!
    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        updateUserInterface()
        spot.saveData { (success) in
            if success {
                self.leaveViewController()
            } else {
                self.oneButtonAlert(title: "Save Failed", message: "For some reason, the data would not save to the cloud")
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
    

}
