//
//  homeViewController.swift
//  MiFi
//
//  Created by Tristan Secord on 2016-11-24.
//  Copyright © 2016 Tristan Secord. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var mifiLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "footer_lodyas"))
        
        let HomePageViewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomePageViewController")
        self.addChildViewController(HomePageViewController)
        
        HomePageViewController.view.frame = self.view.frame
        self.view.addSubview(HomePageViewController.view)
        HomePageViewController.didMove(toParentViewController: self)
        
    }

}
