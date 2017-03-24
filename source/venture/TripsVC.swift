//
//  TripsVC.swift
//  venture
//
//  Created by Justin Chao on 3/18/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class TripsVC: UIViewController {
    var trips = [String]()
    
    var ref:FIRDatabaseReference?
    let userID = FIRAuth.auth()?.currentUser?.uid

    @IBOutlet weak var collectionView: UICollectionView!
    let identifier = "tripCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Your Trips"
        collectionView.dataSource = self
        
        let ref = FIRDatabase.database().reference().child("users/\(userID)")
        ref.child("trips").queryOrderedByKey().observe(.childAdded, with: { snapshot in
            
            let tripName = (snapshot.value as! NSDictionary)["tripName"] as! String
            self.trips.append(tripName)
            self.collectionView.reloadData()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tripIndex = collectionView.indexPathsForSelectedItems?.last?.last
        if segue.identifier == "specItinerary" {
            if segue.destination is TripPageVC {
                let ref = FIRDatabase.database().reference().child("users/\(userID)/trips/")
                
                ref.child(trips[tripIndex!]).observe(.value, with: { snapshot in
                    let startDate = (snapshot.value as! NSDictionary)["startDate"] as! String
                    let endDate = (snapshot.value as! NSDictionary)["endDate"] as! String
                    
                    let start = dateFromString(dateString:startDate)
                    let end = dateFromString(dateString:endDate)
                    let days = calculateDays(start: start, end: end) + 1
                    tripLength = days
                    passedTrip = self.trips[tripIndex!]
                    passedStart = startDate
                })
            }
        }
    }

}


// MARK:- UICollectionViewDataSource Delegate
extension TripsVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trips.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:TripCellVC = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! TripCellVC
       
        let trip = trips[indexPath.row]
        let ref = FIRDatabase.database().reference().child("users/\(userID)/trips/")
        
        ref.child(trip).observe(.value, with: { snapshot in
            let tripName = (snapshot.value as! NSDictionary) ["tripName"] as! String
            let tripLocation = (snapshot.value as! NSDictionary) ["tripLocation"] as! String
            let startDate = (snapshot.value as! NSDictionary) ["startDate"] as! String
            let endDate = (snapshot.value as! NSDictionary) ["endDate"] as! String
            
            cell.tripName!.text = tripName
        cell.tripLocation!.text = tripLocation
        cell.dates!.text = "\(startDate)  -  \(endDate)"
        })
       
        
        return cell
    }
    
}

