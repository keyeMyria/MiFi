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
        self.borderActiveColor = Colors.colorWithHexString(Colors.lightBlue())
        self.borderInactiveColor = UIColor.lightGray
        self.placeholderColor = UIColor.lightGray
        self.placeholderFontScale = 1.0
    }
}
