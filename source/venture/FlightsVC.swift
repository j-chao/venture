//
//  FlightsVC.swift
//  venture
//
//  Created by Justin Chao on 4/10/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import UIKit

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
        self.makeGetCall()
    }
    
    
    func makeGetCall() {
        
    }

}
