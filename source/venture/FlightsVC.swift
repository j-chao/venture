//
//  FlightsVC.swift
//  venture
//
//  Created by Justin Chao on 4/10/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FlightsVC: UIViewController {

    @IBOutlet weak var origin: UITextFieldX!
    @IBOutlet weak var destination: UITextFieldX!
    @IBOutlet weak var adultCountPicker: UIPickerView!
    @IBOutlet weak var nonstop: UISwitch!
    var tripDate:String!
    var pickerValues = [[String]]()
    
    override func viewDidLoad() {
        self.setBackground()
        super.viewDidLoad()
        origin.attributedPlaceholder = NSAttributedString(
            string: "origin",
            attributes: [NSForegroundColorAttributeName:UIColor.lightGray])
        destination.attributedPlaceholder = NSAttributedString(
            string: "destination",
            attributes: [NSForegroundColorAttributeName:UIColor.lightGray])
       
       
        adultCountPicker.delegate = self
        adultCountPicker.dataSource = self
        pickerValues = [["Adult Count", "1", "2", "3", "4", "5"],
                      ["Child Count", "1", "2", "3", "4", "5"],
                      ["Max Stops", "1", "2", "3", "4", "5"]]
        
    }
    
    @IBAction func findFlights(_ sender: UIButton) {
        if origin.text!.isEmpty || destination.text!.isEmpty {
            self.presentAllFieldsAlert()
        } else {
            self.googleFlights()
        }
    }

    func googleFlights() {
        let key = "AIzaSyAJf-FwVx2T_kBXfdlBxM6UTY-SPczX5ds"
        let url:String
            = "https://www.googleapis.com/qpxExpress/v1/trips/search/?key=\(key)"
        
        let params:[String:Any] = [
            "request" : [
                "passengers" : ["adultCount" : 1,
                                "childCount" : 0],
                "slice" : [["origin" : self.origin.text!,
                            "destination" : self.destination.text!,
                            "date" : self.tripDate,
                            "maxStops" : 3]],
                "solutions" : 10
            ],
        ]
        
        Alamofire.request(url, method: .post, parameters: params,
            encoding: JSONEncoding.default).responseJSON { response in
                guard response.result.error == nil else {
                    print("error googling flights")
                    print(response.result.error!)
                    return
                }
                guard let json = response.result.value as? [String: Any] else {
                    print("error getting JSON from google flights")
                    print("Error: \(response.result.error)")
                    return
                }
                print (json)
               
              
                let parseJson = JSON(json)
                
                guard let price = parseJson["trips"]["tripOption"][0]["saleTotal"].string else {
                    print ("no flights found")
                    return
                }
                
                let duration = parseJson["trips"]["tripOption"][0]["slice"][0]["duration"].int
                print("price = \(price)")
                print(duration!)
                
                // use GLOSS to parse?
        }
    }

}

extension FlightsVC: UIPickerViewDelegate, UIPickerViewDataSource {
    // returns the number of 'columns' to display.
    public func numberOfComponents(in adultCountPicker: UIPickerView) -> Int {
        return 3
    }
    
    // returns the # of rows in each component..
    func pickerView(_ adultCountPicker: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerValues[component].count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ adultCountPicker: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerValues[component][row]
    }
   
    func presentAllFieldsAlert() {
        let alert = UIAlertController(title: "Error", message: "Please fill out all fields." , preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            (action:UIAlertAction) in
        }
        alert.addAction(OKAction)
        self.present(alert, animated: true, completion:nil)
        return
    }
}

