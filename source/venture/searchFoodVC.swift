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
import CoreLocation

class searchFoodVC: UIViewController, CLLocationManagerDelegate  {
    
    var restaurants = [Restauraunt]()
    let myRequest = DispatchGroup()
    let locationManager = CLLocationManager()
    var alertController:UIAlertController? = nil
    
    @IBOutlet weak var addressTxt: UITextField!
    @IBOutlet weak var openSwitch: UISwitch!

    @IBOutlet weak var locationSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search for Food"
        //addressTxt.attributedPlaceholder = NSAttributedString(string: "address", attributes: [NSForegroundColorAttributeName:UIColor.lightGray])

        // Do any additional setup after loading the view.
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func searchFood(_ sender: Any) {
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
                    print("Top business: \(business.name)")
                    print (business.categories.first?.name)
                    print (business.identifier)
                    var currentBusiness = Restauraunt(id: business.identifier, name: business.name, category: business.categories.first?.name, price: "temp", rating: business.rating, address: business.location.address[0], city: business.location.city, state:business.location.stateCode, zip:business.location.postalCode,phone: business.phone)
                    self.restaurants.append(currentBusiness)
                    
                }
                self.myRequest.leave()
                
                //exit(EXIT_SUCCESS)
            }.onFailure { error in
                print("Search errored: \(error)")
                //exit(EXIT_FAILURE)
        }
        
        myRequest.notify(queue: DispatchQueue.main, execute: {
            print("Finished all requests.")
        //    self.restaurants.append(currentBusiness)
            self.segueToTable()
        })
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus)
    {
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
