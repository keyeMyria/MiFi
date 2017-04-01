//
//  LocationHelper.swift
//  MiFi
//
//  Created by Tristan Secord on 2017-02-01.
//  Copyright © 2017 Tristan Secord. All rights reserved.
//

import Foundation
import CoreLocation

class LocationHelper:NSObject {
  var latitude: Double?
  var longitude: Double?
  let locationManager = CLLocationManager()
  
  override init() {
    super.init()
    latitude = nil
    longitude = nil
  }
  
  
  func locationServicesEnabled() -> Bool {
    return CLLocationManager.locationServicesEnabled()
  }
  
  func enableLocationServices() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestWhenInUseAuthorization()
  }
  
  func getLocation() -> Bool {
    if self.locationServicesEnabled() {
      locationManager.requestLocation()
      if (latitude != nil) && (longitude != nil) {
        return true
      }
      return false
    }
    return false
  }
}

extension LocationHelper: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    print("Getting Location in delegate")
    if let location = locations.first {
      print("Location: \(location)")
      latitude = location.coordinate.latitude
      longitude = location.coordinate.longitude
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    latitude = nil
    longitude = nil
    print("Could not find location")
  }
}
