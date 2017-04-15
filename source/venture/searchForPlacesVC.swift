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
 //   var categories = [String]()

    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var priceField: UITextField!
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
        
        // Search for 3 dinner restaurants in user-defined location
        let query = YLPQuery(location: locationField.text!)
        query.term = "tourist attractions"
        query.limit = 10
        var businessName:String?
        var businessRating:String?
   //     var businessCat:String?
       
        YLPClient.authorize(withAppId: appId, secret: appSecret).flatMap { client in
            client.search(withQuery: query)
            }
            .onSuccess {
                search in
                for business in search.businesses {
                    businessName = business.name
                    businessRating = String(business.rating)
      //              businessCat = String(describing: business.categories)
                    self.places.append(businessName!)
                    self.ratings.append(businessRating!)
       //             self.categories.append(businessCat!)
                }
                self.myRequest.leave()
            }
        
        myRequest.notify(queue: DispatchQueue.main, execute: {
            print("Finished all requests.")
            print(self.places)
            print(self.ratings)
            self.segueToTable()
        })
    }

    func segueToTable() {
        let vc = UIStoryboard(name:"places", bundle:nil).instantiateViewController(withIdentifier: "placesTable") as! placesTableVC
        vc.locales = self.places
        vc.placeRatings = self.ratings
  //      vc.busCat = self.categories
        self.show(vc, sender: self)
       // self.navigationController?.pushViewController(vc, animated:true)
    }

}
