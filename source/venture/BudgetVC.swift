//
//  BudgetVC.swift
//  venture
//
//  Created by Justin Chao on 4/18/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import UIKit
import Firebase

class BudgetVC: UIViewController {
    let userID = FIRAuth.auth()?.currentUser!.uid
    let myRequest = DispatchGroup()
    
    var totalBudget:String?
    var foodBudget:String?
    var placesBudget:String?
    var otherBudget:String?

    @IBOutlet weak var totalBudgetField: UITextField!
    @IBOutlet weak var foodBudgetField: UITextField!
    @IBOutlet weak var placesBudgetField: UITextField!
    @IBOutlet weak var otherBudgetField: UITextField!
    
    override func viewDidLoad() {
        myRequest.enter()
        self.setBackground()
        super.viewDidLoad()
       
        self.observeDataFromFirebase()
    
        myRequest.notify(queue: DispatchQueue.main, execute: {
            self.totalBudgetField.text = self.totalBudget!
            self.foodBudgetField.text = self.foodBudget!
            self.placesBudgetField.text = self.placesBudget!
            self.otherBudgetField.text = self.otherBudget!
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.saveDataToFirebase()
    }

    func saveDataToFirebase() {
        if (totalBudgetField.text?.isEmpty)! || (foodBudgetField.text?.isEmpty)! || (placesBudgetField.text?.isEmpty)! || (otherBudgetField.text?.isEmpty)! {
            
            self.presentAllFieldsAlert()
        } else {
            let ref = FIRDatabase.database().reference().child("users/\(userID!)/budgets/\(passedTrip)")
            ref.child("totalBudget").setValue(totalBudgetField.text)
            ref.child("foodBudget").setValue(foodBudgetField.text)
            ref.child("placesBudget").setValue(placesBudgetField.text)
            ref.child("otherBudget").setValue(otherBudgetField.text)
        }
    }

    
    func observeDataFromFirebase() {
        let ref = FIRDatabase.database().reference().child("users/\(userID!)/budgets/\(passedTrip)")
        ref.observeSingleEvent(of:.value, with: { snapshot in
            if snapshot.exists() {
                self.totalBudget = (snapshot.value as! NSDictionary) ["totalBudget"] as? String
                self.foodBudget = (snapshot.value as! NSDictionary) ["foodBudget"] as? String
                self.placesBudget = (snapshot.value as! NSDictionary) ["placesBudget"] as? String
                self.otherBudget = (snapshot.value as! NSDictionary) ["otherBudget"] as? String
                self.myRequest.leave()
            }
        })
    }
    
    func presentAllFieldsAlert() {
        let alert = UIAlertController(title: "Error", message: "Please fill out all fields." , preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            (action:UIAlertAction) in
        }
        alert.addAction(OKAction)
        self.present(alert, animated: true, completion:nil)
        return
    }
}
