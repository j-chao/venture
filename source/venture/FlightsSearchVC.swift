//
//  FlightsSearchVC.swift
//  venture
//
//  Created by Justin Chao on 4/10/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FlightsSearchVC: UIViewController {

    @IBOutlet weak var origin: UITextFieldX!
    @IBOutlet weak var destination: UITextFieldX!
    @IBOutlet weak var pickerView: UIPickerView!
    var myRequest = DispatchGroup()
    var eventDate:Date!
    var tripDate:String!
    var dateNS:Date!
    var pickerValues = [[String]]()
    var adultCount:Int!
    var childCount:Int!
    var maxStops:Int!
    var resultCount = -1
    var parseJson:JSON!
    var departureTimeArray = [Date]()
    var arrivalTimeArray = [Date]()
    var durationArray = [String]()
    var saleTotalArray = [String]()
    var flightNumberArray = [String]()
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        activity.hidesWhenStopped = true
        self.setBackground()
        super.viewDidLoad()
        pickerView.backgroundColor = .white
        pickerView.setValue(0.6, forKeyPath: "alpha")
        origin.attributedPlaceholder = NSAttributedString(
            string: "origin",
            attributes: [NSForegroundColorAttributeName:UIColor.lightGray])
        destination.attributedPlaceholder = NSAttributedString(
            string: "destination",
            attributes: [NSForegroundColorAttributeName:UIColor.lightGray])
       
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerValues = [["Adult Count", "1", "2", "3"],
                      ["Child Count", "0", "1", "2"]]
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        resultCount = -1
        adultCount = 0
        childCount = 0
    }
    
    @IBAction func findFlights(_ sender: UIButton) {
        self.activity.startAnimating()
        if origin.text!.isEmpty || destination.text!.isEmpty {
            self.presentAllFieldsAlert()
        } else {
            self.googleFlights()
        }
        self.activity.stopAnimating()
    }

    func googleFlights() {
        myRequest.enter()
        let key = "AIzaSyAJf-FwVx2T_kBXfdlBxM6UTY-SPczX5ds"
        let url:String
            = "https://www.googleapis.com/qpxExpress/v1/trips/search/?key=\(key)"
        
        let params:[String:Any] = [
            "request" : [
                "passengers" : ["adultCount" : self.adultCount,
                                "childCount" : self.childCount,
                                "maxStops" : 0],
                "slice" : [["origin" : self.origin.text!,
                            "destination" : self.destination.text!,
                            "date" : self.tripDate,
                            "maxStops" : 3]],
                "solutions" : 30
            ],
        ]
        
        Alamofire.request(url, method: .post, parameters: params,
            encoding: JSONEncoding.default).responseJSON { response in
                guard response.result.error == nil else {
                    print("error googling flights")
                    print(response.result.error!)
                    return
                }
                guard let rawJson = response.result.value as? [String: Any] else {
                    print("error getting JSON from google flights")
                    print("Error: \(response.result.error)")
                    return
                }
                
                self.parseJson = JSON(rawJson)
                var i = 0
                var sale = self.parseJson["trips"]["tripOption"][0]["saleTotal"]
               
                if sale != JSON.null {
                    while sale != JSON.null {
                        sale = self.parseJson["trips"]["tripOption"][i]["saleTotal"]
                        self.resultCount = self.resultCount + 1
                        i = i + 1
                    }
                }
                
                self.myRequest.leave()
                self.myRequest.notify(queue: DispatchQueue.main, execute: {
                    print ("resultCount: \(self.resultCount)")
                    if self.resultCount < 0 {
                        self.presentNoFlightsAlert()
                    } else {
                        self.getDeparture()
                        self.getArrival()
                        self.getDuration()
                        self.getSaleTotal()
                        self.getFlightNumber()
                        self.segueToTable()
                    }
                })
        }
    }
  
    func getDeparture() {
        for i in (0..<self.resultCount) {
            let departTime = self.parseJson["trips"]["tripOption"][i]["slice"][0]["segment"][0]["leg"][0]["departureTime"].string
            let dTime = timeFromStringTime(timeStr: departTime!.substring(with: 11..<16))
            self.departureTimeArray.append(dTime)
        }
    }
    
    func getArrival() {
        for i in (0..<self.resultCount) {
            let arrivalTime = self.parseJson["trips"]["tripOption"][i]["slice"][0]["segment"][0]["leg"][0]["arrivalTime"].string
            let dTime = timeFromStringTime(timeStr:arrivalTime!.substring(with: 11..<16))
            self.arrivalTimeArray.append(dTime)
        }
    }
   
    func getDuration() {
        for i in (0..<self.resultCount) {
            let duration = self.parseJson["trips"]["tripOption"][i]["slice"][0]["duration"].int
            let durationStr = minutesToHoursMinutes(minutes: duration!)
            self.durationArray.append(durationStr)
        }
    }
    
    func getSaleTotal() {
        for i in (0..<self.resultCount) {
            let sale = self.parseJson["trips"]["tripOption"][i]["saleTotal"].string
            let saleStr = sale?.substring(from: 3)
            self.saleTotalArray.append("$\(saleStr!)")
        }
    }
    
    func getFlightNumber() {
        for i in (0..<self.resultCount) {
            let carrier = self.parseJson["trips"]["tripOption"][i]["slice"][0]["segment"][0]["flight"]["carrier"].string
            let num = self.parseJson["trips"]["tripOption"][i]["slice"][0]["segment"][0]["flight"]["number"].string
            self.flightNumberArray.append("\(carrier!)\(num!)")
        }
    }
    
}

extension FlightsSearchVC: UIPickerViewDelegate, UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerValues[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerValues[component][row]
    }
    
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
    }
}

extension FlightsSearchVC {
    func segueToTable() {
        let vc = UIStoryboard(name:"flights", bundle:nil).instantiateViewController(withIdentifier: "flightsTable") as! FlightsTableVC
        vc.departureTimeArray = self.departureTimeArray
        vc.arrivalTimeArray = self.arrivalTimeArray
        vc.durationArray = self.durationArray
        vc.saleTotalArray = self.saleTotalArray
        vc.flightNumberArray = self.flightNumberArray
        vc.tripDate = self.tripDate
        vc.eventDate = self.eventDate
        let destArrival = "\(self.origin.text!) - \(self.destination.text!)"
        vc.destArrival = destArrival
        self.show(vc, sender: self)
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
    
    func presentNoFlightsAlert() {
        let alert = UIAlertController(title: "Sorry", message: "No flights were found." , preferredStyle: .alert)
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
