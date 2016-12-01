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

class SearchingNetworksViewController: UIViewController {
    
    @IBOutlet weak var noNetworksFoundView: UIView!
    @IBOutlet weak var circularSpinnerView: UIView!
    
    
    enum state {
        case searching
        case networksFound
        case noNetworksFound
    }
    var currentState: state = .searching
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentState = .noNetworksFound
        
        noNetworksFoundView.layer.cornerRadius = 25
        noNetworksFoundView.layer.shadowColor = UIColor.black.cgColor
        noNetworksFoundView.layer.shadowOffset = CGSize(width: 1, height: 1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateView()
    }
    
    func updateView() {
        switch currentState {
        case .networksFound :
            break
        case .noNetworksFound :
            noNetworksFoundView.isHidden = false
            circularSpinnerView.isHidden = true
            break
        default:
            noNetworksFoundView.isHidden = true
            circularSpinnerView.isHidden = false
            self.showCircularSpinner()
            break
        }
    }
    
    func showCircularSpinner() {
        CircularSpinner.useContainerView(circularSpinnerView)
        CircularSpinner.trackPgColor = Colors.colorWithHexString(Colors.lightBlue())
        
        CircularSpinner.show("Searching for Networks...", animated: true, type: .indeterminate, showDismissButton: false)
    }
}
