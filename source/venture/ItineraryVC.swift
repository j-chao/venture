//
//  ItineraryVC.swift
//  venture
//
//  Created by Justin Chao on 3/19/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import UIKit
import CoreData

class ItineraryVC: UIViewController {
    var trip = NSManagedObject()
    var titleName:String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = trip.value(forKey: "tripName") as? String
        self.title = titleName

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
