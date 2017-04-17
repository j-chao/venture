//
//  searchFoodVC.swift
//  venture
//
//  Created by Connie Liu on 4/10/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import UIKit
import YelpAPI
import BrightFutures
import Alamofire
import CoreLocation

class searchFoodVC: UIViewController, CLLocationManagerDelegate  {
    
    var restaurants = [Restauraunt]()
    var eventDate:Date!
    let myRequest = DispatchGroup()
    let tokenRequest = DispatchGroup()
    
    let locationManager = CLLocationManager()
    var currentLocation:CLLocation!
    var alertController:UIAlertController? = nil
    
    var token:String? = nil
    
    @IBOutlet weak var addressTxt: UITextField!
    @IBOutlet weak var openSwitch: UISwitch!

    @IBOutlet weak var locationSwitch: UISwitch!
    
    override func viewDidLoad() {
        self.setBackground()
        super.viewDidLoad()
        locationManager.delegate = self
        self.title = "Search for Food"
        
        // requesting the access_token from Yelp takes time and therefore, it is necessary to wait until the request is complete before we can proceed with using the obtained token to request results from Yelp.
        tokenRequest.enter()
        self.getToken()
       
        // execute after getToken() is finished
        tokenRequest.notify(queue: DispatchQueue.main, execute: {
            print("finished getToken()")
//            self.yelpBusinessDetails()
            //self.yelpSearch()
        })
    }
    
