//
//  NetworkViewController.swift
//  MiFi
//
//  Created by Tristan Secord on 2016-11-25.
//  Copyright © 2016 Tristan Secord. All rights reserved.
//

import Foundation
import UIKit

class NetworkViewController: UIViewController {
    @IBOutlet weak var networkView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkView.layer.cornerRadius = 10
    }
}
