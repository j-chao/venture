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
var timeFormat:String = "regular"
var background:Int = 2

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

func flightDatefromDate (date:Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYYY-MM-dd"
    return dateFormatter.string(from: date)
}

func stringLongFromDate (date:Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE   MMM dd"
    return dateFormatter.string(from: date)
}

func dateFromStringLong (dateString:String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE   MMM dd"
    dateFormatter.locale = Locale(identifier: "en_US")
    let dateObj = dateFormatter.date(from: dateString)
    return (dateObj)!
}

func stringTimefromDate (date:Date) -> String {
    let dateFormatter = DateFormatter()
    if timeFormat == "regular" {
        dateFormatter.dateFormat = "h:mm a"
    }
    else if timeFormat == "military" {
        dateFormatter.dateFormat = "HH:mm"
    }
    return dateFormatter.string(from: date)
}

func stringTimefromDateToFIR (date:Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    return dateFormatter.string(from: date)
}

func timeFromStringTime (timeStr:String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    return dateFormatter.date(from: timeStr)!
}

func timeFromString (timeStr:String) -> Date {
    let dateFormatter = DateFormatter()
    if timeFormat == "regular" {
        dateFormatter.dateFormat = "h:mm a"
    }
    else if timeFormat == "military" {
        dateFormatter.dateFormat = "HH:mm"
    }
    return dateFormatter.date(from: timeStr)!
}

func militaryToRegular (timeStr:String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    let date = dateFormatter.date(from: timeStr)
    dateFormatter.dateFormat = "h:mm a"
    return dateFormatter.string(from: date!)
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

func minutesToHoursMinutes (minutes: Int) -> String {
    let hours = minutes / 60
    let min = (minutes % 60)
    return ("\(hours)h:\(min)m")
}
