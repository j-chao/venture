//
//  Login.swift
//  venture
//
//  Created by Justin Chao on 3/6/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class LoginVC: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        email.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSForegroundColorAttributeName:UIColor.lightGray])
        password.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSForegroundColorAttributeName:UIColor.lightGray])
        email.delegate = self
        password.delegate = self
        
        let fbLoginButton = FBSDKLoginButton()
        view.addSubview(fbLoginButton)
        fbLoginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
        
        fbLoginButton.delegate = self

    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print ("Did log out of facebook")
    }
   
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print (error)
            return
        }
        
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
        FIRAuth.auth()?.signIn(with: credential, completion: {
            user, error in
            if error != nil {
                print ("Incorrect email/password")
                self.errorMessage.text = "Incorrect email and/or password"
            }
            else {
                print ("User logged in with Facebook !")
                
                FIRAuth.auth()?.currentUser!.link(with: credential) { (user, error) in
                    if user != nil && error == nil {
                        return
                    }
                }
                
                let storyboard: UIStoryboard = UIStoryboard(name: "trip", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "tripNavCtrl")
                self.show(vc, sender: self)
            }
        })
        
        
    }
    
    @IBAction func login(_ sender: Any) {
        
    let credential = FIREmailPasswordAuthProvider.credential(withEmail: email.text!, password: password.text!)
        
        FIRAuth.auth()?.signIn(with: credential, completion: {
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
