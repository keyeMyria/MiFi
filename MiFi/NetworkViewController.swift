//
//  NetworkViewController.swift
//  MiFi
//
//  Created by Tristan Secord on 2016-11-25.
//  Copyright © 2016 Tristan Secord. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import JSSAlertView

class NetworkViewController: UIViewController {
    
    @IBOutlet weak var networkName: CustomTextFieldView!
    @IBOutlet weak var password: CustomTextFieldView!
    @IBOutlet weak var verifyPassword: CustomTextFieldView!
    
    @IBOutlet weak var discoverable: UISwitch!
    
    
    var ssid: String?
    var bssid: String?
    var latitude: Double? = nil
    var longitude: Double? = nil
    let locationManager = CLLocationManager()
    let httpHelper = HTTPHelper()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Colors.colorWithHexString(Colors.darkBlue())
    }
    
    @IBAction func toggleDiscoverable(_ sender: Any) {
    }
    
    @IBAction func saveChanges(_ sender: Any) {
    }
    
    @IBAction func editNetworkShowInfo(_ sender: Any) {
        JSSAlertView().info(
            self,
            title: "Edit Network",
            text: "This will edit the current network you are connected to. \r\n The name you enter for your network does not have to be your WiFi name (SSID), it can be anything you choose. \r\n However, the password you enter must be the network's valid password. \r\n Finally, toggle Discoverable to make your network visible to other users on MiFi. \r\n "
        )
    }
    
    
    
}
