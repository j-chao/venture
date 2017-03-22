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
    var refHandle:FIRDatabaseHandle?
    let userID = FIRAuth.auth()?.currentUser?.uid
    
    var tripName:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print (self.tripName)
        let ref = FIRDatabase.database().reference().child("users/\(userID)/trips/")
        print (ref)
        
        ref.child(self.tripName).observe(.value, with: { snapshot in
            let tripTitle = (snapshot.value as! NSDictionary)["tripLocation"] as! String
            print (tripTitle)
        })
    }


}
