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
        
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddEvent" {
            if let destinationVC = segue.destination as? AddEventVC {
                destinationVC.eventDate = tripDate
            }
        }
    }
    
    @IBOutlet weak var eventsTableView: UITableView!
}


extension ItineraryVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5 // your number of cell here
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell") as! ItineraryCellVC
        
        return cell
    }
    
    func tableView(_ didSelectRowAttableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // cell selected code here
    }
    
    
}
