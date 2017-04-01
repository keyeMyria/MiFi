//
//  AddNetworkViewController.swift
//  MiFi
//
//  Created by Tristan Secord on 2016-12-23.
//  Copyright © 2016 Tristan Secord. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import JSSAlertView

class AddNetworkViewController: UIViewController {
    @IBOutlet weak var networkName: CustomTextFieldView!
    @IBOutlet weak var password: CustomTextFieldView!
    @IBOutlet weak var verifyPassword: CustomTextFieldView!
    @IBOutlet weak var discoverable: UISwitch!
    
    var ssid: String?
    var bssid: String?

    let httpHelper = HTTPHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Colors.colorWithHexString(Colors.darkBlue())
        
        self.discoverable.onTintColor = Colors.colorWithHexString(Colors.blue())
        
        ssid = UIDevice.current.Wifi["SSID"]!
        bssid = UIDevice.current.Wifi["BSSID"]!
        
        LocationHelper().enableLocationServices()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func addNetworkShowInfo(_ sender: Any) {
        JSSAlertView().info(
            self,
            title: "Add Network",
            text: "This will add the network you are currently connected to. \r\n The name you enter for your network does not have to be your WiFi name (SSID), it can be anything you choose. \r\n However, the password you enter must be the network's valid password. \r\n Finally, toggle Discoverable to make your network visible to other users on MiFi. \r\n "
        )
    }
    
    @IBAction func toggleDiscoverable(_ sender: Any) {
        if discoverable.isOn {
            discoverable.setOn(false, animated: true)
        } else {
            discoverable.setOn(true, animated: true)
        }
    }
    
    func checkData() -> Bool {
        if ((networkName.textField.text == nil || networkName.textField.text == "") || (password.textField.text == nil || password.textField.text == "") || (verifyPassword.textField.text == nil || verifyPassword.textField.text == "")) {
            JSSAlertView().warning(
                self,
                title: "Notice!",
                text: "Looks like your missing some vital information. \r\nPlease fill out all fields to add network."
            )
            return false
        } else if (password.textField.text != verifyPassword.textField.text) {
            JSSAlertView().warning(
                self,
                title: "Notice!",
                text: "Passwords don't seem to match. Please type carefully!"
            )
            return false
        } else if ((bssid == nil || bssid == "") || (ssid == nil || ssid == "")) {
            JSSAlertView().warning(
                self,
                title: "Notice!",
                text: "Could not verify current network. \r\nPlease try again later."
            )
            return false
        } else if (LocationHelper().latitude == nil || LocationHelper().longitude == nil) {
            JSSAlertView().warning(
                self,
                title: "Notice!",
                text: "Could not get your current location. \r\nPlease try again later."
            )
            return false
        }
        return true
    }
    
    @IBAction func addNetwork(_ sender: Any) {
        //Get Current Latitude and Longitude
        if !LocationHelper().getLocation() {
            JSSAlertView().warning(
                self,
                title: "Notice!",
                text: "Could not get your current location. \r\nPlease try again later."
            )
            print ("Could not get location")
            
            return
        }
        
        //Check entered values
        if (self.checkData()) {
            //Get all variables
            let encrypted_password = AESCrypt.encrypt(password.textField.text!, password: HTTPHelper.API_AUTH_PASSWORD)
            let encrypted_bssid = AESCrypt.encrypt(bssid!, password: HTTPHelper.API_AUTH_PASSWORD)
            let parameters = ["name":networkName.textField.text!, "password":encrypted_password!, "discoverable":discoverable.isOn, "latitude":LocationHelper().latitude!, "longitude":LocationHelper().longitude!, "bssid": encrypted_bssid!] as [String : Any]
            
            //2. Send request using alamofire and httpHelper
            httpHelper.sendAlamofire(url: "add_network", method: .post, parameters: parameters, headers: nil, requestType: .httpTokenAuth)?.responseJSON { (responseData) -> Void in
                switch responseData.result {

                case .success:
                    JSSAlertView().success(self, title: "Network Added!")
                    break
                case .failure(_):
                    if let data = responseData.data {
                        let responseJSON = JSON(data: data)
                        if let error = responseJSON["message"].string {
                            JSSAlertView().danger(self, title: "Error", text: error)
                        }
                    }
                    break
                }
            }
        }
    }
}
