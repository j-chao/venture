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

class searchForPlacesVC: UIViewController, UITableViewDelegate {
    
    var places = [String]()
    var ratings = [String]()
    var categories = [String]()

    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var ratingField: UITextField!
    
    let myRequest = DispatchGroup()
    override func viewDidLoad() {
        self.setBackground()
        super.viewDidLoad()
        self.title = "Search for Places"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
    @IBAction func getPlaces(_ sender: Any) {
        myRequest.enter()
        let appId = "7MvZ6dze7A0CJ7LnQqzeeA"
        let appSecret = "NqyyQzN25eWVlUhAa5SCius0uNNqd3DS2DDDBUwrQLd3dftFnwr3BySJXBZr7KzA"
        
        // Search for tourist attractions in user-defined location
        let query = YLPQuery(location: locationField.text!)
        query.term = "tourist attractions"
        query.limit = 50
        var businessName:String?
        var businessRating:String?
       
        YLPClient.authorize(withAppId: appId, secret: appSecret).flatMap { client in
            client.search(withQuery: query)
            }
            .onSuccess {
                search in
                for business in search.businesses {
                    print(business.identifier)
               
                    // filter by rating
                    if Int(business.rating) < Int(self.ratingField.text!)! {
                        continue
                    }
                    else {
                        businessName = business.name
                        businessRating = String(business.rating)
                        
                        // capitalize category name
                        let businessCatlower = business.categories[0].alias
                        var businessCat = businessCatlower.capitalizeFirst()
                        
                        self.places.append(businessName!)
                        self.ratings.append(businessRating!)
                        
                        // fix categories that are two words
                        if businessCat == "Localflavor" {
                            businessCat = "Local Flavor"
                        }
                        if businessCat == "Bustours" {
                            businessCat = "Bus Tours"
                        }
                        
                        self.categories.append(businessCat)
                    }

                }
                self.myRequest.leave()
            }
        
        myRequest.notify(queue: DispatchQueue.main, execute: {
            print("Finished all requests.")
            print(self.places)
            print(self.ratings)
            print(self.categories)
            self.segueToTable()
        })
    }

    func segueToTable() {
        let vc = UIStoryboard(name:"places", bundle:nil).instantiateViewController(withIdentifier: "placesTable") as! placesTableVC
        vc.locales = self.places
        vc.placeRatings = self.ratings
        vc.busCat = self.categories
        self.show(vc, sender: self)
       // self.navigationController?.pushViewController(vc, animated:true)
    }
    
}

// capitalize first letter of a string, used for categories
extension String {
    func capitalizeFirst() -> String {
        let firstIndex = self.index(startIndex, offsetBy: 1)
        return self.substring(to: firstIndex).capitalized + self.substring(from: firstIndex).lowercased()
    }
}

