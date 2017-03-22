//
//  Protocols.swift
//  venture
//
//  Created by Justin Chao on 3/22/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import Foundation
import Firebase

var tripLength:Int = 1

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
