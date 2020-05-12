//
//  RulesTableViewCell.swift
//  actual
//
//  Created by Sukkwon On on 2019-03-26.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit

class RulesTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var flag:[Bool] = []
    var list:[String] = ["icon_dog", "icon_cat", "icon_smoking", "icon_drug", "icon_Party", "icon_Manonly", "icon_Womanonly", "icon_Both"]
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(UINib.init(nibName: "RulesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "rulescell")
        self.collectionView.isScrollEnabled = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "rulescell", for: indexPath as IndexPath) as! RulesCollectionViewCell
        
        if flag[indexPath.row] {
            cell.rulesImage.image = UIImage(named: list[indexPath.row])
        } else {
            cell.rulesImage.image = UIImage(named: list[indexPath.row]+"_x")
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width:CGFloat = UIScreen.main.bounds.width/6
        let height:CGFloat = width
        
        return CGSize(width: width, height: height)
    }
}
