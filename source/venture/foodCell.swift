//
//  foodCell.swift
//  venture
//
//  Created by Connie Liu on 4/10/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import UIKit

class foodCell: UITableViewCell {


    @IBOutlet weak var foodNameLbl: UILabel!
    @IBOutlet weak var foodCategoryLbl: UILabel!
    @IBOutlet weak var foodRatingLbl: UILabel!
    @IBOutlet weak var foodDistanceLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
