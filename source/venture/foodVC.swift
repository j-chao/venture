//
//  foodVC.swift
//  venture
//
//  Created by Connie Liu on 4/10/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import UIKit

class foodVC: UIViewController {

    var nameStr:String?
    var address1Str:String?
    var address2Str:String?
    var categoryStr:String?
    var rating:Decimal?
    var phoneStr:String?
    var priceStr:String?
    var hours = [String:[String]]()
    
    var eventDate:Date!
    
    @IBOutlet weak var foodAddress1Lbl: UILabel!
    @IBOutlet weak var foodAddress2Lbl: UILabel!
    @IBOutlet weak var foodPhoneLbl: UILabel!
    @IBOutlet weak var foodRatingLbl: UILabel!
    @IBOutlet weak var foodCategoryLbl: UILabel!
    @IBOutlet weak var foodPriceLbl: UILabel!
    @IBOutlet weak var monHours: UILabel!
    @IBOutlet weak var tueHours: UILabel!
    @IBOutlet weak var wedHours: UILabel!
    @IBOutlet weak var thuHours: UILabel!
    @IBOutlet weak var friHours: UILabel!
    @IBOutlet weak var satHours: UILabel!
    @IBOutlet weak var sunHours: UILabel!
    
    override func viewDidLoad() {
        self.setBackground()
        super.viewDidLoad()
        self.title = nameStr
        foodAddress1Lbl.text = address1Str
        foodAddress2Lbl.text = address2Str
        foodPhoneLbl.text = phoneStr
        foodRatingLbl.text = "\(rating!) / 5"
        foodCategoryLbl.text = categoryStr
        foodPriceLbl.text = priceStr
        monHours.text = hours["Mon"]?.joined(separator: ", ")
        tueHours.text = hours["Tue"]?.joined(separator: ", ")
        wedHours.text = hours["Wed"]?.joined(separator: ", ")
        thuHours.text = hours["Thu"]?.joined(separator: ", ")
        friHours.text = hours["Fri"]?.joined(separator: ", ")
        satHours.text = hours["Sat"]?.joined(separator: ", ")
        sunHours.text = hours["Sun"]?.joined(separator: ", ")
        

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEventFromFood"{
            if let destinationVC = segue.destination as? AddEventVC {
                destinationVC.fromFoodorPlace = true
                destinationVC.eventDate = self.eventDate
                destinationVC.eventDescStr = nameStr
                destinationVC.eventLocStr = "\(address1Str) \(address2Str)"
            }
        }
    }
 }
