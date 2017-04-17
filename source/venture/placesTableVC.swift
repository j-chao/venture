//
//  placesTableVC.swift
//  venture
//
//  Created by Julianne Crea on 4/8/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import UIKit

class placesTableVC: UITableViewController {
    
    var locales:[String] = []
    var placeRatings:[String] = []
    var busCat:[String] = []
    var imgUrls = [URL]()
    var reviewCounts = [String]()
    var addresses = [String]()
    var zipCodes = [String]()
    var streets = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Places"
        self.tableView.dataSource = self
        self.tableView.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locales.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath) as! placeCell
        cell.placenameLabel?.text = locales[indexPath.row]
        cell.ratingLabel?.text = placeRatings[indexPath.row]
        cell.categoryLable?.text = busCat[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegue(withIdentifier: "toDetails", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetails" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let destVC = segue.destination as! placeVC
                destVC.nameStr = self.locales[indexPath.row]
                destVC.catStr = self.busCat[indexPath.row]
                destVC.ratingStr = self.placeRatings[indexPath.row]
                destVC.reviewStr = self.reviewCounts[indexPath.row]
                destVC.imgStr = self.imgUrls[indexPath.row]
                destVC.addressStr = self.addresses[indexPath.row]
                destVC.zipStr = self.zipCodes[indexPath.row]
                destVC.streetStr = self.streets[indexPath.row]
            }
        }
    }
    
}
