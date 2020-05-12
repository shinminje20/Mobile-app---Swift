//
//  RuleCollectionViewCell.swift
//  actual
//
//  Created by Mojave Minjae on 2019-05-19.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit

class RuleCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var ruleImage: UIImageView!
    var On: String = ""
    var Off: String = ""
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected{
                ruleImage.image = UIImage(named: Off)
            }
            else {
                ruleImage.image = UIImage(named: On)
            }
        }
        
    }
}
