//
//  searchFoodVC.swift
//  venture
//
//  Created by Connie Liu on 4/10/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import SwiftyJSON

class searchFoodVC: UIViewController, CLLocationManagerDelegate  {
    
    var eventDate:Date!
    let myRequest = DispatchGroup()
    let tokenRequest = DispatchGroup()
    
    let locationManager = CLLocationManager()
    var currentLocation:CLLocation!
    var alertController:UIAlertController? = nil
    
    
    @IBOutlet weak var pricePicker: UIPickerView!
    var pickerValues = [[String]]()
    var maxPrice:String!
    
    var token:String? = nil
    var parseJSON: JSON!
    
    var resultCount = -1
    var restaurants = [String]()
    var id = [String]()
    var distance = [Decimal]()
    var address1 = [String]()
    var address2 = [String]()
    var category = [String]()
    var rating = [Decimal]()
    var phone = [String]()
    var price = [String]()
    var hours = [Array<Any>]()
    
    @IBOutlet weak var addressTxt: UITextField!
    @IBOutlet weak var openSwitch: UISwitch!

    @IBOutlet weak var locationSwitch: UISwitch!
    
    override func viewDidLoad() {
        self.setBackground()
        super.viewDidLoad()
        locationSwitch.setOn(false, animated: true)
        locationManager.delegate = self
        self.title = "Search for Food"
        pricePicker.setValue(0.6, forKeyPath: "alpha")
        pricePicker.delegate = self
        pricePicker.dataSource = self
        pickerValues = [["$", "$$", "$$$", "$$$$"]]
        
        // requesting the access_token from Yelp takes time and therefore, it is necessary to wait until the request is complete before we can proceed with using the obtained token to request results from Yelp.
        tokenRequest.enter()
        self.getToken()
       
        // execute after getToken() is finished
        tokenRequest.notify(queue: DispatchQueue.main, execute: {
            print("finished getToken()")
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        resultCount = -1
        restaurants.removeAll()
        id.removeAll()
        distance.removeAll()
        address1.removeAll()
        address2.removeAll()
        category.removeAll()
        rating.removeAll()
        phone.removeAll()
        price.removeAll()
        //hours.removeAll()
        
        locationSwitch.setOn(false, animated: false)
        addressTxt.text = ""
    }

    @IBAction func locationSwitchOn(_ sender: UISwitch) {
        if self.locationSwitch.isOn{
            print ("location check")
            addressTxt.text = ""
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
    
    
    @IBAction func searchFood(_ sender: Any) {
        if addressTxt.text!.isEmpty && self.locationSwitch.isOn == false{
            self.displayAlert("Error", message: "Please provide a location.")
        } else{
                self.yelpSearch()
        }
        locationManager.stopUpdatingLocation()
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
        myRequest.enter()
        let url:String = "https://api.yelp.com/v3/businesses/search"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(self.token!)"]
        
        var params:[String:Any]!
        
        if locationSwitch.isOn {
            params =
                ["latitude": currentLocation.coordinate.latitude,
                 "longitude": currentLocation.coordinate.longitude,
                 "term": "restaurants, food",
                 "sort_by": "distance",
                 "price": self.maxPrice,
                 "open_now": self.openSwitch.isOn] as [String : Any]
        } else{
            params =
                ["location": addressTxt.text!,
                 "term": "restaurants, food",
                 "sort_by": "distance",
                 "price": self.maxPrice,
                 "open_now": self.openSwitch.isOn] as [String : Any]
        }
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
            self.parseJSON = JSON(json)
            var i = 0
            var total = self.parseJSON["businesses"][0]["name"]
            
            if total != JSON.null {
                while total != JSON.null {
                    total = self.parseJSON["businesses"][i]["name"]
                    self.resultCount = self.resultCount + 1
                    i = i + 1
                }
            }

            self.myRequest.leave()
            self.myRequest.notify(queue: DispatchQueue.main, execute:{
                if self.resultCount < 0 {
                    self.displayAlert("Sorry", message: "No restauraunts were found.")
                } else{
                    self.getRestaurants()
                    self.getID()
                    self.getDistance()
                    self.getAddress()
                    self.getCategory()
                    self.getRating()
                    self.getPhone()
                    self.getPrice()
                    //self.getHours()
                    self.segueToTable()
                }
            })
        }
    }
    
    func getRestaurants() {
        for i in (0..<self.resultCount) {
            let name = self.parseJSON["businesses"][i]["name"].string
            self.restaurants.append(name!)
        }
    }
    func getID() {
        for i in (0..<self.resultCount) {
            let id = self.parseJSON["businesses"][i]["id"].string
            self.id.append(id!)
        }
    }
    
    func getDistance() {
        for i in (0..<self.resultCount) {
            let distance = self.parseJSON["businesses"][i]["distance"].int
            self.distance.append(Decimal(distance!))
        }
    }
    func getAddress() {
        for i in (0..<self.resultCount) {
            let address = self.parseJSON["businesses"][i]["location"]["address1"].string
            self.address1.append(address!)
            
            let city = self.parseJSON["businesses"][i]["location"]["city"].string
            let state = self.parseJSON["businesses"][i]["location"]["state"].string
            let zip = self.parseJSON["businesses"][i]["location"]["zip_code"].string
            self.address2.append("\(city!), \(state!) \(zip!)")
        }
    }
    func getCategory() {
        for i in (0..<self.resultCount) {
            let category = self.parseJSON["businesses"][i]["categories"][0]["title"].string
            self.category.append(category!)
        }
    }
    
    func getRating() {
        for i in (0..<self.resultCount) {
            let rating = self.parseJSON["businesses"][i]["rating"].int
            self.rating.append(Decimal(rating!))
        }
    }
    func getPhone() {
        for i in (0..<self.resultCount) {
            let phone = self.parseJSON["businesses"][i]["phone"].string
            self.phone.append(phone!)
        }
    }
    func getPrice() {
        for i in (0..<self.resultCount) {
            let price = self.parseJSON["businesses"][i]["price"].string
            self.price.append(price!)
        }
    }
    /*func getHours() {
        for i in (0..<self.resultCount) {
            let name = self.parseJSON["businesses"][i]["id"].string
            self.id.append(name!)
        }
    }*/

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
        vc.id = self.id
        vc.distance = self.distance
        vc.address1 = self.address1
        vc.address2 = self.address2
        vc.category = self.category
        vc.rating = self.rating
        vc.phone = self.phone
        vc.price = self.price
        //vc.hours = self.hours
        vc.eventDate = self.eventDate
        self.show(vc, sender: self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


extension searchFoodVC: UIPickerViewDelegate, UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerValues[component].count
    }
    
    func pickerView(_ pickerview: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerValues[component][row]
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            maxPrice = "1"
        } else if row == 1 {
            maxPrice = "1,2"
        } else if row == 2 {
            maxPrice = "1,2,3"
        } else if row == 3 {
            maxPrice = "1,2,3,4"
        }
    }
}

