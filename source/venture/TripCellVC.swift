//
//  TripCellVC.swift
//  venture
//
//  Created by Justin Chao on 3/18/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import UIKit
import Foundation

class TripCellVC: UICollectionViewCell {
    
    var startDate:String?
    var endDate:String?
    
    @IBOutlet weak var tripName: UILabel!
    @IBOutlet weak var tripLocation: UILabel!
    @IBOutlet weak var dates: UILabel!
    @IBOutlet weak var deleteLabel: UILabel!
}
