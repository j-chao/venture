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
    var eventDescStr:String!
    var eventLocStr:String!
    var fromFoodorPlace:Bool!
    var fromFlight:Bool!
    var flightTime:Date?
    
    override func viewDidLoad() {
        self.setBackground()
        super.viewDidLoad()
        eventTime.backgroundColor = .white
        eventTime.setValue(0.8, forKeyPath: "alpha")
        eventDesc.attributedPlaceholder = NSAttributedString(string: "event description", attributes: [NSForegroundColorAttributeName:UIColor.lightGray])
        eventLoc.attributedPlaceholder = NSAttributedString(string: "event address", attributes: [NSForegroundColorAttributeName:UIColor.lightGray])
       
        let dateTitle = stringLongFromDate(date: eventDate)
        self.eventDateStr = dateTitle
        self.eventDateLbl.text = dateTitle
        
        if fromFoodorPlace == true {
            eventDesc.text = eventDescStr
            eventLoc.text = eventLocStr
        } else if fromFlight == true {
            eventDesc.text = eventDescStr
            let code = eventLocStr!
            eventLoc.text = self.airportAddress(code: code)
            eventTime.date = flightTime!
        }
    }
    
    func airportAddress(code:String) -> String {
        if code == "DFW " {
            return "2400 Aviation Dr, DFW Airport, TX 75261"
        } else if code == "JFK " {
            return "Queens, NY 11430"
        } else if code == "ORD " {
            return "10000 W O'Hare Ave, Chicago, IL 60666"
        } else if code == "SFO " {
            return "San Francisco, CA 94128"
        } else if code == "LAX " {
            return "1 World Way, Los Angeles, CA 90045"
        } else {
            return code + "(airport address not supported)"
        }
    }
    
    @IBAction func addEventButton(_ sender: Any) {
        if eventDesc.text!.isEmpty || eventLoc.text!.isEmpty {
            self.presentAllFieldsAlert()
        } else {
            let eventTimeStr = stringTimefromDateToFIR(date: eventTime.date)
            self.addEvent(eventDesc:eventDesc.text!, eventLoc:eventLoc.text!, eventTime:eventTimeStr)
            
            for vc in self.navigationController!.viewControllers as Array {
                if vc .isKind(of: TripPageVC.self) {
                    self.navigationController!.popToViewController(vc, animated: true)
                    break
                }
            }
        }
    }
    
    func addEvent (eventDesc:String, eventLoc:String, eventTime:String) {
        let eventRef = self.ref.child("users/\(self.userID!)/trips/\(passedTrip)/\(self.eventDateStr!)/\(eventTime)")
        
        eventRef.child("eventTime").setValue(eventTime)
        eventRef.child("eventDesc").setValue(eventDesc)
        eventRef.child("eventLoc").setValue(eventLoc)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
