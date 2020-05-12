//
//  FavoriteCollectionViewCell.swift
//  actual
//
//  Created by Jinwook Kim on 2019-05-09.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit

class FavoriteCollectionViewCell: UICollectionViewCell {
//    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var favoriteImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var bedLabel: UILabel!
    @IBOutlet weak var bathLabel: UILabel!
    @IBOutlet weak var moveInLabel: UILabel!
//    @IBOutlet weak var sqftLabel: UILabel!
    @IBOutlet weak var newIconImage: UIImageView!
    @IBOutlet weak var bedImage: UIImageView!
    @IBOutlet weak var bathImage: UIImageView!
    @IBOutlet weak var moveImage: UIImageView!
    
    @IBOutlet weak var numImage: UIImageView!
    
    @IBOutlet weak var firstIconImage: UIImageView!
    @IBOutlet weak var secondIconImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code        
    }

}
