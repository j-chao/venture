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
    
    @IBAction func dismissPopup(_ sender: UIButton) {
        dismiss(animated:true, completion: nil)
    }
   
    @IBAction func resetPass(_ sender: UIButton) {
        FIRAuth.auth()?.sendPasswordReset(withEmail: resetEmail.text!, completion: {
            error in
            if error == nil {
                self.resetMessage.text! =
                "Please enter your email."
            } else if error != nil {
                self.resetMessage.text! =
                "No account has been created \nwith that email."
            } else {
                self.resetMessage.text! =
                "An email will be sent to you \nto reset your password."
            }
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
