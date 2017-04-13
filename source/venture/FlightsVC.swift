//
//  FlightsVC.swift
//  venture
//
//  Created by Justin Chao on 4/10/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import UIKit
import Alamofire

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
    }
    
    
    @IBAction func findFlights(_ sender: UIButton) {
        self.makePost()
//        self.makeGetCall()
    }
    
    
    func makeGetCall() {
        let todoEndpoint: String = "https://www.googleapis.com/qpxExpress/v1/trips/search"
        Alamofire.request(todoEndpoint)
            .responseJSON { response in
                // check for errors
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling GET on /todos/1")
                    print(response.result.error!)
                    return
                }
                
                // make sure we got some JSON since that's what we expect
                guard let json = response.result.value as? [String: Any] else {
                    print("didn't get todo object as JSON from API")
                    print("Error: \(response.result.error)")
                    return
                }
                
                // get and print the title
                guard let todoTitle = json["title"] as? String else {
                    print("Could not get todo title from JSON")
                    return
                }
                
                print("The title is: " + todoTitle)
        }
        
    }
    
    func makePost() {
        let url: String = "https://www.googleapis.com/qpxExpress/v1/trips/search/?key=AIzaSyAJf-FwVx2T_kBXfdlBxM6UTY-SPczX5ds"
        let params: [String: Any] = ["request/slice/origin": "Dallas", "request/slice/destination": "Austin", "request/slice/date": "2014-09-19"]
        
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON { response in
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling POST")
                    print(response.result.error!)
                    return
                }
                // make sure we got some JSON since that's what we expect
                guard let json = response.result.value as? [String: Any] else {
                    print("didn't get todo object as JSON from API")
                    print("Error: \(response.result.error)")
                    return
                }
                
                print (json)
                
        }
    }

}
