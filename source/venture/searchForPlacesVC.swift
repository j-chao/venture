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
    var imgUrls = [URL]()
    var reviewCounts = [String]()
    var addresses = [String]()
    var zipCodes = [String]()
    var streets = [String]()
    var eventDate:Date!

    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var ratingField: UITextField!
    
    let myRequest = DispatchGroup()
    override func viewDidLoad() {
        self.setBackground()
        super.viewDidLoad()
//        self.title = "Search for Places"
    }
   
    @IBAction func getPlaces(_ sender: Any) {
        myRequest.enter()
        
        if locationField.text!.isEmpty || ratingField.text!.isEmpty {
            self.presentAllFieldsAlert()
        } else {
            
        
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
                    if Double(business.rating) < Double(self.ratingField.text!)! {
                        continue
                    }
                    else {
                        if business.location.address.count != 0 {
                            let busStreet = business.location.address[0]
                            self.streets.append(busStreet)
                        }
                        let busStreet = ""
                        businessName = business.name
                        businessRating = "\(business.rating)" + " / 5"
                        let busImgUrl = business.imageURL
                        let busReviews = String(business.reviewCount)
                        let busAddress = "\(business.location.city)" + ", " + "\(business.location.stateCode)" + ", " + "\(business.location.countryCode)"
                        let zipCode = business.location.postalCode
                        
                        // capitalize category name
                        let businessCatlower = business.categories[0].alias
                        var businessCat = businessCatlower.capitalizeFirst()
                        
                        self.places.append(businessName!)
                        self.ratings.append(businessRating!)
                        
                        if busImgUrl != nil {
                            self.imgUrls.append(busImgUrl!)
                        } else {
                            let url = URL(string: "http://vignette2.wikia.nocookie.net/main-cast/images/5/5b/Sorry-image-not-available.png/revision/latest?cb=20160625173435")
                            self.imgUrls.append(url!)
                        }
                        
                        self.reviewCounts.append(busReviews)
                        self.addresses.append(busAddress)
                        self.zipCodes.append(zipCode)
                        self.streets.append(busStreet)
                        
                        // fix categories that are two words
                        if businessCat == "Localflavor" {
                            businessCat = "Local Flavor"
                        }
                        if businessCat == "Bustours" {
                            businessCat = "Bus Tours"
                        }
                        if businessCat == "Walkingtours" {
                            businessCat = "Walking Tours"
                        }
                        if businessCat == "Amusementparks" {
                            businessCat = "Amusement Parks"
                        }
                        if businessCat == "Fleamarkets" {
                            businessCat = "Flea Markets"
                        }
                        if businessCat == "Publicservicesgovt" {
                            businessCat = "Public Services / Govt"
                        }
                        if businessCat == "Bikerentals" {
                            businessCat = "Bike Rentals"
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
    }

    func segueToTable() {
        let vc = UIStoryboard(name:"places", bundle:nil).instantiateViewController(withIdentifier: "placesTable") as! placesTableVC
        vc.locales = self.places
        vc.placeRatings = self.ratings
        vc.busCat = self.categories
        vc.imgUrls = self.imgUrls
        vc.reviewCounts = self.reviewCounts
        vc.addresses = self.addresses
        vc.zipCodes = self.zipCodes
        vc.streets = self.streets
        vc.eventDate = self.eventDate
        self.show(vc, sender: self)
    }
    
}

extension searchForPlacesVC {
    
    func presentAllFieldsAlert() {
        let alert = UIAlertController(title: "Error", message: "Please fill out all fields." , preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            (action:UIAlertAction) in
        }
        alert.addAction(OKAction)
        self.present(alert, animated: true, completion:nil)
        return
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// capitalize first letter of a string, used for categories
extension String {
    func capitalizeFirst() -> String {
        let firstIndex = self.index(startIndex, offsetBy: 1)
        return self.substring(to: firstIndex).capitalized + self.substring(from: firstIndex).lowercased()
    }
}

