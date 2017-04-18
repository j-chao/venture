//
//  NewTripVC.swift
//  venture
//
//  Created by Justin Chao on 3/18/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import UIKit
import Firebase

class NewTripVC: UIViewController, UITextFieldDelegate {
    
    var ref: FIRDatabaseReference! = FIRDatabase.database().reference()
    let userID = FIRAuth.auth()?.currentUser!.uid

    @IBOutlet weak var tripName: UITextField!
    @IBOutlet weak var tripLocation: UITextField!
    @IBOutlet weak var datePick: UIDatePicker!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    
    override func viewDidLoad() {
        self.setBackground()
        super.viewDidLoad()
        tripName.attributedPlaceholder = NSAttributedString(string: "trip name", attributes: [NSForegroundColorAttributeName:UIColor.lightGray])
        tripLocation.attributedPlaceholder = NSAttributedString(string: "location", attributes: [NSForegroundColorAttributeName:UIColor.lightGray])
        tripName.delegate = self
        tripLocation.delegate = self
    }
    
    var startingDate:Date? = nil
    var endingDate:Date? = nil

    @IBAction func setStart(_ sender: Any) {
        startingDate = datePick.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YYYY"
        self.startDate.text = dateFormatter.string(from: datePick.date)
    }
    
    @IBAction func setEnd(_ sender: Any) {
        endingDate = datePick.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YYYY"
        self.endDate.text = dateFormatter.string(from: datePick.date)
    }
    
    @IBAction func createTrip(_ sender: Any) {
        if tripName.text!.isEmpty || tripLocation.text!.isEmpty || startDate.text!.isEmpty || endDate.text!.isEmpty {
            let alert = UIAlertController(title: "Error", message: "You must enter a value for all fields." , preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                (action:UIAlertAction) in
            }
            alert.addAction(OKAction)
            self.present(alert, animated: true, completion:nil)
            return
        }
        
        else if endingDate! < startingDate! {
            let alert = UIAlertController(title: "Error", message: "End date must not be earlier than start date." , preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                (action:UIAlertAction) in
            }
            alert.addAction(OKAction)
            self.present(alert, animated: true, completion:nil)
            return
        }
        
        self.addTrip(tripName:tripName.text!, tripLocation:tripLocation.text!, startDate:startDate.text!, endDate:endDate.text!, totalBudget:"0", foodBudget:"0", placesBudget:"0", otherBudget:"0")
        
        let storyboard: UIStoryboard = UIStoryboard(name: "trip", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "tripNavCtrl")
        self.show(vc, sender: self)
    }
    
    func addTrip (tripName:String, tripLocation:String, startDate:String, endDate:String, totalBudget:String, foodBudget:String, placesBudget:String, otherBudget:String) {
        let tripRef = ref.child("users/\(userID!)/trips/\(tripName)")
        
        tripRef.child("tripName").setValue(tripName)
        tripRef.child("tripLocation").setValue(tripLocation)
        tripRef.child("startDate").setValue(startDate)
        tripRef.child("endDate").setValue(endDate)
        
        // adding default budget values
        let tripBudgetRef = ref.child("users/\(userID!)/budgets/\(tripName)")
        tripBudgetRef.child("totalBudget").setValue(totalBudget)
        tripBudgetRef.child("foodBudget").setValue(foodBudget)
        tripBudgetRef.child("placesBudget").setValue(placesBudget)
        tripBudgetRef.child("otherBudget").setValue(otherBudget)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
