//
//  FlightsTableVC.swift
//  venture
//
//  Created by Justin Chao on 4/18/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import UIKit

class FlightsTableVC: UITableViewController {
    var departureTimeArray = [Date]()
    var arrivalTimeArray = [Date]()
    var durationArray = [String]()
    var saleTotalArray = [String]()
    var flightNumberArray = [String]()
    var destArrival:String!
    var tripDate:String!
    var eventDate:Date!

    override func viewDidLoad() {
        self.setBackground()
        super.viewDidLoad()
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        if parent == nil{
            departureTimeArray.removeAll()
            arrivalTimeArray.removeAll()
            durationArray.removeAll()
            saleTotalArray.removeAll()
            flightNumberArray.removeAll()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.saleTotalArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "flightCell", for: indexPath) as! FlightCellVC
        
        cell.flightLabel.text = flightNumberArray[indexPath.row]
        cell.saleLabel.text = saleTotalArray[indexPath.row]
        
        let departureTimeDate = departureTimeArray[indexPath.row]
        let departureTimeStr = stringTimefromDate(date: departureTimeDate)
        let arrivalTimeDate = arrivalTimeArray[indexPath.row]
        let arrivalTimeStr = stringTimefromDate(date: arrivalTimeDate)
        
        let timeFrame = "\(departureTimeStr) - \(arrivalTimeStr)"
        cell.timeFrameLabel.text = timeFrame

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFlightDetail" {
            if let destinationVC = segue.destination as? FlightDetailsVC ,
            let indexPath = self.tableView.indexPathForSelectedRow {
                destinationVC.destArrival = self.destArrival
                destinationVC.tripDate = self.tripDate
                destinationVC.eventDate = self.eventDate
                destinationVC.departureTimeDate = departureTimeArray[indexPath.row]
                destinationVC.arrivalTimeDate = arrivalTimeArray[indexPath.row]
                destinationVC.duration = durationArray[indexPath.row]
                destinationVC.saleTotal = saleTotalArray[indexPath.row]
                destinationVC.flightNumber = flightNumberArray[indexPath.row]
            }
        }
    }
    

}
