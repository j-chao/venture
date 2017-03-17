//
//  Login.swift
//  venture
//
//  Created by Justin Chao on 3/6/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {

    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        email.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSForegroundColorAttributeName:UIColor.lightGray])
        
        password.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSForegroundColorAttributeName:UIColor.lightGray])
    }
   
    @IBAction func login(_ sender: Any) {
        FIRAuth.auth()?.signIn(withEmail: email.text!, password: password.text!, completion: {
            
            user, error in
            if error != nil {
                print ("Incorrect email/password")
            }
            else{
                print ("User logged in!")
                
                let storyboard: UIStoryboard = UIStoryboard(name: "itinerary", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "Your Trips")
                    as! UITableViewController
                self.show(vc, sender: self)
            }
        })
    }
    
}
