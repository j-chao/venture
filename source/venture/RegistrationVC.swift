//
//  RegistrationVC.swift
//  venture
//
//  Created by Justin Chao on 3/16/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import UIKit
import Firebase

class RegistrationVC: UIViewController {

    @IBOutlet weak var newEmail: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    
    @IBOutlet weak var resetEmail: UITextField!
    @IBOutlet weak var resetMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func createAccount(_ sender: Any) {
        FIRAuth.auth()?.createUser(withEmail: newEmail.text!, password: newPassword.text!, completion:{
           user, error in
//          where account is already created
            if error != nil{
                print ("User account already exists")
            }
            else {
                print ("User created")
            }
        })

    }
    
    @IBAction func resetPass(_ sender: Any) {
        FIRAuth.auth()?.sendPasswordReset(withEmail: resetEmail.text!, completion:{
            error in
            
            if error != nil {
                print ("no account for email in database")
            }
            else {
                print ("reset password email sent")
                self.resetMessage.text! =
                "An email will be sent to you to reset your password."
            }
        })
}
    
}
