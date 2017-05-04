//
//  AddNetworkViewController.swift
//  MiFi
//
//  Created by Tristan Secord on 2016-12-23.
//  Copyright © 2016 Tristan Secord. All rights reserved.
//

import Foundation
import UIKit
import JSSAlertView
import Apollo
import LocationManagerSwift
import CoreLocation

class AddNetworkViewController: UIViewController {
  @IBOutlet weak var networkName: UITextField!
  @IBOutlet weak var password: UITextField!
  @IBOutlet weak var verifyPassword: UITextField!
  @IBOutlet weak var discoverable: UISwitch!
  @IBOutlet weak var addNetworkView: UIView!
  @IBOutlet weak var noNetworkView: UIView!
  var apollo: ApolloClient
  var ssid: String?
  var bssid: String?
  enum state {
    case noNetwork
    case addNetwork
  }
  var currentState: state = .noNetwork
  
  required init?(coder aDecoder: NSCoder) {
    let env = Bundle.main.infoDictionary!["API_BASE_URL"] as! String
    self.apollo = {
      let configuration = URLSessionConfiguration.default
      let token = KeychainAccess.passwordForAccount("Auth_Token", service: "KeyChainService")!
      configuration.httpAdditionalHeaders = ["Authorization": token]
      let url = URL(string: env)!
      
      return ApolloClient(networkTransport: HTTPNetworkTransport(url: url, configuration: configuration))
    }()
    
    super.init(coder: aDecoder);
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = Colors.colorWithHexString(Colors.darkBlue())
    self.discoverable.onTintColor = Colors.colorWithHexString(Colors.blue())
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    ssid = UIDevice.current.Wifi["SSID"]!
    bssid = UIDevice.current.Wifi["BSSID"]!
    
    if (ssid != nil && bssid != nil) { currentState = .addNetwork
    } else { currentState = .noNetwork }
    
    updateView()
  }
  
  func checkData() -> Bool {
    if ((networkName.text == nil || networkName.text == "") ||
        (password.text == nil || password.text == "") ||
        (verifyPassword.text == nil || verifyPassword.text == "")) {
      self.showWarning(message: "Looks like your missing some vital information. \r\nPlease fill out all fields to add network.")
      return false
    } else if (password.text != verifyPassword.text) {
      self.showWarning(message: "Passwords don't seem to match. Please type carefully!")
      return false
    }
    return true
  }
  
  func showWarning(message: String!) {
    JSSAlertView().warning(self, title: "Notice!", text: message)
  }
  
  func locationServicesEnabled() -> Bool {
    return CLLocationManager.locationServicesEnabled()
  }
  
  func getLocation() {
    if locationServicesEnabled() {
      LocationManagerSwift.shared.updateLocation{ (latitude, longitude, status, error) in
        if (error != nil) {
          self.currentState = .noNetwork
          self.updateView()
          return
        }
        self.addNetwork(latitude: latitude, longitude: longitude)
      }
    }
  }
  
  func addNetwork(latitude: Double, longitude: Double) {
    LocationManagerSwift.shared.reverseGeocodeLocation(type: .APPLE) { (country, state, city, reverseGeocodeInfo, placemark, error) in
      if (error != nil) {
        JSSAlertView().warning(
          self,
          title: "Notice!",
          text: "Could not get your current location. \r\nPlease try again later."
        )
        return
      }
      
      let encrypted_password = AESCrypt.encrypt(self.password.text!, password: Bundle.main.infoDictionary!["API_CLIENT_KEY"] as! String)
      let encrypted_bssid = AESCrypt.encrypt(self.bssid!, password: Bundle.main.infoDictionary!["API_CLIENT_KEY"] as! String)
      
      self.apollo.perform(mutation: CreateNetworkMutation(name: self.networkName.text!, bssid: encrypted_bssid!, discoverable: (self.discoverable != nil), latitude: latitude, longitude: longitude, city: city!, password: encrypted_password!)) { (result, error) in
        print("Result: \(String(describing: result))")
        print("Error: \(String(describing: error))")
      }
    }
  }
  
  func updateView() {
    switch currentState {
    case .addNetwork :
      noNetworkView.isHidden = true
      addNetworkView.isHidden = false
      self.networkName.text = ssid!
      break
    default :
      noNetworkView.isHidden = false
      addNetworkView.isHidden = true
      break
    }
  }
  
  @IBAction func addNetworkPressed(_ sender: Any) {
    if (self.checkData()) { getLocation() }
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
}
