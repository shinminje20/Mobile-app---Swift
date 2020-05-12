//
//  AccountUserTableViewCell.swift
//  actual
//
//  Created by Sukkwon On on 2019-08-16.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit

class AccountUserTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
