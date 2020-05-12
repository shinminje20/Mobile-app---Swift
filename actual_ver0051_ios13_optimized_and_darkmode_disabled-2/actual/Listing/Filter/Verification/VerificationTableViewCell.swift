//
//  VerificationTableViewCell.swift
//  actual
//
//  Created by Mojave Minjae on 2019-05-17.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit

class VerificationTableViewCell: UITableViewCell {

    
    @IBOutlet weak var verificationSwitch: UISwitch!
    @IBOutlet weak var verificationImage: UIImageView!
    
    
    
    
    @objc func filterSwitchClicked(_ sender:UISwitch!){
        
        
        if sender.isOn{
//            print("inside the cell on")
        }
        else{
//            print("inside the cell off")
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        let width: CGFloat = self.bounds.width/4
        let height: CGFloat = self.bounds.height*0.66
        
        verificationSwitch.isOn = false
        verificationImage.frame = CGRect(x: 0, y: 5, width: 150, height: 36)
        verificationSwitch.frame = CGRect(x: self.bounds.width*0.96, y: 10, width: width, height: height)
        verificationSwitch.addTarget(self, action: #selector(filterSwitchClicked(_:)), for: .valueChanged)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//         print("verificationcell seleceted")
        // Configure the view for the selected state
    }
    
    
    
}
