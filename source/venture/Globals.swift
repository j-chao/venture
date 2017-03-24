//
//  Globals.swift
//  venture
//
//  Created by Justin Chao on 3/22/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import Foundation
import Firebase

var tripLength:Int = 1
var passedTrip:String = ""
var passedStart:String = ""

protocol CalculateTime {
    func dateFromString (dateString:String) -> Date
    func calculateDays(start: Date, end: Date) -> Int
}

struct tripStruct {
    let tripName: String!
    let tripLocation: String!
    let startDate: String!
    let endDate: String!
}


func dateFromString (dateString:String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy"
    dateFormatter.locale = Locale(identifier: "en_US")
    let dateObj = dateFormatter.date(from: dateString)
    return (dateObj)!
}

func stringFromDate (date:Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/YYYY"
    return dateFormatter.string(from: date)
}

func stringLongFromDate (date:Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE   MMM dd"
    return dateFormatter.string(from: date)
}


func calculateDays(start: Date, end: Date) -> Int {
    let currentCalendar = Calendar.current
    guard let start = currentCalendar.ordinality(of: .day, in: .era, for: start) else {
        return 0
    }
    guard let end = currentCalendar.ordinality(of: .day, in: .era, for: end) else {
        return 0
    }
    return (end - start)
}
