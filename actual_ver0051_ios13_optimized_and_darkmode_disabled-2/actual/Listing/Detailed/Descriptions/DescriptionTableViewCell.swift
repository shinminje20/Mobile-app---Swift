//
//  DescriptionTableViewCell.swift
//  actual
//
//  Created by Sukkwon On on 2019-04-01.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit

class DescriptionTableViewCell: UITableViewCell {
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var readMoreButton: UIButton! 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
