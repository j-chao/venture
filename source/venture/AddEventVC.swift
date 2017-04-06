//
//  AddEventVC.swift
//  venture
//
//  Created by Justin Chao on 3/24/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import UIKit
import Firebase

class AddEventVC: UIViewController {
    
    var ref: FIRDatabaseReference! = FIRDatabase.database().reference()
    let userID = FIRAuth.auth()?.currentUser?.uid
    
    @IBOutlet weak var eventDesc: UITextField!
    @IBOutlet weak var eventLoc: UITextField!
    @IBOutlet weak var eventTime: UIDatePicker!
    @IBOutlet weak var eventDateLbl: UILabel!
    
    var eventDate:Date!
    var eventDateStr:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventDesc.attributedPlaceholder = NSAttributedString(string: "event description", attributes: [NSForegroundColorAttributeName:UIColor.lightGray])
        eventLoc.attributedPlaceholder = NSAttributedString(string: "event location", attributes: [NSForegroundColorAttributeName:UIColor.lightGray])
       
        let dateTitle = stringLongFromDate(date: eventDate)
        self.eventDateStr = dateTitle
        self.eventDateLbl.text = dateTitle
        
    }
   
    
    @IBAction func addEventButton(_ sender: Any) {
        if eventDesc.text!.isEmpty || eventLoc.text!.isEmpty {
            let alert = UIAlertController(title: "Error", message: "Please fill out all fields." , preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                (action:UIAlertAction) in
            }
            alert.addAction(OKAction)
            self.present(alert, animated: true, completion:nil)
            return
        }
        else {
            let eventTimeStr = stringTimefromDate(date: eventTime.date)
            self.addEvent(eventDesc:eventDesc.text!, eventLoc:eventLoc.text!, eventTime:eventTimeStr)
        }
    }
        
    func addEvent (eventDesc:String, eventLoc:String, eventTime:String) {
        let eventRef = self.ref.child("users/\(self.userID)/trips/\(passedTrip)/\(self.eventDateStr)/\(eventDesc)")
        
        eventRef.child("eventDesc").setValue(eventDesc)
        eventRef.child("eventLoc").setValue(eventLoc)
        eventRef.child("eventTime").setValue(eventTime)
        
    }

//    var eventNum = 0
//    func getEventNum() {
//        ref.child("users/\(userID)/trips/\(passedTrip)/\(self.eventDateStr)").queryOrderedByKey().observe(.value, with: { snapshot in
//            self.eventNum = (snapshot.value )["eventNum"] as! String
//        })
//    }
    
   
    
    
    
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