    @IBAction func locationSwitchOn(_ sender: UISwitch) {
        if self.locationSwitch.isOn{
            print ("location check")
            // Make sure the location service is available before trying to use it.
            if CLLocationManager.locationServicesEnabled() {
                // Configure the location manager for what we want to track.
                locationManager.startUpdatingLocation()
                locationManager.desiredAccuracy = 100 // meters
                // If we haven't done so yet, we need to ask for access to the location data.
                if CLLocationManager.authorizationStatus() == .notDetermined {
                    locationManager.requestWhenInUseAuthorization()
                }
            } else {
                self.displayAlert("Error", message: "Location Services not available!")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations[0]
        print ("location found")
        print (currentLocation)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print (error)
    }

    
    func yelpFood(query:YLPQuery) {
        myRequest.enter()
        let appId = "7MvZ6dze7A0CJ7LnQqzeeA"
        let appSecret = "NqyyQzN25eWVlUhAa5SCius0uNNqd3DS2DDDBUwrQLd3dftFnwr3BySJXBZr7KzA"
        
        //implement parameters for open_now and price later
        query.term = "food, restaurants"
        query.sort = YLPSortType.distance
        
        YLPClient.authorize(withAppId: appId, secret: appSecret).flatMap {
            client in
            client.search(withQuery: query)
            }.onSuccess { search in
                
                for business in search.businesses{
                    let foodId = business.identifier
                    let foodName = business.name
                    let foodCat = business.categories[0].name
                    let foodRating = (business.rating)
                    
                    var foodSt:String?
                    if business.location.address.count != 0{
                        foodSt = (business.location.address[0])
                    } else{
                        foodSt = " "
                    }
                    
                    let foodCity = business.location.city
                    let foodState = business.location.stateCode
                    let foodZip = business.location.postalCode
                    let foodPhone = business.phone
                    
                    let currentBusiness = Restauraunt(id: foodId, name: foodName, category: foodCat, rating: foodRating, address: foodSt, city: foodCity, state:foodState, zip:foodZip, phone: foodPhone)
                    self.restaurants.append(currentBusiness)
                    
                }
               
            self.myRequest.leave()
                
                //exit(EXIT_SUCCESS)
            }.onFailure { error in
                print("Search errored: \(error)")
                //exit(EXIT_FAILURE)
            }
        
    }
    
    @IBAction func searchFood(_ sender: Any) {
        if addressTxt.text!.isEmpty && self.locationSwitch.isOn == false{
            self.displayAlert("Error", message: "Please provide a location.")
        }
        
        if self.locationSwitch.isOn {
            let coordinate = YLPCoordinate(latitude:currentLocation.coordinate.latitude, longitude:currentLocation.coordinate.longitude)
            self.yelpFood(query:YLPQuery(coordinate: coordinate))
        }

        else{
         self.yelpFood(query:YLPQuery(location: addressTxt.text!))
        }
        locationManager.stopUpdatingLocation()
        myRequest.notify(queue: DispatchQueue.main, execute: {
            print("Finished all requests.")
            self.segueToTable()
        })
    }
    
    
    func displayAlert(_ title:String, message:String) {
        self.alertController = UIAlertController(title:title, message:message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action:UIAlertAction) in
        }
        self.alertController!.addAction(okAction)
        self.present(self.alertController!, animated: true, completion:nil)
    }
    
    func segueToTable() {
        let vc = UIStoryboard(name:"food", bundle:nil).instantiateViewController(withIdentifier: "foodTable") as! foodTableVC
        vc.restaurants = self.restaurants
        vc.eventDate = self.eventDate
        self.show(vc, sender: self)
    }

    // getToken() gets the access_token from Yelp, and is necessary for all HTTP requests
    func getToken() {
        let url: String = "https://api.yelp.com/oauth2/token"
        let params: [String: Any] =
            ["grant_type":"client_credentials",
             "client_id":"7MvZ6dze7A0CJ7LnQqzeeA",
             "client_secret":"NqyyQzN25eWVlUhAa5SCius0uNNqd3DS2DDDBUwrQLd3dftFnwr3BySJXBZr7KzA"]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default)
            .responseJSON { response in
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error getting YELP access_token")
                    print(response.result.error!)
                    return
                }
                // make sure we got some JSON since that's what we expect
                guard let json = response.result.value as? [String: Any] else {
                    print("error getting JSON from YELP")
                    print("Error: \(response.result.error)")
                    return
                }
                
                guard let access_token = json["access_token"] as? String else {
                    print("error getting access_token from JSON")
                    return
                }
                self.token = access_token
                self.tokenRequest.leave()
        }
        
    }
    
    // yelpBusinessDetails() requests business specific details from Yelp and returns a JSON formatted data object
    // documentation: https://www.yelp.com/developers/documentation/v3/business
    // modify the url:String with the business ID to return business specific details.
    // ie: current url:String is hard-coded for Keybey Lane Cafe
    
    func yelpBusinessDetails() {
        let url:String = "https://api.yelp.com/v3/businesses/kerbey-lane-cafe-austin-4"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(self.token!)"
        ]
        Alamofire.request(url, headers: headers).responseJSON { response in
            guard response.result.error == nil else {
                print("error getting business details from Yelp")
                print(response.result.error!)
                return
            }
            guard let json = response.result.value as? [String: Any] else {
                print("didn't get businessID object as JSON from API")
                print("Error: \(response.result.error)")
                return
            }
            print (json)
        }
        
    }
    
    
    // yelpSearch() returns up to 1000 businesses based on the provided search criteria as a JSON formatted data object. It has some basic information about the business.
    // user can add/remove/change search criteria by modifying the parameters argument. Location is a required parameter.
    // currently, the location parameter has been hard-coded in as Austin, TX
    // To get detailed information and reviews, please use the business id returned here and refer to yelpBusinessDetails() endpoints.
    // documentation: https://www.yelp.com/developers/documentation/v3/business_search
    func yelpSearch() {
        let url:String = "https://api.yelp.com/v3/businesses/search"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(self.token!)"]
        
        let params: [String: Any] =
            ["location": "Austin, TX",
             "term": "restaurants, food",
             "sort_by": "best_match",
             "price": "1,2"]
        
        Alamofire.request(url, parameters: params, headers: headers).responseJSON {response in
            guard response.result.error == nil else {
                print("error calling GET on Yelp")
                print(response.result.error!)
                return
            }
            guard let json = response.result.value as? [String: Any] else {
                print("didn't get businessID object as JSON from API")
                print("Error: \(response.result.error)")
                return
            }
            print (json)
        }
    }

}
