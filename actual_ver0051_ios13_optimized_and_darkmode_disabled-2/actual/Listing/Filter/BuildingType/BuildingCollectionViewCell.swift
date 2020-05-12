//
//  BuildingCollectionViewCell.swift
//  actual
//
//  Created by Mojave Minjae on 2019-05-19.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit

class BuildingCollectionViewCell: UICollectionViewCell {

    var On: String = ""
    var Off: String = ""
    
    @IBOutlet weak var buildingImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected{
                buildingImage.image = UIImage(named: Off)
            }
            else {
                buildingImage.image = UIImage(named: On)   
            }
        }
        
        
    }
    
}
