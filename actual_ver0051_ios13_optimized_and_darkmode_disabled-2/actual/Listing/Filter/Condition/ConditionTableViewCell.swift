//
//  ConditionTableViewCell.swift
//  actual
//
//  Created by Mojave Minjae on 2019-05-18.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit

class ConditionTableViewCell: UITableViewCell {

    @IBOutlet weak var conditionImage: UIImageView!
    @IBOutlet weak var conditionSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let width: CGFloat = self.bounds.width/4
        let height: CGFloat = self.bounds.height*0.66
        
        conditionSwitch.isOn = false
        conditionImage.frame = CGRect(x: 0, y: 5, width: 150, height: 36)
        conditionSwitch.frame = CGRect(x: self.bounds.width*0.96, y: 10, width: width, height: height)
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

