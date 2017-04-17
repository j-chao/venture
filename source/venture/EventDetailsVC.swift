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
import UserNotifications

class EventDetailsVC: UIViewController {
    
    var ref:FIRDatabaseReference?
    let userID = FIRAuth.auth()?.currentUser?.uid
    let center = UNUserNotificationCenter.current()
    
    let myRequest = DispatchGroup()
  
    var date:String!
    var event:String!
    var dateNS:Date!
    var timeNS:Date!

    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventDesc: UILabel!
    @IBOutlet weak var eventLoc: UILabel!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var reminderSwitch: UISwitch!
    
    override func viewDidLoad() {
        myRequest.enter()
        
        dateNS = dateFromStringLong(dateString: self.date)
        
        self.setBackground()
        super.viewDidLoad()
        
        let ref = FIRDatabase.database().reference().child("users/\(userID!)/trips/\(passedTrip)/\(date!)")
        
        ref.child(event).observe(.value, with: { snapshot in
            if snapshot.exists() {
                let desc = (snapshot.value as? NSDictionary)?["eventDesc"]
                let timeRec = (snapshot.value as? NSDictionary)?["eventTime"]
                let loc = (snapshot.value as? NSDictionary)?["eventLoc"] as! String!
              
                let timeDate = timeFromStringTime(timeStr: timeRec as! String)
                self.timeNS = timeDate
                let timeDisplay = stringTimefromDate(date: timeDate)
                
                self.eventDate.text = self.date
                self.eventTime.text = timeDisplay as String?
                self.eventDesc.text = desc as! String?
                self.eventLoc.text = loc
                
                self.myRequest.leave()
            }
        })
        
        myRequest.notify(queue: DispatchQueue.main, execute: {
            self.setMapMark()
            self.setInitialReminderSwitchState()
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
    
    
    @IBAction func reminderAction(_ sender: UISwitch) {
        
        if self.reminderSwitch.isOn == false {
            self.reminderSwitch.setOn(true, animated: true)
            let notifyDate = self.dateTime(forDate: self.dateNS, timedate: self.timeNS)
            self.scheduleNotification(at: notifyDate)
        } else if self.reminderSwitch.isOn == true {
            self.reminderSwitch.setOn(false, animated: true)
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [self.eventDesc.text!])
        }
    }
    
}

extension EventDetailsVC {
    
    func setInitialReminderSwitchState() {
        self.reminderSwitch.setOn(false, animated: true)
        center.getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                if request.identifier == self.eventDesc.text! {
                    self.reminderSwitch.setOn(true, animated: true)
                }
            }
        })
    }
    
    func dateTime (forDate:Date, timedate:Date) ->Date {
        let df = DateFormatter()
        df.dateFormat = "dd MMM yyyy"
        var resultdate = Date()
        if let dateFromString = df.date(from: df.string(from: forDate as Date)) {
            
            let hour = NSCalendar.current.component(.hour, from: timedate as Date)
            let minutes = NSCalendar.current.component(.minute, from: timedate as Date)
            if let dateFromStringWithTime = NSCalendar.current.date(bySettingHour: hour, minute: minutes, second: 0, of: dateFromString) {
                let df = DateFormatter()
                df.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS'Z"
                let resultString = df.string(from: dateFromStringWithTime)
                resultdate = df.date(from: resultString)!
            }
        }
        return resultdate
    }
    
    
    func scheduleNotification(at date: Date) {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: .current, from: date)
        let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = "Event Reminder"
        content.body = self.eventDesc.text!
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = "myCategory"
        
        let request = UNNotificationRequest(identifier: self.eventDesc.text!, content: content, trigger: trigger)
        
        center.removeAllPendingNotificationRequests()
        center.add(request) {(error) in
            if let error = error {
                print("error scheduling notification: \(error)")
            }
        }
    }
}
