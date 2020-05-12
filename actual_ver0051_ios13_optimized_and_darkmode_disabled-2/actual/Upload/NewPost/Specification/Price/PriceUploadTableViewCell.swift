//
//  PriceUploadTableViewCell.swift
//  actual
//
//  Created by Sukkwon On on 2019-08-13.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit

class PriceUploadTableViewCell: UITableViewCell {
    
    @IBOutlet weak var preLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var postLabel: UILabel!
    let borderWidth:CGFloat = 2.0
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        PRICE = ""
        textField.keyboardType = UIKeyboardType.numberPad
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text != "" {
            textField.layer.borderWidth = 0.0
            //            self.layer.borderWidth = 0.0
            
        }
        else {
            textField.layer.borderWidth = borderWidth
            textField.layer.borderColor = UIColor.red.cgColor
            //            self.layer.borderWidth = borderWidth
        }
        PRICE = textField.text!
    }
}
