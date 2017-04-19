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
    let userID = FIRAuth.auth()?.currentUser!.uid

    @IBOutlet weak var collectionView: UICollectionView!
    fileprivate var activeCell : TripCellVC!
    
    let identifier = "tripCell"
    
    override func viewDidLoad() {
        self.collectionView.backgroundColor = UIColor.clear
        self.setBackground()
        super.viewDidLoad()
        self.title = "Your Trips"
        collectionView.dataSource = self
        
        let ref = FIRDatabase.database().reference().child("users/\(userID!)")
        ref.child("trips").queryOrderedByKey().observe(.childAdded, with: { snapshot in
            let tripName = (snapshot.value as! NSDictionary)["tripName"] as! String
            self.trips.append(tripName)
            self.collectionView.reloadData()
        })
        setupSwipes()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toItinerary" {
            if let destinationVC = segue.destination as? TripPageVC {
                let cell = sender as! TripCellVC
                let indexPath = self.collectionView.indexPath(for: cell)
                
                let startDate = cell.startDate
                let endDate = cell.endDate
                let start = dateFromString(dateString:startDate!)
                let end = dateFromString(dateString:endDate!)
                tripLength = calculateDays(start: start, end: end) + 1
                passedTrip = trips[(indexPath?.row)!]
                destinationVC.passedStart = startDate!
            }
        }
        
    }
    
    @IBOutlet var swipeDelete: UISwipeGestureRecognizer!
}

// MARK:- UICollectionViewDataSource Delegate
extension TripsVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trips.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:TripCellVC = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! TripCellVC
       
        let trip = trips[indexPath.row]
        let ref = FIRDatabase.database().reference().child("users/\(userID!)/trips/")
        
        ref.child(trip).observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.exists() {
                
                let tripName = (snapshot.value as! NSDictionary) ["tripName"] as! String
                let tripLocation = (snapshot.value as! NSDictionary) ["tripLocation"] as! String
                let startDate = (snapshot.value as! NSDictionary) ["startDate"] as! String
                let endDate = (snapshot.value as! NSDictionary) ["endDate"] as! String
                
                cell.tripName!.text = tripName
                cell.tripLocation!.text = tripLocation
                cell.startDate = startDate
                cell.endDate = endDate
                cell.dates!.text = "\(startDate)  -  \(endDate)"
            }
        })
        
        cell.backgroundColor = UIColor(white: 1, alpha: 0.8)
        return cell
    }
}


// MARK:- Swipe Delete Functionality
extension TripsVC: UICollectionViewDelegate {
    
    func setupSwipes() {
        let swipeRight: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(TripsVC.userDidSwipeRight))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(TripsVC.userDidSwipeLeft))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
    }
    
    
    func getCellAtPoint(_ point: CGPoint) -> TripCellVC? {
        // Function for getting item at point. Note optionals as it could be nil
        let indexPath = self.collectionView.indexPathForItem(at: point)
        var cell : TripCellVC?
        
        if indexPath != nil {
            cell = self.collectionView.cellForItem(at: indexPath!) as? TripCellVC
        } else {
            cell = nil
        }
        
        return cell
    }
    
    func userDidSwipeLeft(_ gesture : UISwipeGestureRecognizer){
        let point = gesture.location (in: self.collectionView)
        let duration = animationDuration()
        
        if (activeCell == nil) {
            
            activeCell = getCellAtPoint(point)
            
            if activeCell == nil {
                return
            }
            
            UIView.animate (withDuration: duration, animations: {
                self.activeCell.tripName.transform = CGAffineTransform(translationX: -self.activeCell.frame.width, y: 0)
                self.activeCell.tripLocation.transform = CGAffineTransform(translationX: -self.activeCell.frame.width, y: 0)
                self.activeCell.dates.transform = CGAffineTransform(translationX: -self.activeCell.frame.width, y: 0)
             });
            self.activeCell.backgroundColor = UIColor.red
            self.activeCell.deleteLabel.text = "Delete Trip? \n<< Yes \t\t\t No >>"

            
        } else {
            // Getting the cell at the point
            let cell = getCellAtPoint(point)
            
            // If the cell is the previously swiped cell, or nothing assume its the previously one.
            if cell == nil || cell == activeCell {
                // To target the cell after that animation I test if the point of the swiping exists inside the now twice as tall cell frame
                let cellFrame = activeCell.frame
                let rect = CGRect(x: cellFrame.origin.x, y: cellFrame.origin.y - cellFrame.height, width: cellFrame.width, height: cellFrame.height*2)
                if rect.contains(point) {
                    // If swipe point is in the cell delete it
                    
                    let indexPath = self.collectionView.indexPath(for: activeCell)
                    
                    _ = deleteTripFromFirebase(trip: trips[indexPath!.row])
                    
                    trips.remove(at: indexPath!.row)
                    self.collectionView.deleteItems(at: [indexPath!])
                }
                // If another cell is swiped
            } else if activeCell != cell {
                // It's not the same cell that is swiped, so the previously selected cell will get unswiped and the new swiped.
                UIView.animate(withDuration: duration, animations: {
                    self.activeCell.tripName.transform = CGAffineTransform.identity
                    self.activeCell.tripLocation.transform = CGAffineTransform.identity
                    self.activeCell.dates.transform = CGAffineTransform.identity
                    self.activeCell.backgroundColor = UIColor(white: 1, alpha: 0.8)
                    self.activeCell.deleteLabel.text = ""
                    
                    cell!.tripName.transform = CGAffineTransform(translationX: -cell!.frame.width, y: 0)
                    cell!.tripLocation.transform = CGAffineTransform(translationX: -cell!.frame.width, y: 0)
                    cell!.dates.transform = CGAffineTransform(translationX: -cell!.frame.width, y: 0)
                    cell!.backgroundColor = UIColor.red
                    cell!.deleteLabel.text = "Delete Trip? \n<< Yes \t\t\t No >>"
                }, completion: {
                    (Void) in
                    self.activeCell = cell
                })
            }
        }
    }
    
    func userDidSwipeRight(){
        // Revert back
        if(activeCell != nil){
            let duration = animationDuration()
            
            UIView.animate(withDuration: duration, animations: {
                self.activeCell.tripName.transform = CGAffineTransform.identity
                self.activeCell.tripLocation.transform = CGAffineTransform.identity
                self.activeCell.dates.transform = CGAffineTransform.identity
                self.activeCell.backgroundColor = UIColor(white: 1, alpha: 0.8)
                self.activeCell.deleteLabel.text = ""
                
            }, completion: {
                (Void) in
                self.activeCell = nil
            })
        }
    }
    
    func animationDuration() -> Double {
        return 0.5
    }
    
    func deleteTripFromFirebase(trip:String) -> Int {
        let userID = FIRAuth.auth()?.currentUser!.uid
        let ref = FIRDatabase.database().reference().child("users/\(userID!)/trips")
        ref.child(trip).removeValue()
        return 0
    }
}

