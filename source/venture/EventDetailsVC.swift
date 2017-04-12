//
//  EventDetailsVC.swift
//  venture
//
//  Created by Justin Chao on 4/6/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class EventDetailsVC: UIViewController {
    
    var ref:FIRDatabaseReference?
    let userID = FIRAuth.auth()?.currentUser?.uid
    
    let myRequest = DispatchGroup()
  
    var date:String!
    var event:String!

    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventDesc: UILabel!
    @IBOutlet weak var eventLoc: UILabel!
    
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        myRequest.enter()
        
        self.setBackground()
        super.viewDidLoad()
        
        let ref = FIRDatabase.database().reference().child("users/\(userID!)/trips/\(passedTrip)/\(date!)")
        
        ref.child(event).observe(.value, with: { snapshot in
            if snapshot.exists() {
                let desc = (snapshot.value as? NSDictionary)?["eventDesc"]
                let timeRec = (snapshot.value as? NSDictionary)?["eventTime"]
                let loc = (snapshot.value as? NSDictionary)?["eventLoc"] as! String!
              
                let timeDate = timeFromStringTime(timeStr: timeRec as! String)
                let timeDisplay = stringTimefromDate(date: timeDate)
                
                self.eventDate.text = self.date
                self.eventTime.text = timeDisplay as String?
                self.eventDesc.text = desc as! String?
                self.eventLoc.text = loc
            }
        })
        myRequest.leave()
        
        myRequest.notify(queue: DispatchQueue.main, execute: {
            self.setMapMark()
        })
    }
    
    func setMapMark() {
        let address = self.eventLoc.text
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address!) { [weak self] placemarks, error in
            if let placemark = placemarks?.first, let location = placemark.location {
                let mark = MKPlacemark(placemark: placemark)
                
                if var region = self?.map.region {
                    region.center = location.coordinate
                    region.span.longitudeDelta = 0.1
                    region.span.latitudeDelta = 0.1
                    self?.map.setRegion(region, animated: true)
                    self?.map.addAnnotation(mark)
                }
            }
        }
    }
    
    func setMapCoor() {
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.1, 0.1)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(30.286114, -97.739347)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        map.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "HOOK 'EM"
        map.addAnnotation(annotation)
    }
    
    
}
