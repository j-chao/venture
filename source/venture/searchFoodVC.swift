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
    let detailsRequest = DispatchGroup()
    
    let locationManager = CLLocationManager()
    var currentLocation:CLLocation!
    var alertController:UIAlertController? = nil
    
    
    @IBOutlet weak var pricePicker: UIPickerView!
    var pickerValues = [[String]]()
    var maxPrice:String!
    
    var token:String? = nil
    var parseJSON: JSON!
    
    var resultCount:Int!
    var resultCountDetails:Int!
    var restaurants = [String]()
    var id = [String]()
    var distance = [Decimal]()
    var address1 = [String]()
    var address2 = [String]()
    var category = [String]()
    var rating = [Decimal]()
    var phone = [String]()
    var price = [String]()
    var hours = [[String:[String]]]()
    
    @IBOutlet weak var addressTxt: UITextField!
    @IBOutlet weak var openSwitch: UISwitch!

    @IBOutlet weak var locationSwitch: UISwitch!
    
    override func viewDidLoad() {
        self.maxPrice = "1"
        self.resultCount = -1
        self.resultCountDetails = -1
        
        self.setBackground()
        super.viewDidLoad()
        locationSwitch.setOn(false, animated: true)
        locationManager.delegate = self
        self.title = "Search for Food"
        pricePicker.setValue(0.6, forKeyPath: "alpha")
        pricePicker.delegate = self
        pricePicker.dataSource = self
        pickerValues = [["$", "$$", "$$$", "$$$$"]]
        
        tokenRequest.enter()
        self.getToken()
        tokenRequest.notify(queue: DispatchQueue.main, execute: {
            print("finished getToken()")
            
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        resultCount = -1
        resultCountDetails = -1
        restaurants.removeAll()
        id.removeAll()
        distance.removeAll()
        address1.removeAll()
        address2.removeAll()
        category.removeAll()
        rating.removeAll()
        phone.removeAll()
        price.removeAll()
        hours.removeAll()
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

    func getToken() {
        let url: String = "https://api.yelp.com/oauth2/token"
        let params: [String: Any] =
            ["grant_type":"client_credentials",
             "client_id":"7MvZ6dze7A0CJ7LnQqzeeA",
             "client_secret":"NqyyQzN25eWVlUhAa5SCius0uNNqd3DS2DDDBUwrQLd3dftFnwr3BySJXBZr7KzA"]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default)
            .responseJSON { response in
                guard response.result.error == nil else {
                    print("error getting YELP access_token")
                    print(response.result.error!)
                    return
                }
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
    
    func yelpBusinessDetails(ID:String) {
        detailsRequest.enter()
        print ("businessID: ", ID)
        let url:String = "https://api.yelp.com/v3/businesses/"+ID
        let headers: HTTPHeaders = ["Authorization": "Bearer \(self.token!)"]
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
        
            self.parseJSON = JSON(json)
        
            self.detailsRequest.leave()
           
            
            self.detailsRequest.notify(queue: DispatchQueue.main, execute: {
                
            var monHours = [String]()
            var tueHours = [String]()
            var wedHours = [String]()
            var thuHours = [String]()
            var friHours = [String]()
            var satHours = [String]()
            var sunHours = [String]()
            
            var i = 0
            var total = self.parseJSON["hours"][0]["open"][0]["day"]
             
            if total != JSON.null {
                while total != JSON.null {
                    total = self.parseJSON["hours"][0]["open"][i]["day"]
                    self.resultCountDetails = self.resultCountDetails + 1
                    i = i + 1
                }
            }
         
            for i in (0..<self.resultCountDetails) {
                var open = self.parseJSON["hours"][0]["open"][i]["start"].string! as String
                open.insert(":", at: open.index(open.startIndex, offsetBy: +2))
                open = militaryToRegular(timeStr: open)
                
                var close = self.parseJSON["hours"][0]["open"][i]["end"].string! as String
                close.insert(":", at: open.index(open.startIndex, offsetBy: +2))
                close = militaryToRegular(timeStr: close)
                
                let day = self.parseJSON["hours"][0]["open"][i]["day"].int
                if day == 0 {
                    monHours.append(open+" - "+close)
                }else if day == 1 {
                    tueHours.append(open+" - "+close)
                }else if day == 2 {
                    wedHours.append(open+" - "+close)
                }else if day == 3 {
                    thuHours.append(open+" - "+close)
                }else if day == 4 {
                    friHours.append(open+" - "+close)
                }else if day == 5 {
                    satHours.append(open+" - "+close)
                }else {
                    sunHours.append(open+" - "+close)
                }
            }
            self.resultCountDetails = -1
            var hoursDict = [String:[String]]()
            hoursDict["Mon"] = monHours
            hoursDict["Tue"] = tueHours
            hoursDict["Wed"] = wedHours
            hoursDict["Thu"] = thuHours
            hoursDict["Fri"] = friHours
            hoursDict["Sat"] = satHours
            hoursDict["Sun"] = sunHours
            
            self.hours.append(hoursDict)
            })
            
        }
            

    }

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
            
            //print (json)
            self.parseJSON = JSON(json)
            var i = 0
            var businessName = self.parseJSON["businesses"][0]["name"]
            
            if businessName != JSON.null {
                while businessName != JSON.null {
                    businessName = self.parseJSON["businesses"][i]["name"]
                    self.resultCount = self.resultCount + 1
                    i = i + 1
                }
            }
            
            print (self.resultCount)

            self.myRequest.leave()
            self.myRequest.notify(queue: DispatchQueue.main, execute:{
                if self.resultCount < 0 {
                    self.displayAlert("Sorry", message: "No restauraunts were found.")
                } else {
                    self.getRestaurants()
                    self.getID()
                    self.getDistance()
                    self.getAddress()
                    self.getCategory()
                    self.getRating()
                    self.getPhone()
                    self.getPrice()
                    self.getHours()
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
            var id = self.parseJSON["businesses"][i]["id"].string
            id = id?.folding(options: .diacriticInsensitive, locale: .current)
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
            let phone = self.parseJSON["businesses"][i]["display_phone"].string
            self.phone.append(phone!)
        }
    }
    func getPrice() {
        for i in (0..<self.resultCount) {
            let price = self.parseJSON["businesses"][i]["price"].string
            self.price.append(price!)
        }
    }
    
    func getHours() {
       for ID in id {
            self.yelpBusinessDetails(ID: ID)
        }
        self.myRequest.notify(queue: DispatchQueue.main, execute: {
            print (self.hours)
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
        vc.id = self.id
        vc.distance = self.distance
        vc.address1 = self.address1
        vc.address2 = self.address2
        vc.category = self.category
        vc.rating = self.rating
        vc.phone = self.phone
        vc.price = self.price
        vc.hours = self.hours
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

