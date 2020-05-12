//
//  TransportationTableViewCell.swift
//  actual
//
//  Created by Sukkwon On on 2019-08-27.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit

class TransportationTableViewCell: UITableViewCell {

    
    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
