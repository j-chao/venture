//
//  AddEvent.swift
//  venture
//
//  Created by Justin Chao on 3/24/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import UIKit

class AddEventVC: UIViewController {

    @IBOutlet weak var eventDesc: UITextField!
    @IBOutlet weak var eventLoc: UITextField!
    @IBOutlet weak var eventTime: UIDatePicker!
    @IBOutlet weak var eventTimeLbl: UILabel!
    
    var date:Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventDesc.attributedPlaceholder = NSAttributedString(string: "event description", attributes: [NSForegroundColorAttributeName:UIColor.lightGray])
        eventLoc.attributedPlaceholder = NSAttributedString(string: "event location", attributes: [NSForegroundColorAttributeName:UIColor.lightGray])
       
        let dateTitle = stringLongFromDate(date: date)
        self.eventTimeLbl.text = dateTitle
    }
    
    @IBAction func addEvent(_ sender: Any) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
