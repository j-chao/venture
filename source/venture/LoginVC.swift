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
    
    var ref: FIRDatabaseReference!
    let ref = FIRDatabase.database().reference()
    var user = firebase.auth().currentUser;

    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    
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
                self.errorMessage.text = "Incorrect email and/or password"
            }
            else{
                print ("User logged in!")
                print (user)
                let storyboard: UIStoryboard = UIStoryboard(name: "trip", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "Your Trips")
                self.show(vc, sender: self)
            }
        })
    }
}
