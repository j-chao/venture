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
    
    @IBOutlet weak var email: UITextFieldX!
    @IBOutlet weak var password: UITextFieldX!
    @IBOutlet weak var errorMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        email.delegate = self
        password.delegate = self
        
        let fbLoginButton = FBSDKLoginButton()
        view.addSubview(fbLoginButton)
        fbLoginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
        
        fbLoginButton.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        let userID = defaults.string(forKey: "userID")
        if userID != nil {
            let storyboard: UIStoryboard = UIStoryboard(name: "trip", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "tripNavCtrl")
            self.show(vc, sender: self)
        }
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
        
        if String(describing: credential) != "" {
            FIRAuth.auth()?.signIn(with: credential, completion: {
                user, error in
                if error != nil {
                    self.errorMessage.text = "Incorrect email and/or password"
                }
                else {
                    FIRAuth.auth()?.currentUser!.link(with: credential) { (user, error) in
                        if user != nil && error == nil {
                            return
                        }
                    }
                    
                    let user = FIRAuth.auth()?.currentUser?.uid
                    let defaults = UserDefaults.standard
                    defaults.set(user, forKey: "userID")
                
                    let storyboard: UIStoryboard = UIStoryboard(name: "trip", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "tripNavCtrl")
                    self.show(vc, sender: self)
                }
            })
        }
    }
    
    @IBAction func login(_ sender: Any) {
        let credential = FIREmailPasswordAuthProvider.credential(withEmail: email.text!, password: password.text!)
        
        FIRAuth.auth()?.signIn(with: credential, completion: {
            user, error in
            if error != nil {
                self.errorMessage.text = "Incorrect email and/or password"
            }
            else {
                let ref: FIRDatabaseReference! = FIRDatabase.database().reference()
                let userID = FIRAuth.auth()?.currentUser?.uid
               
                let defaults = UserDefaults.standard
                defaults.set(userID, forKey: "userID")
                
                ref.child("users/\(userID!)/email").setValue(self.email.text!)
                ref.child("users/\(userID!)/password").setValue(self.password.text!)
                
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
