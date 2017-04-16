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
    let myRequest = DispatchGroup()
    let tokenRequest = DispatchGroup()
    
    let locationManager = CLLocationManager()
    var alertController:UIAlertController? = nil
    var token:String? = nil
    
    @IBOutlet weak var addressTxt: UITextField!
    @IBOutlet weak var openSwitch: UISwitch!

    @IBOutlet weak var locationSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search for Food"
        //addressTxt.attributedPlaceholder = NSAttributedString(string: "address", attributes: [NSForegroundColorAttributeName:UIColor.lightGray])

        // Do any additional setup after loading the view.
  
        tokenRequest.enter()
        self.getToken()
        tokenRequest.notify(queue: DispatchQueue.main, execute: {
            print("finished tokenRequest")
            self.makeGetCall()
        })
        
    }
    
    func yelpFood() {
        myRequest.enter()
        let appId = "7MvZ6dze7A0CJ7LnQqzeeA"
        let appSecret = "NqyyQzN25eWVlUhAa5SCius0uNNqd3DS2DDDBUwrQLd3dftFnwr3BySJXBZr7KzA"
        
        //implement parameters for open_now and price
        let query = YLPQuery(location: addressTxt.text!)
        query.term = "food, restaurants"
        query.sort = YLPSortType.distance
        
        YLPClient.authorize(withAppId: appId, secret: appSecret).flatMap {
            client in
            client.search(withQuery: query)
            }.onSuccess { search in
                
                for business in search.businesses{
                    // if let topBusiness = search.businesses. {
//                    print("Top business: \(business.name)")
//                    print (business.categories.first?.name as Any)
//                    print (business.identifier)
                    let currentBusiness = Restauraunt(id: business.identifier, name: business.name, category: business.categories.first?.name, price: "temp", rating: business.rating, address: business.location.address[0], city: business.location.city, state:business.location.stateCode, zip:business.location.postalCode,phone: business.phone)
                    self.restaurants.append(currentBusiness)
                    
                    print (business.identifier.propertyList())
                    
                    
                }
               
            self.myRequest.leave()
            
                
                //exit(EXIT_SUCCESS)
            }.onFailure { error in
                print("Search errored: \(error)")
                //exit(EXIT_FAILURE)
            }
        
    }
    
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
                    print("error calling POST")
                    print(response.result.error!)
                    return
                }
                // make sure we got some JSON since that's what we expect
                guard let json = response.result.value as? [String: Any] else {
                    print("didn't get token object as JSON from API")
                    print("Error: \(response.result.error)")
                    return
                }
                
                guard let access_token = json["access_token"] as? String else {
                    print("Could not get todo title from JSON")
                    return
                }
                self.token = access_token
                self.tokenRequest.leave()
        }

    }
    
    func makeGetCall() {
        let url:String = "https://api.yelp.com/v3/businesses/kerbey-lane-cafe-austin-4"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(self.token!)"
        ]
        
        Alamofire.request(url, headers: headers).responseJSON { response in
            // check for errors
            guard response.result.error == nil else {
                // got an error in getting the data, need to handle it
                print("error calling GET on Yelp")
                print(response.result.error!)
                return
            }
            
            // make sure we got some JSON since that's what we expect
            guard let json = response.result.value as? [String: Any] else {
                print("didn't get businessID object as JSON from API")
                print("Error: \(response.result.error)")
                return
            }
            
            print (json)
        }
    
    }
    

    @IBAction func searchFood(_ sender: Any) {
        self.makeGetCall()
        if self.locationSwitch.isOn {
            print ("location check")
            // Make sure the location service is available before trying to use it.
            if CLLocationManager.locationServicesEnabled() {
                // Configure the location manager for what we want to track.
                locationManager.desiredAccuracy = 100 // meters
                locationManager.delegate = self
                
                // If we haven't done so yet, we need to ask for access to the location data.
                if CLLocationManager.authorizationStatus() == .notDetermined {
                    // Must choose between requesting to get access to location data
                    // either always or only when the app is running.
                    locationManager.requestWhenInUseAuthorization()
                }
            } else {
                self.displayAlert("Error", message: "Location Services not available!")
            }
        }
        
        
        self.yelpFood()
        
        myRequest.notify(queue: DispatchQueue.main, execute: {
            print("Finished all requests.")
//            self.restaurants.append(currentBusiness)
            self.segueToTable()
        })
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            if status == .authorizedAlways {
                print("Authorized for Always")
            } else {
                print("Authorized for When In use")
            }
            // Start monitoring for various kinds of events here.
            // Callbacks will start occurring.
            manager.startUpdatingLocation()
            manager.startUpdatingHeading()
            manager.startMonitoringVisits()
        } else {
            print("Not Authorized")
        }
    }
    
    func displayAlert(_ title:String, message:String) {
        self.alertController = UIAlertController(title:title, message:message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action:UIAlertAction) in
        }
        self.alertController!.addAction(okAction)
        self.present(self.alertController!, animated: true, completion:nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func segueToTable() {
        let vc = UIStoryboard(name:"food", bundle:nil).instantiateViewController(withIdentifier: "foodTable") as! foodTableVC
        vc.restaurants = self.restaurants
        self.show(vc, sender: self)
        //        self.navigationController?.pushViewController(vc, animated:true)
    }
}
