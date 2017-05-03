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
    
    var food:String?
    var transportation:String?
    var lodging:String?
    var attractions:String?
    var misc:String?
    var total:String?
    
    @IBOutlet weak var foodField: UITextField!
    @IBOutlet weak var transportationField: UITextField!
    @IBOutlet weak var lodgingField: UITextField!
    @IBOutlet weak var attractionsField: UITextField!
    @IBOutlet weak var miscField: UITextField!
    @IBOutlet weak var totalField: UILabel!
    
    override func viewDidLoad() {
        myRequest.enter()
        self.setBackground()
        super.viewDidLoad()
       
        self.observeDataFromFirebase()
    
        myRequest.notify(queue: DispatchQueue.main, execute: {
            self.foodField.text = self.food!
            self.transportationField.text = self.transportation!
            self.lodgingField.text = self.lodging!
            self.attractionsField.text = self.attractions!
            self.miscField.text = self.misc!
            self.totalField.text = "$" + String(Int(self.food!)! + Int(self.transportation!)! + Int(self.lodging!)! + Int(self.attractions!)! + Int(self.misc!)!)
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.saveDataToFirebase()
    }

    func saveDataToFirebase() {
        if (foodField.text?.isEmpty)! || (transportationField.text?.isEmpty)! || (lodgingField.text?.isEmpty)! || (attractionsField.text?.isEmpty)! || (miscField.text?.isEmpty)! || (totalField.text?.isEmpty)! {
            self.presentAllFieldsAlert()
        } else {
            let ref = FIRDatabase.database().reference().child("users/\(userID!)/budgets/\(passedTrip)")
            ref.child("food").setValue(foodField.text)
            ref.child("transportation").setValue(transportationField.text)
            ref.child("lodging").setValue(lodgingField.text)
            ref.child("attractions").setValue(attractionsField.text)
            ref.child("misc").setValue(miscField.text)
            ref.child("total").setValue(totalField.text)
        }
    }
    
    func observeDataFromFirebase() {
        let ref = FIRDatabase.database().reference().child("users/\(userID!)/budgets/\(passedTrip)")
        ref.observeSingleEvent(of:.value, with: { snapshot in
            if snapshot.exists() {
                self.food = (snapshot.value as! NSDictionary) ["food"] as? String
                self.transportation = (snapshot.value as! NSDictionary) ["transportation"] as? String
                self.lodging = (snapshot.value as! NSDictionary) ["lodging"] as? String
                self.attractions = (snapshot.value as! NSDictionary) ["attractions"] as? String
                self.misc = (snapshot.value as! NSDictionary) ["misc"] as? String
                self.total = (snapshot.value as! NSDictionary) ["total"] as? String
                self.myRequest.leave()
            }
        })
    }
    
    @IBAction func percentagesBtn(_ sender: Any) {
        let foodAmt = Int(self.foodField.text!)!
        let transportAmt = Int(self.transportationField.text!)!
        let lodgingAmt = Int(self.lodgingField.text!)!
        let attractionsAmt = Int(self.attractionsField.text!)!
        let miscAmt = Int(self.miscField.text!)!
        let totalAmt = foodAmt + transportAmt + lodgingAmt + attractionsAmt + miscAmt
        self.totalField.text = "$" + "\(totalAmt)"
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
