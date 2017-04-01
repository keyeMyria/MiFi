//
//  CustomTextFieldView.swift
//  MiFi
//
//  Created by Tristan Secord on 2016-12-26.
//  Copyright © 2016 Tristan Secord. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
open class CustomTextFieldView: UIView {
    
    @IBOutlet weak var imageViewBorder: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textFieldUnderline: UIView!
    
    fileprivate var mainView: UIView!
    fileprivate let nibName = "CustomTextFieldView"
    
    //Inspectable Fields
    //textField placeholder text
    @IBInspectable open var placeholderText: String = "" {
        didSet{
            textField.attributedPlaceholder = NSAttributedString(string:placeholderText, attributes:[NSForegroundColorAttributeName: UIColor.lightGray])

        }
    }
    //image in view
    @IBInspectable open var image: UIImage? = nil {
        didSet {
            imageView.image = image
        }
    }
    //Secure Text Entry
    @IBInspectable open var secureText: Bool = false {
        didSet {
            textField.isSecureTextEntry = secureText
        }
    }
    
    fileprivate func xibSetup() {
        mainView = loadViewFromNib()
        mainView.frame = bounds
        mainView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(mainView)
    }
    
    fileprivate func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        xibSetup()
        
        imageViewBorder.backgroundColor = Colors.colorWithHexString(Colors.blue())
        textFieldUnderline.backgroundColor = Colors.colorWithHexString(Colors.blue())
        textField.isSecureTextEntry = secureText
        imageView.image = image
        textField.text = placeholderText
        
        textField.delegate = self
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        xibSetup()
        
        imageViewBorder.backgroundColor = Colors.colorWithHexString(Colors.blue())
        textFieldUnderline.backgroundColor = Colors.colorWithHexString(Colors.blue())
        textField.isSecureTextEntry = secureText
        imageView.image = image
        textField.text = placeholderText

        
        textField.delegate = self
    }
}

extension CustomTextFieldView: UITextFieldDelegate {

}
