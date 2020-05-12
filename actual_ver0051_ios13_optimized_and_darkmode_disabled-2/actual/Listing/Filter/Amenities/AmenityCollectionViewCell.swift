//
//  AmenityCollectionViewCell.swift
//  actual
//
//  Created by Mojave Minjae on 2019-05-19.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit

class AmenityCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var amenityImage: UIImageView!
//    var On: [String] = []
    var On: String = ""
    var Off: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected{
                print("Selected")
                amenityImage.image = UIImage(named: Off)
            }
            else {
                print("deSelected")
                amenityImage.image = UIImage(named: On)
            }
        }
        
    }
}
