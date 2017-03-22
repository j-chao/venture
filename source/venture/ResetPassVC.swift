//
//  ResetPassVC.swift
//  venture
//
//  Created by Justin Chao on 3/17/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import UIKit
import Firebase

class ResetPassVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var resetEmail: UITextField!
    @IBOutlet weak var resetMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetEmail.attributedPlaceholder = NSAttributedString(
            string: "Enter your email",
            attributes: [NSForegroundColorAttributeName:UIColor.lightGray])
        resetEmail.delegate = self
    }
   
    @IBAction func resetPass(_ sender: Any) {
        FIRAuth.auth()?.sendPasswordReset(withEmail: resetEmail.text!, completion: {
            error in
            if error == nil {
                self.resetMessage.text! =
                "Please enter your email."
            }
            if error != nil {
                self.resetMessage.text! =
                "No account has been created with that email."
            }
            else {
                self.resetMessage.text! =
                "An email will be sent to you to reset your password."
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
