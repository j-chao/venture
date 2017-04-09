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
    
    @IBAction func dismissPopup(_ sender: UIButton) {
        dismiss(animated:true, completion: nil)
    }

    @IBOutlet weak var newEmail: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var messageLbl: UILabel!
    
    @IBAction func registerAction(_ sender: Any) {
        FIRAuth.auth()?.createUser(withEmail: newEmail.text!, password: newPassword.text!, completion:{
           user, error in
            if error != nil {
                if self.newPassword.text!.characters.count < 6 {
                    self.messageLbl.text = "Password must be at least \n6 characters long."
                }
                else {
                    self.messageLbl.text = "User account already exists."
                }
            }
            else {
                self.signIn()
            }
        })
    }
    
    func signIn() {
        let credential = FIREmailPasswordAuthProvider.credential(withEmail: self.newEmail.text!, password: self.newPassword.text!)
        
        FIRAuth.auth()?.signIn(with: credential, completion: {
            user, error in
            if error != nil {
                print (error as Any)
            }
            else {
                let ref: FIRDatabaseReference! = FIRDatabase.database().reference()
                let userID = FIRAuth.auth()?.currentUser?.uid
                
                let defaults = UserDefaults.standard
                defaults.set(userID, forKey: "userID")
                
                ref.child("users/\(userID!)/email").setValue(self.newEmail.text!)
                ref.child("users/\(userID!)/password").setValue(self.newPassword.text!)
                
                let storyboard: UIStoryboard = UIStoryboard(name: "trip", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "tripNavCtrl")
                self.show(vc, sender: self)
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
