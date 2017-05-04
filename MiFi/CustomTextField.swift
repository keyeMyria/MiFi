//
//  NewCustomTextField.swift
//  MiFi
//
//  Created by Tristan Secord on 2017-04-24.
//  Copyright © 2017 Tristan Secord. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
open class CustomTextField: UIView {
  
  //Outlets
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var textFieldIcon: UIImageView!
  @IBOutlet var textFieldView: UIView!
  
  fileprivate var mainView: UIView!
  fileprivate let nibName = "CustomTextField"
  
  //Inspectable Fields
  @IBInspectable open var placeholderText: String = "" {
    didSet {
      textField.attributedPlaceholder = NSAttributedString(string:placeholderText, attributes:[NSForegroundColorAttributeName: UIColor.white])
    }
  }
  
  @IBInspectable open var icon: UIImage? = nil {
    didSet {
      textFieldIcon.image = icon
    }
  }
  
  @IBInspectable open var secureText: Bool = false {
    didSet {
      textField.isSecureTextEntry = secureText
    }
  }
  
  @IBInspectable open var keyboardType: UIKeyboardType = UIKeyboardType.default {
    didSet {
      textField.keyboardType = keyboardType
    }
  }
  
  @IBInspectable open var capitalization: UITextAutocapitalizationType = UITextAutocapitalizationType.none {
    didSet {
      textField.autocapitalizationType = capitalization
    }
  }
  
  @IBInspectable open var correction: UITextAutocorrectionType = UITextAutocorrectionType.no {
    didSet {
      textField.autocorrectionType = correction
    }
  }
  
  @IBInspectable open var spell_check: UITextSpellCheckingType = UITextSpellCheckingType.no {
    didSet {
      textField.spellCheckingType = spell_check
    }
  }
  
  fileprivate func xibSetup() {
    mainView = loadViewFromNib()
    mainView.frame = bounds
    mainView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
    addSubview(mainView)
    addSubview(mainView)
  }
  
  fileprivate func loadViewFromNib() -> UIView {
    let bundle = Bundle(for: type(of: self))
    let nib = UINib(nibName: nibName, bundle: bundle)
    let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
    return view
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    xibSetup()
    textFieldView.layer.cornerRadius = textFieldView.frame.height / 2
    textFieldView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
    textField.frame.size.height = textFieldView.frame.size.height
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
    xibSetup()
    textFieldView.layer.cornerRadius = textFieldView.frame.height / 2
    textFieldView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
    textField.frame.size.height = textFieldView.frame.size.height
  }
}
