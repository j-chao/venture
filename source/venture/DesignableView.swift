//
//  DesignableView.swift
//  venture
//
//  Created by Justin Chao on 4/8/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import UIKit

@IBDesignable class DesignableView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
}
