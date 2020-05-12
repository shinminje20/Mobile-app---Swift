//
//  ListingCollectionViewCell.swift
//  actual
//
//  Created by Sukkwon On on 2019-03-17.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit

class ManageListingCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var priceLable: UILabel!
    @IBOutlet weak var listingImage: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var typeIconImage: UIImageView!
    @IBOutlet weak var verifiedIconImage: UIImageView!
    
    @IBOutlet weak var bedIcon: UIImageView!
    @IBOutlet weak var bathIcon: UIImageView!
    @IBOutlet weak var moveIcon: UIImageView!
    @IBOutlet weak var bedLabel: UILabel!
    @IBOutlet weak var bathLabel: UILabel!
    @IBOutlet weak var moveLabel: UILabel!
    @IBOutlet weak var firstIconImage: UIImageView!
    @IBOutlet weak var secondIconImage: UIImageView!
    
    @IBOutlet weak var myView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
