//
//  ImageCompareTableViewCell.swift
//  actual
//
//  Created by Sukkwon On on 2019-08-21.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit

class ImageCompareTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var numOne: UIImageView!
    @IBOutlet weak var numTwo: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
