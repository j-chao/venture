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
    var imgUrls = [String]()
    var reviewCounts = [String]()

    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var ratingField: UITextField!
    
    let myRequest = DispatchGroup()
    override func viewDidLoad() {
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
               
                    // filter by rating
                    if Int(business.rating) < Int(self.ratingField.text!)! {
                        continue
                    }
                    else {
                        businessName = business.name
                        businessRating = String(business.rating)
                        let busImgUrl = "\(business.imageURL!)"
                        let busReviews = String(business.reviewCount)
                        
                        // capitalize category name
                        let businessCatlower = business.categories[0].alias
                        var businessCat = businessCatlower.capitalizeFirst()
                        
                        self.places.append(businessName!)
                        self.ratings.append(businessRating!)
                        self.imgUrls.append(busImgUrl)
                        self.reviewCounts.append(busReviews)
                        
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
            self.segueToTable()
        })
    }

    func segueToTable() {
        let vc = UIStoryboard(name:"places", bundle:nil).instantiateViewController(withIdentifier: "placesTable") as! placesTableVC
        vc.locales = self.places
        vc.placeRatings = self.ratings
        vc.busCat = self.categories
        vc.imgUrls = self.imgUrls
        vc.reviewCounts = self.reviewCounts
        self.show(vc, sender: self)
    }
    
}

// capitalize first letter of a string, used for categories
extension String {
    func capitalizeFirst() -> String {
        let firstIndex = self.index(startIndex, offsetBy: 1)
        return self.substring(to: firstIndex).capitalized + self.substring(from: firstIndex).lowercased()
    }
}

