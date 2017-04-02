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
        let tripDateString = stringLongFromDate(date: tripDate)
        tripDateTitle.text = tripDateString
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddEvent" {
            if let destinationVC = segue.destination as? AddEventVC {
                destinationVC.eventDate = tripDate
            }
        }
    }
    
}


class ItineraryTable: UITableView {
    
    override func numberOfRows(inSection section: Int) -> Int {
        return 2
    }
    
    
}
