//
//  Background.swift
//  venture
//
//  Created by Justin Chao on 4/7/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func setBackground(){
        let defaults = UserDefaults.standard
        let backgroundDefault = defaults.integer(forKey: "background")
        
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        let imageViewBackground = UIImageView(frame: CGRect(x:0, y:0, width:width, height:height))
       
        if backgroundDefault == 1 {
            imageViewBackground.image = UIImage(named: "taiwan.jpg")
        }
        else if backgroundDefault == 2 {
            imageViewBackground.image = UIImage(named: "rio.jpg")
        }
        else if backgroundDefault == 3 {
            imageViewBackground.image = UIImage(named: "paris4.jpg")
        }
        else if backgroundDefault == 4 {
            imageViewBackground.image = UIImage(named: "yosemite.jpg")
        }
        else if backgroundDefault == 5 {
            imageViewBackground.image = UIImage(named: "utah.jpg")
        } else {
            imageViewBackground.image = UIImage(named: "taiwan.jpg")
        }
        
        imageViewBackground.contentMode = .scaleAspectFill
        self.view.addSubview(imageViewBackground)
        self.view.sendSubview(toBack: imageViewBackground)
    }
}
