
//
//  PriceTableViewCell.swift
//  actual
//
//  Created by Minjae Shin on 2019-05-18.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit
import WARangeSlider

class PriceTableViewCell: UITableViewCell {

    let rangeSlider = RangeSlider(frame: .zero)
    
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    //label 2 개
    
    
    @objc func rangeSliderValueChanged(_ rangeSlider: RangeSlider) {
        let lowerVal:Int = Int((rangeSlider.lowerValue/10.0).rounded()*10)
        let upperVal:Int = Int((rangeSlider.upperValue/10.0).rounded()*10)
        
        PRICE_MIN = lowerVal
        PRICE_MAX = upperVal
        
        maxLabel.text = "$ \(upperVal)"
        minLabel.text = "$ \(lowerVal)"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //let margin: CGFloat = 20
        let width = self.contentView.bounds.width //- 2 * margin
        let height: CGFloat = 37
        
        rangeSlider.frame = CGRect(x: 0, y: 0,
                                   width: width, height: height)
        
        print("\(UIScreen.main.bounds.width), \(UIScreen.main.bounds.height)")
        print("\(self.contentView.frame.width), \(self.contentView.frame.height)")
        print("func viewDidLayoutSubviews() {} - contentView.center\(self.contentView.center)")
        rangeSlider.center = CGPoint(x: UIScreen.main.bounds.width/2.0, y: self.contentView.frame.height/4.0*3)
        rangeSlider.maximumValue = 3000.0
        rangeSlider.minimumValue = 0.0
        rangeSlider.upperValue = 3000.0
        rangeSlider.lowerValue = 0.0
        
        // GLOBAL Initialization
        PRICE_MIN = Int((rangeSlider.lowerValue/10.0).rounded()*10)
        PRICE_MAX = Int((rangeSlider.upperValue/10.0).rounded()*10)
        
        maxLabel.frame = CGRect(x: UIScreen.main.bounds.width*0.8, y: self.bounds.height*0.2, width: 100, height: 20)
        minLabel.frame = CGRect(x: UIScreen.main.bounds.width*0.06, y: self.bounds.height*0.2, width: 100, height: 20)
        maxLabel.text = "$ \(Int(rangeSlider.maximumValue))"
        minLabel.text = "$ \(Int(rangeSlider.minimumValue))"
        
        rangeSlider.backgroundColor = .white
        rangeSlider.trackHighlightTintColor = UIColor(rgb: 0x8389BA)
        rangeSlider.thumbTintColor = .white
        rangeSlider.thumbBorderColor = .lightGray
        self.contentView.addSubview(rangeSlider)
        
        rangeSlider.addTarget(self, action: #selector(rangeSliderValueChanged(_:)),
                              for : .valueChanged)
    }

//    func viewDidLayoutSubviews() {
//        let margin: CGFloat = 20
//        let width = self.contentView.bounds.width - 2 * margin
//        let height: CGFloat = 37
//        
//        rangeSlider.frame = CGRect(x: 0, y: 0,
//                                   width: width, height: height)
//        
//        print("func viewDidLayoutSubviews() {} - contentView.center\(self.contentView.center)")
//        rangeSlider.center = self.contentView.center
//        rangeSlider.minimumValue = 500.0
//        rangeSlider.maximumValue = 1500.0
//        rangeSlider.lowerValue = 500.0
//        rangeSlider.upperValue = 1500.0
//    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
// print("pricecell seleceted")
        // Configure the view for the selected state
    }
    
}
