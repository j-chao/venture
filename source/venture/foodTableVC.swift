//
//  foodTableVC.swift
//  venture
//
//  Created by Connie Liu on 4/10/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import UIKit

class foodTableVC: UITableViewController {

    var restaurants = [String]()
    var id = [String]()
    var distance = [Decimal]()
    var address1 = [String]()
    var address2 = [String]()
    var category = [String]()
    var rating = [Decimal]()
    var phone = [String]()
    var price = [String]()
    
    var eventDate:Date!

    override func viewDidLoad() {
        self.setBackground()
        super.viewDidLoad()
        self.title = "Food"
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        if parent == nil{
            restaurants.removeAll(keepingCapacity: false)
            id.removeAll()
            distance.removeAll()
            address1.removeAll()
            address2.removeAll()
            category.removeAll()
            rating.removeAll()
            phone.removeAll()
            price.removeAll()
            //hours.removeAll()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodCell", for: indexPath) as! foodCell

        cell.foodNameLbl.text = restaurants[indexPath.row]
        cell.foodCategoryLbl.text = category[indexPath.row]
        cell.foodRatingLbl.text = "\(rating[indexPath.row]) / 5"
        cell.foodDistanceLbl.text = "\(distance[indexPath.row]) m"
        return cell
    }

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     if segue.identifier == "toFoodVC" {
         if let vc = segue.destination as? foodVC ,
         let indexPath = self.tableView.indexPathForSelectedRow {
            vc.nameStr = self.restaurants[indexPath.row]
            vc.address1Str = self.address1[indexPath.row]
            vc.address2Str = self.address2[indexPath.row]
            vc.categoryStr = self.category[indexPath.row]
            vc.rating = self.rating[indexPath.row]
            vc.phoneStr = self.phone[indexPath.row]
            vc.priceStr = self.price[indexPath.row]
            vc.eventDate = self.eventDate
            }
        }
    }
}
