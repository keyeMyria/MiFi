//
//  HomePageViewController.swift
//  MiFi
//
//  Created by Tristan Secord on 2016-11-24.
//  Copyright © 2016 Tristan Secord. All rights reserved.
//

import Foundation
import UIKit
import Apollo

class HomePageViewController: UIPageViewController {
  var apollo: ApolloClient
  private(set) lazy var orderedViewControllers: [UIViewController] = {
    return [self.viewController(storyboardID: "SearchingNetworksViewController"),
            self.viewController(storyboardID: "AddNetworkViewController"),
            self.viewController(storyboardID: "MyAccountViewController"),
            self.viewController(storyboardID: "NetworkViewController")]
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
    
    self.apollo.fetch(query: ValidateUserQuery()) { (result, error) in
      if let valid = result?.data?.validateUser?.valid {
        switch valid {
        case true:
          break
        default:
          self.showSignInPage()
          return
        }
      } else {
        self.showSignInPage()
        return
      }
    }
    
    dataSource = self
    let searchingNetworksViewController: UIViewController? = orderedViewControllers.first
    if let firstViewController = searchingNetworksViewController {
      setViewControllers([firstViewController],
                         direction: .forward,
                         animated: true,
                         completion: nil)
    }
  }
  
  func showSignInPage() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let signInViewController = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
    self.present(signInViewController, animated: true, completion: nil)
  }
  
  func viewController(storyboardID: String) -> UIViewController {
    return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: storyboardID)
  }
}

extension HomePageViewController: UIPageViewControllerDataSource {
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
      return nil
    }
    let previousIndex = viewControllerIndex - 1
    guard previousIndex >= 0 else {
      return nil
    }
    guard orderedViewControllers.count > previousIndex else {
      return nil
    }
    return orderedViewControllers[previousIndex]
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
      return nil
    }
    let nextIndex = viewControllerIndex + 1
    guard nextIndex >= 0 else {
      return nil
    }
    guard orderedViewControllers.count > nextIndex else {
      return nil
    }
    return orderedViewControllers[nextIndex]
  }
}
