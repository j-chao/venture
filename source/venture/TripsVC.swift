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
//import CoreData

struct tripStruct {
    let tripName: String!
    let tripLocation: String!
    let startDate: String!
    let endDate: String!
}

class TripsVC: UIViewController {
    
    var trips = [tripStruct]()
    
    var ref:FIRDatabaseReference?
    var refHandle:FIRDatabaseHandle?
    let userID = FIRAuth.auth()?.currentUser?.uid
    
    var tripCount:Int = 0
    

    @IBOutlet weak var collectionView: UICollectionView!
    let identifier = "tripCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Your Trips"
        collectionView.dataSource = self
        
        
        let ref = FIRDatabase.database().reference().child("users/\(userID)")
        
//        refHandle = refi.queryOrderedByKey().observe(.childAdded, with: { snapshot in
//            
//            let tripName = snapshot..value!["tripName"]
//            self.trips.append(tripName)
//            
//            
//            self.collectionView.reloadData()
//        
//        })
        
        ref.child("trips").queryOrderedByKey().observe(.childAdded, with: { snapshot in
            
            let tripName = (snapshot.value as! NSDictionary)["tripName"] as! String
            let tripLocation = (snapshot.value as! NSDictionary)["tripLocation"] as! String
            let startDate = (snapshot.value as! NSDictionary)["startDate"] as! String
            let endDate = (snapshot.value as! NSDictionary)["startDate"] as! String
           
            self.trips.insert(tripStruct(tripName: tripName, tripLocation:tripLocation, startDate:startDate, endDate:endDate), at: 0)
            self.collectionView.reloadData()
            
        })
        
//        postTrip()
        
        refHandle = ref.observe(.value, with: { (snapshot) in
            let count = snapshot.childrenCount
            self.tripCount = Int(count)
        })
        
    }

//    func postTrip () {
//        let tripName = "tripName"
//        let tripLocation = "tripLocation"
//        let startDate = "startDate"
//        let endDate = "endDate"
//        
//        let trip:[String:Any] = ["tripName" : tripName,
//                                 "tripLocation": tripLocation,
//                                 "startDate": startDate,
//                                 "endDate": endDate]
//        
//        let ref = FIRDatabase.database().reference()
//        ref.child("trips").childByAutoId().setValue(trip)
//    }

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
        
        cell.tripName!.text = trip.tripName
        cell.tripLocation!.text = trip.tripLocation
        cell.dates!.text = "\(trip.startDate) - \(trip.endDate)"
        
        return cell
    }
    
}

extension UInt {
    /// SwiftExtensionKit
    var toInt: Int { return Int(self) }
}
