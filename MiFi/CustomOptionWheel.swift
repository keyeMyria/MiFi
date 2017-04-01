//
//  CustomOptionWheel.swift
//  MiFi
//
//  Created by Tristan Secord on 2016-11-16.
//  Copyright © 2016 Tristan Secord. All rights reserved.
//

import Foundation
import UIKit
import KCFloatingActionButton

class CustomOptionWheel: KCFloatingActionButton {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.rotationDegrees = 45
        self.buttonColor = Colors.colorWithHexString(Colors.orange())
        self.plusColor = UIColor.white
        self.overlayColor = UIColor.clear
        self.itemButtonColor = Colors.colorWithHexString(Colors.orange())
        self.itemTitleColor = UIColor.lightGray
        self.itemImageColor = UIColor.white
        self.itemShadowColor = UIColor.black
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}
