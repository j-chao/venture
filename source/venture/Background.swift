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
//        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"wallscreen.png")!)
        
        //or
        
//        let bgImage = UIImageView(image: UIImage(named: "wallscreen.png"))
//        bgImage.contentMode = .scaleAspectFill
//        self.view.addSubview(bgImage)
//        self.view.sendSubview(toBack: bgImage)
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRect(x:0, y:0, width:width, height:height))
        imageViewBackground.image = UIImage(named: "blurBack")
        
        // you can change the content mode:
        imageViewBackground.contentMode = .scaleAspectFill
        
        self.view.addSubview(imageViewBackground)
        self.view.sendSubview(toBack: imageViewBackground)
    }
}
