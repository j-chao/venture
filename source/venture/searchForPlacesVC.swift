//
//  searchForPlacesVC.swift
//  venture
//
//  Created by Julianne Crea on 4/8/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import UIKit
import YelpAPI
import BrightFutures

class searchForPlacesVC: UIViewController {
    
    var places:[String] = []

    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var ratingField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search for Places"
        
        // Set delegates for table view protocols
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func getPlaces(_ sender: Any) {
        let appId = "7MvZ6dze7A0CJ7LnQqzeeA"
        let appSecret = "NqyyQzN25eWVlUhAa5SCius0uNNqd3DS2DDDBUwrQLd3dftFnwr3BySJXBZr7KzA"
        
        // Search for 3 dinner restaurants
        let query = YLPQuery(location: locationField.text!)
        query.term = "dinner"
        query.limit = 3
        
        YLPClient.authorize(withAppId: appId, secret: appSecret).flatMap { client in
            client.search(withQuery: query)
            }.onSuccess { search in
                if let topBusiness = search.businesses.first {
                    self.places.append("\(topBusiness.name)")
                    print("Top business: \(topBusiness.name)")
                } else {
                 //   self.places.append("No businesses found")
                    print("None found")
                }
                exit(EXIT_SUCCESS)
            }.onFailure { error in
                print("Search errored: \(error)")
                exit(EXIT_FAILURE)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPlaces" {
            if let destinationVC = segue.destination as? placesTableVC {
                // pass array to table VC
                destinationVC.locales = places
            }
        }
    }

}
