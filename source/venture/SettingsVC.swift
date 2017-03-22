//
//  SettingsVC.swift
//  venture
//
//  Created by Justin Chao on 3/17/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import UIKit
import Firebase

class SettingsVC: UIViewController {
    
    var alertController:UIAlertController? = nil
    var newEmail: UITextField? = nil
    var newPassword: UITextField? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func changeEmail(_ sender: Any) {
        self.alertController = UIAlertController(title: "Change Email", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            FIRAuth.auth()?.currentUser?.updateEmail((self.newEmail?.text!)!) {
                (error) in
                if error != nil {
                    print ("update email error")
                }
                else {
                    print ("email updated")
                }
            }
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (action) -> Void in
        }
        
        self.alertController!.addAction(ok)
        self.alertController!.addAction(cancel)
        
        self.alertController!.addTextField { (textField) -> Void in
            self.newEmail = textField
            self.newEmail?.placeholder = "enter new email"
        }
        present(self.alertController!, animated: true, completion: nil)
    }
    
    @IBAction func changePassword(_ sender: Any) {
        self.alertController = UIAlertController(title: "Change Password", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            FIRAuth.auth()?.currentUser?.updatePassword((self.newPassword?.text!)!) { (error) in
                if error != nil {
                    // Firebase requires a minimum length 6-characters password
                    print ("password lenght too short/weak")
                }
                else {
                    print ("password changed")
                }
            }
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (action) -> Void in
        }
        
        self.alertController!.addAction(ok)
        self.alertController!.addAction(cancel)
        
        self.alertController!.addTextField { (textField) -> Void in
            self.newPassword = textField
            self.newPassword?.placeholder = "enter new password"
        }
        present(self.alertController!, animated: true, completion: nil)
    }
    
    @IBAction func deleteAccount(_ sender: Any) {
        
        self.alertController = UIAlertController(title: "Delete Account", message: "Are you sure you want to delete your account?", preferredStyle: UIAlertControllerStyle.alert)
        
        let ok = UIAlertAction(title: "Delete", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            
            let user = FIRAuth.auth()?.currentUser
            user?.delete { error in
                if error != nil {
                    print ("delete account error")
                } else {
                    print ("account deleted")
                    let storyboard: UIStoryboard = UIStoryboard(name: "login", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "Login")
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }
            }
        
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (action) -> Void in
        }
        
        self.alertController!.addAction(ok)
        self.alertController!.addAction(cancel)
        
        present(self.alertController!, animated: true, completion: nil)
        
    }
}
