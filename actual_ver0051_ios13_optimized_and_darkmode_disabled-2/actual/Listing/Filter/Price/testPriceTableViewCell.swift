
//
//  PriceTableViewCell.swift
//  actual
//
//  Created by Minjae Shin on 2019-05-18.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit
import WARangeSlider

class testPriceTableViewCell: UITableViewCell {
    @IBOutlet weak var maxText: UITextField!
    @IBOutlet weak var minText: UITextField!
    //    let rangeSlider = RangeSlider(frame: .zero)
//    @IBOutlet weak var minLabel: UILabel!
//    @IBOutlet weak var maxLabel: UILabel!
//    //label 2 개
//
//
//    @objc func rangeSliderValueChanged(_ rangeSlider: RangeSlider) {
//        let lowerVal:Int = Int((rangeSlider.lowerValue/10.0).rounded()*10)
//        let upperVal:Int = Int((rangeSlider.upperValue/10.0).rounded()*10)
//
//        PRICE_MIN = lowerVal
//        PRICE_MAX = upperVal
//
//        maxLabel.text = "$ \(upperVal)"
//        minLabel.text = "$ \(lowerVal)"
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        maxText.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        minText.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
//        maxText.frame = CGRect(x: UIScreen.main.bounds.width*0.8, y: self.bounds.height*0.25, width: 100, height: 20)
//        minText.frame = CGRect(x: UIScreen.main.bounds.width*0.06, y: self.bounds.height*0.2, width: 100, height: 20)
//        maxText.text = "$ \(Int(rangeSlider.maximumValue))"
//        minText.text = "$ \(Int(rangeSlider.minimumValue))"
        
        maxText.keyboardType = UIKeyboardType.numberPad
        minText.keyboardType = UIKeyboardType.numberPad
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // print("pricecell seleceted")
        // Configure the view for the selected state
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        PRICE_MAX = Int(maxText.text!) ?? 0
        PRICE_MIN = Int(minText.text!) ?? 0
//        if textField.text != "" {
//            textField.layer.borderWidth = 0.0
//            //            self.layer.borderWidth = 0.0
//
//        }
//        else {
//            textField.layer.borderWidth = borderWidth
//            textField.layer.borderColor = UIColor.red.cgColor
//            //            self.layer.borderWidth = borderWidth
//        }
//        PRICE = textField.text!
    }
    
}
