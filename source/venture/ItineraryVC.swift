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
    var events = [String]()
    
    @IBOutlet weak var tripDateTitle: UILabel!
    @IBOutlet weak var flightBtn: UIButton!
    @IBOutlet weak var foodBtn: UIButton!
    @IBOutlet weak var placesBtn: UIButton!
    @IBOutlet weak var eventAddBtn: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var darkFillView: DesignableView!
    @IBOutlet weak var toggleMenuBtn: UIButton!
    @IBOutlet weak var eventsTableView: UITableView!
   
    override func viewDidLoad() {
        self.eventsTableView.backgroundColor = UIColor.clear
        self.setBackground()
        super.viewDidLoad()
        self.tripDateString = stringLongFromDate(date: tripDate)
        tripDateTitle.text = self.tripDateString
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
        
        let ref = FIRDatabase.database().reference().child("users/\(userID!)/trips/\(passedTrip)/\(tripDateString!)")
        ref.queryOrderedByKey().observe(.childAdded, with: { snapshot in
            let eventTime = (snapshot.value as! NSDictionary)["eventTime"] as! String
            self.events.append(eventTime)
            self.events.sort()
            self.eventsTableView.reloadData()
        })
        
        self.eventAddBtn.alpha = 1
        self.flightBtn.alpha = 1
        self.foodBtn.alpha = 1
        self.placesBtn.alpha = 1
    }
    
    
    @IBAction func editAction(_ sender: UIButton) {
        if (self.eventsTableView.isEditing) {
            self.editButton.titleLabel?.text = "Edit"
            self.eventsTableView.setEditing(false, animated: true)
        } else {
            self.editButton.titleLabel?.text = "Done"
            self.eventsTableView.setEditing(true, animated: true)
        }
    }

    @IBAction func toggleMenu(_ sender: Any) {
        if darkFillView.transform == CGAffineTransform.identity {
            UIView.animate(withDuration: 1, animations: {
                self.darkFillView.transform = CGAffineTransform(scaleX: 12, y: 12)
                self.menuView.transform = CGAffineTransform(translationX: 0, y: -55)
                self.toggleMenuBtn.transform = CGAffineTransform(rotationAngle: self.radians(180))
            }, completion: nil)
            UIView.animate(withDuration: 0.5, animations: {
//                self.toggleMenuButtons()
            })
        } else {
            UIView.animate(withDuration: 1, animations: {
                self.darkFillView.transform = .identity
                self.menuView.transform = .identity
                self.toggleMenuBtn.transform = .identity
//                self.toggleMenuButtons()
            })
        }
    }
    
    func radians (_ degrees: Double) -> CGFloat {
        return CGFloat(degrees * .pi / degrees)
    }
    
    func toggleMenuButtons() {
        let alpha = CGFloat(eventAddBtn.alpha == 0 ? 1 : 0)
        eventAddBtn.alpha = alpha
        flightBtn.alpha = alpha
        foodBtn.alpha = alpha
        placesBtn.alpha = alpha
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddEvent" {
            if let destinationVC = segue.destination as? AddEventVC {
                destinationVC.eventDate = tripDate
            }
        } else if segue.identifier == "toEventDetails" {
            if let destinationVC = segue.destination as? EventDetailsVC {
                let indexPath = self.eventsTableView.indexPathForSelectedRow
                destinationVC.date = self.tripDateString
                destinationVC.event = events[(indexPath?.row)!]
                eventsTableView.deselectRow(at: indexPath!, animated: true)
            }
        }
    }

}

extension ItineraryVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell") as! ItineraryCellVC
        
        let ref = FIRDatabase.database().reference().child("users/\(userID!)/trips/\(passedTrip)/\(tripDateString!)")
      
        ref.child("\(self.events[indexPath.row])").observe(.value, with: { snapshot in
            if snapshot.exists() {
                let timeRec = (snapshot.value as? NSDictionary)? ["eventTime"] as! String!
                let desc = (snapshot.value as? NSDictionary)? ["eventDesc"] as! String!
                let timeDate = timeFromStringTime(timeStr: timeRec!)
                let timeDisplay = stringTimefromDate(date: timeDate)
                cell.textLabel!.text = timeDisplay + "   - \t" + desc!
            }
        })
        cell.backgroundColor = UIColor.clear
        return cell
    }
  
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if tableView.isEditing {
            return .delete
        }
        return .none
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            _ = deleteEventFromFirebase(event: events[indexPath.row])
            events.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func deleteEventFromFirebase(event:String) -> Int {
        let userID = FIRAuth.auth()?.currentUser!.uid
        let ref = FIRDatabase.database().reference().child("users/\(userID!)/trips/\(passedTrip)/\(tripDateString!)")
        ref.child(event).removeValue()
        return 0
    }
    
}
