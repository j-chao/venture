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

struct tripStruct {
    let tripName: String!
    let tripLocation: String!
    let startDate: String!
    let endDate: String!
}

class TripsVC: UIViewController {
    
    var trips = [String]()
    
    var ref:FIRDatabaseReference?
    var refHandle:FIRDatabaseHandle?
    let userID = FIRAuth.auth()?.currentUser?.uid
    
//    var tripCount:Int = 0
    

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
            if let destinationVC = segue.destination as? TripPageVC {
                destinationVC.tripsIdn = trips[tripIndex!]
            }
        }
    }
    

}


// MARK:- UICollectionViewDataSource Delegate
extension TripsVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
//        return tripCount
        return trips.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:TripCellVC = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! TripCellVC
       
        let trip = trips[indexPath.row]
        
        cell.tripName!.text = trip
//        cell.tripLocation!.text = trip.tripLocation
//        cell.dates!.text = "\(trip.startDate) - \(trip.endDate)"
        
        return cell
    }
    
}

