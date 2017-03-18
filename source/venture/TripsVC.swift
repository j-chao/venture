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
    
    let identifier = "trip"
    
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
    

}

// MARK:- UICollectionViewDataSource Delegate
extension TripsVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return trips.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) 
    
    return cell
    }
}
