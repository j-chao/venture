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
    let userID = FIRAuth.auth()?.currentUser!.uid
    
    var tripName:String!
    var tripDate:Date!
    var tripDateString:String!

    @IBOutlet weak var tripDateTitle: UILabel!
   
    override func viewDidLoad() {
        self.eventsTableView.backgroundColor = UIColor.clear
        self.setBackground()
        super.viewDidLoad()
        self.tripDateString = stringLongFromDate(date: tripDate)
        tripDateTitle.text = self.tripDateString
       
        self.title = tripDateString
        
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
        
        let ref = FIRDatabase.database().reference().child("users/\(userID!)/trips/\(passedTrip)/\(tripDateString!)")
        
        
        ref.queryOrderedByKey().observe(.childAdded, with: { snapshot in
            let eventTime = (snapshot.value as! NSDictionary)["eventTime"] as! String
            self.events.append(eventTime)
            self.events.sort()
            self.eventsTableView.reloadData()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddEvent" {
            if let destinationVC = segue.destination as? AddEventVC {
                destinationVC.eventDate = tripDate
            }
        }
        
        else if segue.identifier == "toEventDetails" {
            if let destinationVC = segue.destination as? EventDetailsVC {
                let indexPath = self.eventsTableView.indexPathForSelectedRow
                
                destinationVC.date = self.tripDateString
                destinationVC.event = events[(indexPath?.row)!]
                
                eventsTableView.deselectRow(at: indexPath!, animated: true)
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell") as! ItineraryCellVC
        
        let ref = FIRDatabase.database().reference().child("users/\(userID!)/trips/\(passedTrip)/\(tripDateString!)")
      
        
        ref.child("\(self.events[indexPath.row])").observe(.value, with: { snapshot in
            
            let timeRec = (snapshot.value as? NSDictionary)? ["eventTime"] as! String!
            let desc = (snapshot.value as? NSDictionary)? ["eventDesc"] as! String!
           
            let timeDate = timeFromStringTime(timeStr: timeRec!)
            let timeDisplay = stringTimefromDate(date: timeDate)
            
            cell.textLabel!.text = timeDisplay + "   - \t" + desc!
        })
       
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            
//            let ref = FIRDatabase.database().reference().child("users/\(userID!)/trips/\(passedTrip)/\(tripDateString!)")
//            
//            ref.child("\(events[indexPath.row])").removeValue()
//            
//            events.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//            
//        }
//        
//    }
    
    
}
