//
//  foodVC.swift
//  venture
//
//  Created by Connie Liu on 4/10/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import UIKit

class foodVC: UIViewController {

    var restaurant:Restauraunt!
    var eventDate:Date!
    
    @IBOutlet weak var foodAddress1Lbl: UILabel!
    @IBOutlet weak var foodAddress2Lbl: UILabel!
    @IBOutlet weak var foodPhoneLbl: UILabel!
    @IBOutlet weak var foodRatingLbl: UILabel!
    @IBOutlet weak var foodCategoryLbl: UILabel!
    
    override func viewDidLoad() {
        self.setBackground()
        super.viewDidLoad()
        self.title = restaurant.name
        foodAddress1Lbl.text = restaurant.address
        foodAddress2Lbl.text = "\(restaurant.city!), \(restaurant.state!) \(restaurant.zip!)"
        foodPhoneLbl.text = restaurant.phone
        foodRatingLbl.text = "\(restaurant.rating!)"
        foodCategoryLbl.text = restaurant.category
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEventFromFood"{
            if let destinationVC = segue.destination as? AddEventVC {
                destinationVC.fromFoodorPlace = true
                destinationVC.eventDate = self.eventDate
                destinationVC.eventDescStr = restaurant.name
                destinationVC.eventLocStr = "\(restaurant.address!) \(restaurant.city!), \(restaurant.state!) \(restaurant.zip!)"
            }
        }
    }
 }
