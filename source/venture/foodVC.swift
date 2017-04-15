//
//  foodVC.swift
//  venture
//
//  Created by Connie Liu on 4/10/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import UIKit

class foodVC: UIViewController {

    var restaurant:Restauraunt!
    
    @IBOutlet weak var foodAddress1Lbl: UILabel!
    @IBOutlet weak var foodAddress2Lbl: UILabel!
    @IBOutlet weak var foodPhoneLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = restaurant.name
        foodAddress1Lbl.text = restaurant.address
        foodAddress2Lbl.text = "\(restaurant.city!), \(restaurant.state!) \(restaurant.zip!)"
        foodPhoneLbl.text = restaurant.phone

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
