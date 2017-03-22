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

class TripsVC: UIViewController, CalculateTime {
    var trips = [String]()
    
    var ref:FIRDatabaseReference?
    var refHandle:FIRDatabaseHandle?
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
            if let destinationVC = segue.destination as? TripPageVC {
                
                let ref = FIRDatabase.database().reference().child("users/\(userID)/trips/")
                
                ref.child(trips[tripIndex!]).observe(.value, with: { snapshot in
                    let startDate = (snapshot.value as! NSDictionary)["startDate"] as! String
                    let endDate = (snapshot.value as! NSDictionary)["endDate"] as! String
                    
                    let start = self.dateFromString(dateString:startDate)
                    let end = self.dateFromString(dateString:endDate)
                    let days = self.calculateDays(start: start, end: end) + 1
                    tripLength = days
                })
                destinationVC.tripName = trips[tripIndex!]
            }
        }
    }
    
    internal func dateFromString (dateString:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateFormatter.locale = Locale(identifier: "en_US")
        let dateObj = dateFormatter.date(from: dateString)
        return (dateObj)!
    }
    
    internal func calculateDays(start: Date, end: Date) -> Int {
        let currentCalendar = Calendar.current
        guard let start = currentCalendar.ordinality(of: .day, in: .era, for: start) else {
            return 0
        }
        guard let end = currentCalendar.ordinality(of: .day, in: .era, for: end) else {
            return 0
        }
        return (end - start)
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
        
        cell.tripName!.text = trip
//        cell.tripLocation!.text = trip.tripLocation
//        cell.dates!.text = "\(trip.startDate) - \(trip.endDate)"
        
        return cell
    }
    
}

