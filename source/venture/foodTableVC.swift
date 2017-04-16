//
//  foodTableVC.swift
//  venture
//
//  Created by Connie Liu on 4/10/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import UIKit

class foodTableVC: UITableViewController {

    var restaurants = [Restauraunt]()
// currently if the user searches for food and goes back with different search location, it just adds the new results to the already existing array of food places. so figure out how to have array data erased when user clicks back button

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Food"
        print (restaurants[0].name)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodCell", for: indexPath) as! foodCell

        // Configure the cell...
        cell.foodNameLbl.text = restaurants[indexPath.row].name
        cell.foodCategoryLbl.text = restaurants[indexPath.row].category
        cell.foodRatingLbl.text = "\(restaurants[indexPath.row].rating!)"
        return cell
    }


    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */





    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     if segue.identifier == "toFoodVC" {
     if let destinationVC = segue.destination as? foodVC ,
     let indexPath = self.tableView.indexPathForSelectedRow {
     let selectedFood = restaurants[indexPath.row]
     destinationVC.restaurant = selectedFood
        }}
    }
}
