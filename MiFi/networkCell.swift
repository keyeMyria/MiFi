//
//  networkCell.swift
//  MiFi
//
//  Created by Tristan Secord on 2016-12-20.
//  Copyright © 2016 Tristan Secord. All rights reserved.
//

import Foundation
import UIKit

class networkCell: UITableViewCell {
    @IBOutlet weak var networkName: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var distanceView: UIView!
    @IBOutlet weak var networkNameView: UIView!
    @IBOutlet weak var selectedCellSeparator: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        distanceView.backgroundColor = Colors.colorWithHexString(Colors.blue())
    }
}
