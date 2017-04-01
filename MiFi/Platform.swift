//
//  Platform.swift
//  MiFi
//
//  Created by Tristan Secord on 2017-02-01.
//  Copyright © 2017 Tristan Secord. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration.CaptiveNetwork

struct Platform {
    static var isSimulator: Bool {
        return ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] != nil
    }
    
    static var deviceToken: String {
        let defaults = UserDefaults.standard
        
        if self.isSimulator {
            return "Simulator_123"
        }
        return defaults.object(forKey: "deviceToken") as! String
    }
}

extension UIDevice {
    public var Wifi: [String: String?] {
        get {
            var wifi_info = [String: String?]()
            if let interfaces = CNCopySupportedInterfaces() {
                for i in 0..<CFArrayGetCount(interfaces){
                    let interfaceName: UnsafeRawPointer = CFArrayGetValueAtIndex(interfaces, i)
                    let rec = unsafeBitCast(interfaceName, to: AnyObject.self)
                    let unsafeInterfaceData = CNCopyCurrentNetworkInfo("\(rec)" as CFString)
                    
                    if let unsafeInterfaceData = unsafeInterfaceData as? Dictionary<AnyHashable, Any> {
                        wifi_info["SSID"] = unsafeInterfaceData["SSID"] as? String
                        wifi_info["BSSID"] = unsafeInterfaceData["BSSID"] as? String
                    }
                }
            }
            return wifi_info
        }
    }
}
