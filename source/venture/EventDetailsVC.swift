//
//  EventDetailsVC.swift
//  venture
//
//  Created by Justin Chao on 4/6/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import UIKit
import Firebase

class EventDetailsVC: UIViewController {
    
    var ref:FIRDatabaseReference?
    let userID = FIRAuth.auth()?.currentUser?.uid
  
    var date:String!
    var event:String!

    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventDesc: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ref = FIRDatabase.database().reference().child("users/\(userID!)/trips/\(passedTrip)/\(date!)")
        
        ref.child(event).observe(.value, with: { snapshot in
            
            var descChosen:String?
            var timeChosen:String?
            
            let desc = (snapshot.value as? NSDictionary)?["eventDesc"]
            let timeRec = (snapshot.value as? NSDictionary)?["eventTime"]
            
            if desc == nil || timeRec == nil {
                descChosen = "nope"
                timeChosen = "nope"
            }
            else {
                descChosen = desc as! String?
                timeChosen = timeRec as! String?
            }
            
            self.eventDate.text = self.date
            self.eventTime.text = timeChosen as String?
            self.eventDesc.text = descChosen
        })
        
    }

}
