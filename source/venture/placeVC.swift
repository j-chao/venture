//
//  placeVC.swift
//  venture
//
//  Created by Julianne Crea on 4/8/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import UIKit

class placeVC: UIViewController {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var catLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var reviewCountLbl: UILabel!
    
    var nameStr:String?
    var catStr:String?
    var ratingStr:String?
    var reviewStr:String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let nameStr = nameStr {
            nameLbl.text = nameStr
        }
        if let catStr = catStr {
            catLbl.text = catStr
        }
        if let ratingStr = ratingStr {
            ratingLbl.text = ratingStr
        }
        if let reviewStr = reviewStr {
            reviewCountLbl.text = reviewStr
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Place"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
