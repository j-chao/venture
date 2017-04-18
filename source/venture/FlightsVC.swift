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
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var nonstop: UISwitch!
    var tripDate:String!
    var pickerValues = [[String]]()
    var adultCount:Int!
    var childCount:Int!
    var maxStops:Int!
    
    override func viewDidLoad() {
        self.setBackground()
        super.viewDidLoad()
        origin.attributedPlaceholder = NSAttributedString(
            string: "origin",
            attributes: [NSForegroundColorAttributeName:UIColor.lightGray])
        destination.attributedPlaceholder = NSAttributedString(
            string: "destination",
            attributes: [NSForegroundColorAttributeName:UIColor.lightGray])
       
       
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerValues = [["Adult Count", "1", "2", "3"],
                      ["Child Count", "0", "1", "2"],
                      ["Max Stops", "0", "1", "2", "3"]]
        
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
                "passengers" : ["adultCount" : self.adultCount,
                                "childCount" : self.childCount,
                                "maxStops" : self.maxStops],
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
            
                let ports = parseJson["trips"]["data"]["airport"]
                print (ports)
                // use GLOSS to parse?
        }
    }
    
    func getAirportCodes() {
        
    }
    

}

extension FlightsVC: UIPickerViewDelegate, UIPickerViewDataSource {
    // returns the number of 'columns' to display.
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerValues[component].count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerValues[component][row]
    }
    
    // Catpure the picker view selection
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            if row == 1 {
                adultCount = 1
            } else if row == 2 {
                adultCount = 2
            } else if row == 3 {
                adultCount = 3
            }
        }
        if component == 1 {
            if row == 1 {
                childCount = 0
            } else if row == 2 {
                childCount = 1
            } else if row == 3 {
                childCount = 2
            }
        }
        if component == 2 {
            if row == 1 {
                maxStops = 0
            } else if row == 2 {
                maxStops = 1
            } else if row == 3 {
                maxStops = 2
            } else if row == 4 {
                maxStops = 3
            }
        }
    }
}

extension FlightsVC {
    func presentAllFieldsAlert() {
        let alert = UIAlertController(title: "Error", message: "Please fill out all fields." , preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            (action:UIAlertAction) in
        }
        alert.addAction(OKAction)
        self.present(alert, animated: true, completion:nil)
        return
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

