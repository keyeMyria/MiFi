//
//  SearchingNetworksViewController.swift
//  MiFi
//
//  Created by Tristan Secord on 2016-11-24.
//  Copyright © 2016 Tristan Secord. All rights reserved.
//

import Foundation
import UIKit
import CircularSpinner
import CoreLocation
import JSSAlertView
import SwiftyJSON
import LocationManagerSwift

struct Location {
  var latitude: Double? = nil
  var longitude: Double? = nil
}

class SearchingNetworksViewController: UIViewController {
  @IBOutlet weak var noNetworksFoundView: UIView!
  @IBOutlet weak var circularSpinnerView: UIView!
  @IBOutlet weak var networksView: UIView!
  @IBOutlet weak var networksTableView: UITableView!
  let locationManager = CLLocationManager()
  var myLocation = Location() {
    didSet {
      locationChanged()
    }
  }
  enum state {
    case searching
    case networksFound
    case noNetworksFound
  }
  var currentState: state = .searching
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = Colors.colorWithHexString(Colors.darkBlue())
    noNetworksFoundView.backgroundColor = Colors.colorWithHexString(Colors.darkBlue())
    initializeNetworksTableView()
    enableLocationServices()
    getLocation()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    updateView()
  }
  
  func locationServicesEnabled() -> Bool {
    return CLLocationManager.locationServicesEnabled()
  }
  
  func initializeNetworksTableView() {
    networksTableView.delegate = self
    networksTableView.dataSource = self
    networksTableView.register(UINib(nibName: "networkCell", bundle: nil), forCellReuseIdentifier: "networkCell")
    networksTableView.separatorColor = Colors.colorWithHexString(Colors.blue())
  }
  
  func enableLocationServices() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestWhenInUseAuthorization()
  }
  
  func getLocation() {
    if locationServicesEnabled() {
      locationManager.requestLocation()
    }
  }
  
  func locationChanged() {
    if (myLocation.latitude == nil || myLocation.longitude == nil) {
      currentState = .noNetworksFound
      updateView()
      return
    }
    
    apollo.fetch(query: SearchForNetworksQuery(city: "", latitude: 0, longitude: 0)
  }
  
  func updateView() {
    switch currentState {
    case .networksFound :
      noNetworksFoundView.isHidden = true
      circularSpinnerView.isHidden = true
      networksView.isHidden = false
      break
    case .noNetworksFound :
      noNetworksFoundView.isHidden = false
      circularSpinnerView.isHidden = true
      networksView.isHidden = true
      break
    default:
      noNetworksFoundView.isHidden = true
      circularSpinnerView.isHidden = false
      networksView.isHidden = true
      self.showCircularSpinner()
      break
    }
  }
  
  func showCircularSpinner() {
    CircularSpinner.useContainerView(circularSpinnerView)
    CircularSpinner.trackPgColor = Colors.colorWithHexString(Colors.blue())
    
    CircularSpinner.show("Searching for Networks...", animated: true, type: .indeterminate, showDismissButton: false)
  }
}

//Location Manager Delegate
extension SearchingNetworksViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.first {
      myLocation = Location(latitude: location.coordinate.latitude,
                            longitude: location.coordinate.longitude)
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    myLocation = Location(latitude: nil, longitude: nil)
  }
}

//TableView Delegate and Data Source
extension SearchingNetworksViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60;
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 6
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = networksTableView.dequeueReusableCell(withIdentifier: "networkCell") as! networkCell
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedCell: networkCell = tableView.cellForRow(at: indexPath) as! networkCell
    selectedCell.networkName.textColor = Colors.colorWithHexString(Colors.orange())
  }
  
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    let selectedCell: networkCell = tableView.cellForRow(at: indexPath) as! networkCell
    selectedCell.networkName.textColor = UIColor.white
  }
}
