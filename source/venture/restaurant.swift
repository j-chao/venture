//
//  restaurant.swift
//  venture
//
//  Created by Connie Liu on 4/11/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import Foundation

class Restauraunt {
    var id:String?
    var name:String?
    var category:String?
    var price:String?
    var rating:Decimal?
    //var address:String?
    //var phone:String?
    //fix this later...Yelp returns hours as objects of strings and ints
    //just saying it's a string as a placeholder for now
    //var hours:String?
    
    init(id:String?, name:String?, category:String?, price:String?, rating:Decimal?){
        self.id = id
        self.name = name
        self.category = category
        self.price = price
        self.rating = rating
        //self.address = address
        //self.phone = phone
       // self.hours = hours
    }
}
