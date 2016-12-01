//
//  CustomButton.swift
//  MiFi
//
//  Created by Tristan Secord on 2016-11-13.
//  Copyright © 2016 Tristan Secord. All rights reserved.
//

import Foundation
import UIKit

class CustomButton: UIButton {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.layer.cornerRadius = 25
        self.backgroundColor = Colors.colorWithHexString(Colors.lightBlue())
        self.setTitleColor(UIColor.white, for: .normal)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.layer.shadowOpacity = 0.3
        self.addTarget(self, action: #selector(buttonTapped), for: .touchDown)
        self.addTarget(self, action: #selector(buttonReleased), for: .touchUpInside)
    }
    
    func buttonReleased(sender: UIButton) {
        self.layer.shadowOpacity = 0.3
    }
    
    func buttonTapped(sender: UIButton) {
        self.layer.shadowOpacity = 0
    }
}
