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
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var nonstop: UISwitch!
    
    override func viewDidLoad() {
        self.setBackground()
        super.viewDidLoad()
        origin.attributedPlaceholder = NSAttributedString(
            string: "origin",
            attributes: [NSForegroundColorAttributeName:UIColor.lightGray])
        destination.attributedPlaceholder = NSAttributedString(
            string: "destination",
            attributes: [NSForegroundColorAttributeName:UIColor.lightGray])
    
        
        self.googleFlights()
    }
    
    
    @IBAction func findFlights(_ sender: UIButton) {
        self.googleFlights()
    }
    

    func googleFlights() {
        let key = "AIzaSyAJf-FwVx2T_kBXfdlBxM6UTY-SPczX5ds"
        let url:String
            = "https://www.googleapis.com/qpxExpress/v1/trips/search/?key=\(key)"
        
        let params:[String:Any] = [
            "request" : [
                "passengers" : ["adultCount" : 1],
                "slice" : [["origin":"DFW", "destination":"RDU", "date":"2017-04-20"]],
                "solutions" : 1
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
                let price = parseJson["trips"]["tripOption"][0]["saleTotal"].string
                let duration = parseJson["trips"]["tripOption"][0]["slice"][0]["duration"].int
                print("price = \(price!)")
                print(duration!)
                
                // use GLOSS to parse?
        }
    }

}

