//
//  FlightCellVC.swift
//  venture
//
//  Created by Justin Chao on 4/18/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import UIKit

class FlightCellVC: UITableViewCell {

    @IBOutlet weak var flightLabel: UILabel!
    @IBOutlet weak var timeFrameLabel: UILabel!
    @IBOutlet weak var saleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
