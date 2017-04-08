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
  @IBOutlet weak var leftIconView: UIView!
  @IBOutlet weak var networkNameView: UIView!
  @IBOutlet weak var selectedCellSeparator: UIView!
  @IBOutlet weak var distanceSeperatorView: UIView!
  
  override func layoutSubviews() {
    super.layoutSubviews()
    leftIconView.backgroundColor = Colors.colorWithHexString(Colors.blue())
    distanceSeperatorView.backgroundColor = Colors.colorWithHexString(Colors.blue())
  }
}
