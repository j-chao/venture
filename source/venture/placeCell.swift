//
//  placeCell.swift
//  venture
//
//  Created by Julianne Crea on 4/8/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import UIKit

class placeCell: UITableViewCell {

    @IBOutlet weak var placenameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! placeCell
        
        // Configure  cell
        //let index:Int = indexPath.row
        
        //cell.placenameLabel!.text = placeName
        //cell.categoryLabel!.text = category
        //cell.ratingLabel!.text = rating
        
        return cell
    }

}
