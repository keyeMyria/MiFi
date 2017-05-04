//
//  NewCustomButton.swift
//  
//
//  Created by Tristan Secord on 2017-04-29.
//
//

import Foundation
import UIKit

class NewCustomButton: UIButton {
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
    self.backgroundColor = Colors.colorWithHexString("#2979FF")
    self.setTitleColor(UIColor.white, for: .normal)
    self.titleLabel?.font = UIFont(name: "System Semibold", size: 20.0)
    self.layer.cornerRadius = self.frame.height / 2
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  //Add 2 functions to disable button for request and re-enable on failed request
  
}
