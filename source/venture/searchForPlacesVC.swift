//
//  searchForPlacesVC.swift
//  venture
//
//  Created by Julianne Crea on 4/8/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import UIKit

class searchForPlacesVC: UIViewController {

    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var ratingField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search for Places"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
