//
//  SearchingNetworksViewController.swift
//  MiFi
//
//  Created by Tristan Secord on 2016-11-24.
//  Copyright © 2016 Tristan Secord. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import JSSAlertView
import LocationManagerSwift
import Apollo
import NVActivityIndicatorView

class networkDetails {
  var name: String! = ""
  var distance: Double! = 0
  
  init(network: SearchForNetworksQuery.Data.Network) {
    self.name = network.name
    self.distance = network.distance
  }
}

class SearchingNetworksViewController: UIViewController {
  @IBOutlet weak var noNetworksFoundView: UIView!
  @IBOutlet weak var circularSpinnerView: UIView!
  @IBOutlet weak var networksView: UIView!
  @IBOutlet weak var networksTableView: UITableView!
  @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
  var apollo: ApolloClient
  enum state {
    //case searching
    case networksFound
    case noNetworksFound
  }
  var currentState: state = .noNetworksFound
  var networks: [networkDetails] = [] {
    didSet {
      self.currentState = .networksFound
      self.updateView()
      self.networksTableView.reloadData()
    }
  }
  lazy var refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
    
    return refreshControl
  }()
  
  required init?(coder aDecoder: NSCoder) {
    let base_url = Bundle.main.infoDictionary!["API_BASE_URL"] as! String
    
    self.apollo = {
      let configuration = URLSessionConfiguration.default
      let token = KeychainAccess.passwordForAccount("Auth_Token", service: "KeyChainService")!
      configuration.httpAdditionalHeaders = ["Authorization": token]
      let url = URL(string: base_url)!
      
      return ApolloClient(networkTransport: HTTPNetworkTransport(url: url, configuration: configuration))
    }()
    
    super.init(coder: aDecoder);
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    self.view.backgroundColor = Colors.colorWithHexString(Colors.darkBlue())
    activityIndicator.color = UIColor.white
    initializeNetworksTableView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    noNetworksFoundView.isHidden = false
    circularSpinnerView.isHidden = true
    networksView.isHidden = true
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    activityIndicator.startAnimating()
    getLocation()
  }
  
  func initializeNetworksTableView() {
    networksTableView.delegate = self
    networksTableView.dataSource = self
    networksTableView.register(UINib(nibName: "networkCell", bundle: nil), forCellReuseIdentifier: "networkCell")
    networksTableView.separatorColor = Colors.colorWithHexString(Colors.blue())
    networksTableView.addSubview(self.refreshControl)
  }
  
  func locationServicesEnabled() -> Bool {
    return CLLocationManager.locationServicesEnabled()
  }
  
  func getLocation() {
    if locationServicesEnabled() {
      LocationManagerSwift.shared.updateLocation{ (latitude, longitude, status, error) in
        if (error != nil) {
          self.showWarning(message: "Could not get your location. Please make sure location services are enabled for this application.")
          self.showNoNetworks()
          return
        }
        self.locationChanged(latitude: latitude, longitude: longitude)
      }
    }
  }
  
  func locationChanged(latitude: Double, longitude: Double) {
    LocationManagerSwift.shared.reverseGeocodeLocation(type: .APPLE) { (country, state, city, reverseGecodeInfo, placemark, error) in
      if (error != nil) {
        self.showNoNetworks()
        return
      }
      self.apollo.fetch(query: SearchForNetworksQuery(city: city!, latitude: latitude, longitude: longitude)) { (result, error) in
        if error != nil {
          self.showNoNetworks()
        } else if result?.errors != nil {
          self.showNoNetworks()
        } else if let networksInRange = result?.data?.networks {
          self.networks = []
          for network in networksInRange {
            self.networks.append(networkDetails(network: network!))
          }
        }
        self.activityIndicator.stopAnimating()
      }
    }
  }
  
  func showWarning(message: String!) {
    JSSAlertView().warning(self, title: "Notice!", text: message)
  }
  
  func showNoNetworks() {
    currentState = .noNetworksFound
    updateView()
  }
  
  func updateView() {
    switch currentState {
    case .networksFound :
      noNetworksFoundView.isHidden = true
      circularSpinnerView.isHidden = true
      networksView.isHidden = false
      break
    default :
      noNetworksFoundView.isHidden = false
      circularSpinnerView.isHidden = true
      networksView.isHidden = true
      break
    }
  }
  
  func handleRefresh(_ refreshControl: UIRefreshControl) {
    getLocation()
    refreshControl.endRefreshing()
  }
  
  @IBAction func refreshPressed(_ sender: Any) {
    activityIndicator.startAnimating()
    getLocation()
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
    return networks.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = networksTableView.dequeueReusableCell(withIdentifier: "networkCell") as! networkCell
    cell.networkName.text = networks[indexPath.row].name!
    cell.distance.text = String(format: "%.2f m", networks[indexPath.row].distance!)
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
