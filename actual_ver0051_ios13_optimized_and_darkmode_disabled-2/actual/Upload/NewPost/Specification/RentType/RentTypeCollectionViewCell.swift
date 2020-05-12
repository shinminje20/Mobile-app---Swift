//
//  rentTypeCollectionViewCell.swift
//  actual
//
//  Created by Minjae Shin on 2019-08-19.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit

class RentTypeCollectionViewCell: UICollectionViewCell {

    var type: String = ""
    var onColor: UIColor?
    var offColor: UIColor?
    @IBOutlet weak var typeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        self.typeLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        self.typeLabel.text = type
        self.typeLabel.textColor = offColor
        self.typeLabel.font = UIFont(name:"FiraSans-Bold",size:15)
        self.typeLabel.textAlignment = .center
//        self.typeLabel.frame.size = CGSize(width: UIScreen.main.bounds.width/3.5, height: 50)
//        typeBtnaddTarget(self.awakeFromNib(), action: #selector(sendData(sender:)), for: .touchUpInside)
//        self.typeLabel.layer.cornerRadius = 15
//        self.typeLabel.clipsToBounds = true
//        self.typeLabel.layer.borderWidth = 1.2
        self.backgroundColor = UIColor.white
//        self.typeLabel.sizeToFit()
        self.addSubview(typeLabel)
        
    }
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected{
                typeLabel.backgroundColor = offColor
                typeLabel.textColor = UIColor.white
                typeLabel.layer.borderColor = offColor?.cgColor
                
            }
            else {
                typeLabel.backgroundColor = UIColor.white
                typeLabel.textColor = onColor
                typeLabel.layer.borderColor = onColor?.cgColor
                
            }
        }
    }

}
