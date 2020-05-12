//
//  ProfileTableViewCell.swift
//  actual
//
//  Created by Jinwook Kim on 2019-03-30.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var restAddress: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var firstIconImage: UIImageView!
    @IBOutlet weak var secondIconImage: UIImageView!
    @IBOutlet weak var thirdIconImage: UIImageView!
        
    
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var bedLabel: UILabel!
    @IBOutlet weak var bathLabel: UILabel!
    @IBOutlet weak var moveInDateLabel: UILabel!
    @IBOutlet weak var sqftLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
