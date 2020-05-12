//
//  DefaultCompareTableViewCell.swift
//  actual
//
//  Created by Sukkwon On on 2019-08-06.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit

class DefaultCompareTableViewCell: UITableViewCell {

    @IBOutlet weak var skytrainImage: UIImageView!
    @IBOutlet weak var p1Label: UILabel!
    @IBOutlet weak var p2Label: UILabel!
    @IBOutlet weak var centerLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
