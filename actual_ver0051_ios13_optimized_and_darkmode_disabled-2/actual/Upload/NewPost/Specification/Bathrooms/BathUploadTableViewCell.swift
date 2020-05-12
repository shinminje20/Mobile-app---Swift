//
//  BathUploadTableViewCell.swift
//  actual
//
//  Created by Sukkwon On on 2019-08-13.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit

class BathUploadTableViewCell: UITableViewCell {
    
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    
    var infoIndex = 0
    let infoList:[String] = ["1", "2", "3", "4", "5"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NUMBATH = ""
        infoLabel.text = "1"
        infoLabel.textAlignment = .center
        minusButton.addTarget(self, action: #selector(minusTapped), for: .touchUpInside)
        minusButton.setImage(UIImage(named: "minus"), for: .normal)
        minusButton.tintColor = .black
        plusButton.addTarget(self, action: #selector(plusTapped), for: .touchUpInside)
        plusButton.setImage(UIImage(named: "plus"), for: .normal)
        plusButton.tintColor = .black
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @objc func minusTapped(sender: UIButton) {
        if infoIndex > 0 {
            infoIndex -= 1
            infoLabel.text = infoList[infoIndex]
            NUMBATH = infoLabel.text!
        }
    }
    @objc func plusTapped(sender: UIButton) {
        if infoIndex < 4 {
            infoIndex += 1
            infoLabel.text = infoList[infoIndex]
            NUMBATH = infoLabel.text!
        }
    }
    
}
