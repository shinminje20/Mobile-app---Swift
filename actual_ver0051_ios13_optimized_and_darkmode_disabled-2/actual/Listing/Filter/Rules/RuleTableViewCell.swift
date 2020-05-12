//
//  RuleTableViewCell.swift
//  actual
//
//  Created by Mojave Minjae on 2019-05-19.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit

class RuleTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    var offList:[String] = ["icon_dog_x", "icon_cat_x", "icon_smoking_x", "icon_drug_x", "icon_Party_x", "icon_Manonly_x", "icon_Womanonly_x", "icon_Both_x"]
    var onList:[String] = ["icon_dog", "icon_cat", "icon_smoking", "icon_drug", "icon_Party", "icon_Manonly", "icon_Womanonly", "icon_Both"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(UINib.init(nibName: "RuleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "rulecell")
        
        self.collectionView.allowsMultipleSelection = true
        self.collectionView.isScrollEnabled = false
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return offList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "rulecell", for: indexPath as IndexPath) as! RuleCollectionViewCell
        
        cell.ruleImage.image = UIImage(named: offList[indexPath.row])
        
        cell.On = offList[indexPath.row]
        cell.Off = onList[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "rulecell", for: indexPath as IndexPath) as! RuleCollectionViewCell
//        cell.On = onList[indexPath.row]
        print("Selected row is \(indexPath.row)")
        RULES[indexPath.row] = true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "rulecell", for: indexPath as IndexPath) as! RuleCollectionViewCell
//        cell.Off = offList[indexPath.row]
        print("Deselected row is \(indexPath.row)")
        RULES[indexPath.row] = false
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width:CGFloat = UIScreen.main.bounds.width/6
        let height:CGFloat = width
        
        return CGSize(width: width, height: height)
    }
    
    
}
