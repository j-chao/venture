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
        
        self.googleFlights()
    }
    
    
    @IBAction func findFlights(_ sender: UIButton) {
        self.googleFlights()
    }
    
    
    func todo() {
        let url:String = "https://www.googleapis.com/qpxExpress/v1/trips/search"
        Alamofire.request(url).responseJSON { response in
                // check for errors
                guard response.result.error == nil else {
                    print("error googling flights")
                    print(response.result.error!)
                    return
                }
                
                // make sure we got some JSON since that's what we expect
                guard let json = response.result.value as? [String: Any] else {
                    print("error getting JSON data for flights")
                    print("Error: \(response.result.error)")
                    return
                }
                
                // get and print the title
                guard let title = json["title"] as? String else {
                    print("Could not get todo title from JSON")
                    return
                }
           
            print (title)
        }
        
    }
   
//    let kIssuer = "https://accounts.google.com"
//    let kClientID = "652082118801-f5iqulit5ornu96b2g4cp45fo4nq8qn9.apps.googleusercontent.com"
//    let kRedirectURI = "com.googleusercontent.apps.652082118801-f5iqulit5ornu96b2g4cp45fo4nq8qn9:/oauthredirect"
    
//    func getToken() {
//        let url:String = "https://accounts.google.com/o/oauth2/v2/auth"
//        let params: [String:Any] =
//        ["client_id":"652082118801-f5iqulit5ornu96b2g4cp45fo4nq8qn9.apps.googleusercontent.com",
//         "redirect_uri":"com.example.app:redirect_uri_path" ,
//         "response_type":"nil"
//         ]
//    }
    
    
    
    func googleFlights() {
        let key = "AIzaSyAJf-FwVx2T_kBXfdlBxM6UTY-SPczX5ds"
        let url:String
            = "https://www.googleapis.com/qpxExpress/v1/trips/search/?key=\(key)"
        
        let params: [String: Any]
            = ["request/slice/origin": "Dallas",
               "request/slice/destination": "Austin",
               "request/slice/date": "2014-09-19"]
        
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON { response in
                guard response.result.error == nil else {
                    print("error googling flights")
                    print(response.result.error!)
                    return
                }
                // make sure we got some JSON since that's what we expect
                guard let json = response.result.value as? [String: Any] else {
                    print("error getting JSON from google flights")
                    print("Error: \(response.result.error)")
                    return
                }
                
                print (json)
        }
    }

}
