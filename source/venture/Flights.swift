//
//  Flights.swift
//  venture
//
//  Created by Justin Chao on 4/18/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import Foundation

class Flight {
    
    var departureTimeDate:Date!
    var arrivalTimeDate:Date!
    var duration:String!
    var saleTotal:String!
    var flightNumber:String!
    
    init (departureTimeDate:Date!,
          arrivalTimeDate:Date!,
          duration:String!,
          saleTotal:String!,
          flightNumber:String!) {
        self.departureTimeDate = departureTimeDate
        self.arrivalTimeDate = arrivalTimeDate
        self.duration = duration
        self.saleTotal = saleTotal
        self.flightNumber = flightNumber
    }
}
