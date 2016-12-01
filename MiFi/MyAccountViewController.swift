//
//  MyAccountViewController.swift
//  MiFi
//
//  Created by Tristan Secord on 2016-11-24.
//  Copyright © 2016 Tristan Secord. All rights reserved.
//

import Foundation
import UIKit

class MyAccountViewController: UIViewController {
    @IBOutlet weak var myAccountView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myAccountView.layer.cornerRadius = 10
    }
    
}
