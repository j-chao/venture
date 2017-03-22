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
            else {
                print ("User logged in!")
                let ref: FIRDatabaseReference! = FIRDatabase.database().reference()
                let userID = FIRAuth.auth()?.currentUser?.uid
                ref.child("users/\(userID)/email").setValue(self.email.text!)
                ref.child("users/\(userID)/password").setValue(self.password.text!)
                
                let storyboard: UIStoryboard = UIStoryboard(name: "trip", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "tripNavCtrl")
                self.show(vc, sender: self)
            }
        })
    }
}
