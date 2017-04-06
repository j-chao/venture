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
    var tripDateString:String!

    @IBOutlet weak var tripDateTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tripDateString = stringLongFromDate(date: tripDate)
        tripDateTitle.text = self.tripDateString
        
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
        
        let ref = FIRDatabase.database().reference().child("users/\(userID)/trips/\(passedTrip)/\(tripDateString)")
        
        ref.queryOrderedByKey().observe(.childAdded, with: { snapshot in
            let eventDesc = (snapshot.value as! NSDictionary)["eventDesc"] as! String
            self.events.append(eventDesc)
            self.eventsTableView.reloadData()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddEvent" {
            if let destinationVC = segue.destination as? AddEventVC {
                destinationVC.eventDate = tripDate
            }
        }
    }
    
    @IBOutlet weak var eventsTableView: UITableView!
    var events = [String]()
}


extension ItineraryVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
//    var time:String? = nil
//    var desc:String? = nil
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell") as! ItineraryCellVC
        
        let ref = FIRDatabase.database().reference().child("users/\(userID)/trips/\(passedTrip)/\(tripDateString)")
       
        
        ref.child("\(events[indexPath.row])").observe(.value, with: { snapshot in
            let time = (snapshot.value as! NSDictionary) ["eventTime"] as! String!
            let desc = (snapshot.value as! NSDictionary) ["eventDesc"] as! String!
            cell.textLabel!.text = time! + "   - \t" + desc!
        })
        
        return cell
    }
    
    func tableView(_ didSelectRowAttableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // cell selected code here
//        performSegue(withIdentifier: "WebSegue", sender: indexPath)
//        eventsTableView.deselectRow(at: indexPath, animated: true)
    }
    
}
