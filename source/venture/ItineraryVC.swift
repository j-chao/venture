//
//  ItineraryVC.swift
//  venture
//
//  Created by Justin Chao on 3/19/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import UIKit
import Firebase

class ItineraryVC: UIViewController {
    var ref:FIRDatabaseReference?
    let userID = FIRAuth.auth()?.currentUser?.uid
    
    var tripName:String!
    var tripDate:Date!

    @IBOutlet weak var tripDateTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tripDateString = stringFromDate(date: tripDate)
        tripDateTitle.text = tripDateString
        
//        let ref = FIRDatabase.database().reference().child("users/\(userID)/trips/")
        
//        ref.child(passedTrip).observe(.value, with: { snapshot in
//            let tripTitle = (snapshot.value as! NSDictionary)["tripName"] as! String
//            self.title = tripTitle
//        })
    }


}
