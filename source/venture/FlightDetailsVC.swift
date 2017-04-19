//
//  FlightDetailsVC.swift
//  venture
//
//  Created by Justin Chao on 4/18/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import UIKit

class FlightDetailsVC: UIViewController {
    var departureTimeDate:Date!
    var arrivalTimeDate:Date!
    
    var departureTimeStr:String!
    var arrivalTimeStr:String!
    
    var duration:String!
    var saleTotal:String!
    var flightNumber:String!
    var tripDate:String!
    var eventDate:Date!
    var destArrival:String!
    
    
    @IBOutlet weak var destArrivalLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var flightLabel: UILabel!
    @IBOutlet weak var airlineLabel: UILabel!
    @IBOutlet weak var departureLabel: UILabel!
    @IBOutlet weak var arrivalLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    

    override func viewDidLoad() {
        self.setBackground()
        super.viewDidLoad()
        
        self.departureTimeStr = stringTimefromDate(date: departureTimeDate)
        self.arrivalTimeStr = stringTimefromDate(date: arrivalTimeDate)
       
        self.destArrivalLabel.text = self.destArrival
        self.dateLabel.text = stringLongFromDate(date: eventDate)
        self.flightLabel.text = self.flightNumber
        self.airlineLabel.text = "airline label"
        self.departureLabel.text = self.departureTimeStr
        self.arrivalLabel.text = self.arrivalTimeStr
        self.durationLabel.text = self.duration
        self.costLabel.text = self.saleTotal
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEventFromFlight"{
            if let destinationVC = segue.destination as? AddEventVC {
                destinationVC.fromFlight = true
                destinationVC.fromFoodorPlace = false
                destinationVC.eventDate = self.eventDate
                destinationVC.eventDescStr = self.destArrival
                destinationVC.eventLocStr = self.destArrival.substring(to: 4)
                destinationVC.flightTime = self.departureTimeDate
            }
        }
    }

}
