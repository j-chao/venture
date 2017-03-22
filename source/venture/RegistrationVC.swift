//
//  RegistrationVC.swift
//  venture
//
//  Created by Justin Chao on 3/16/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import UIKit
import Firebase

class RegistrationVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var newEmail: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newEmail.attributedPlaceholder = NSAttributedString(
            string: "Enter your email",
            attributes: [NSForegroundColorAttributeName:UIColor.lightGray])
        newPassword.attributedPlaceholder = NSAttributedString(
            string: "Enter a password",
            attributes: [NSForegroundColorAttributeName:UIColor.lightGray])
        newEmail.delegate = self
        newPassword.delegate = self
    }

    @IBAction func createAccount(_ sender: Any) {
        FIRAuth.auth()?.createUser(withEmail: newEmail.text!, password: newPassword.text!, completion:{
           user, error in
            if error != nil {
                print ("User account already exists")
            }
            else {
                print ("User created")
                let storyboard: UIStoryboard = UIStoryboard(name: "login", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "Login")
                self.show(vc, sender: self)
            }
        })
    }
    
    @IBAction func returnToLogin(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Login")
        self.show(vc, sender: self)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
