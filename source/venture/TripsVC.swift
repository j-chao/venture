//
//  TripsVC.swift
//  venture
//
//  Created by Justin Chao on 3/18/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class TripsVC: UIViewController {
    
    var trips = [NSManagedObject]()

    @IBOutlet weak var collectionView: UICollectionView!
    
    let identifier = "tripCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Your Trips"
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Trip")
        request.returnsObjectsAsFaults = false
        var fetchedResults:[NSManagedObject]? = nil
       
        do {
            try fetchedResults = context.fetch(request) as? [NSManagedObject]
        }
        catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        if let results = fetchedResults {
            trips = results
        }
        else {
            print ("error fetching results")
        }
    }
   
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "specItinerary" {
            if let collectionCell: TripCellVC = sender as? TripCellVC {
                if let destination = segue.destination as? TripPageVC {
                    // Pass some data to YourViewController
                    // collectionView.tag will give your selected tableView index
                    destination.tripsIdn = collectionCell.tripName.text
                    print (collectionCell.tag)
                }
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
        let tripName = trip.value(forKey: "tripName") as! String
        let tripLocation = trip.value(forKey: "tripLocation") as! String
        
        let startDate = trip.value(forKey: "startDate") as! Date
        let endDate = trip.value(forKey: "endDate") as! Date
        
        cell.tripName!.text = tripName
        cell.tripLocation!.text = tripLocation
        
        cell.dates!.text = "\(dateToString(startDate))  -  \(dateToString(endDate))"
        
        return cell
    }
    
    func dateToString(_ sender: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-YYYY"
        return dateFormatter.string(from: sender)
    }
}
