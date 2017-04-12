//
//  Appearance.swift
//  venture
//
//  Created by Justin Chao on 4/12/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import Foundation
import UIKit

class Config {
    
    static var myCustomLabelColor = UIColor.white
    static var myCustomButtonFont = UIFont.systemFont(ofSize: 15.0)
    
}

class Appearance {
    
    class func setInitialAppTheme() {
        Appearance.setMyCustomLabelColor()
        Appearance.setMyCustomButtonFont()
    }
    
    class func setMyCustomLabelColor() {
        MyCustomLabel.appearance().textColor = Config.myCustomLabelColor
    }
    
    class func setMyCustomButtonFont() {
        MyCustomButton.appearance().titleLabelFont = Config.myCustomButtonFont
    }
    
    class func updateLabelColor(color: UIColor) {
        Config.myCustomLabelColor = color
        Appearance.setMyCustomLabelColor()
    }
    
    class func updateButtonFont(font: UIFont) {
        Config.myCustomButtonFont = font
        Appearance.setMyCustomButtonFont()
    }
}


class MyCustomLabel: UILabel {
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
}

class MyCustomButton: UIButton {
    
    // It turns out that only some properties are accessible via a UIAppearance proxy,
    // and UIButton's titleLabel is not one of them. This problem can be solved in our
    // custom subclasses by adding the following.
    //
    // The "dynamic" keyword makes this accessible via Objective-C code, which is
    // needed for UIAppearance to set it.
    dynamic var titleLabelFont: UIFont! {
        get { return self.titleLabel?.font }
        set { self.titleLabel?.font = newValue }
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
}
