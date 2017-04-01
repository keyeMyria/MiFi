//
//  CustomTextField.swift
//  MiFi
//
//  Created by Tristan Secord on 2016-11-12.
//  Copyright © 2016 Tristan Secord. All rights reserved.
//

import Foundation
import UIKit
import TextFieldEffects

class CustomTextField: HoshiTextField {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.borderActiveColor = Colors.colorWithHexString(Colors.orange())
        //self.borderInactiveColor = UIColor.lightGray
        self.borderInactiveColor = Colors.colorWithHexString(Colors.blue())
        self.placeholderColor = UIColor.lightGray
        self.placeholderFontScale = 1.0
        self.layer.frame.size.height = 500
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}
