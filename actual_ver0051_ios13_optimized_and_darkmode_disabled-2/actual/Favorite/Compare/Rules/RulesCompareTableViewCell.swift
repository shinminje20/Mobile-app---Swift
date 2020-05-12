//
//  RulesCompareTableViewCell.swift
//  actual
//
//  Created by Sukkwon On on 2019-08-07.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit

class RulesCompareTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var flag1:[Bool] = []
    var flag2:[Bool] = []
    var list:[String] = ["icon_dog", "icon_cat", "icon_smoking", "icon_drug", "icon_Party", "icon_Manonly", "icon_Womanonly", "icon_Both"]
    
    @IBOutlet weak var collectionView1: UICollectionView!
    @IBOutlet weak var collectionView2: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.collectionView1.dataSource = self
        self.collectionView1.delegate = self
        self.collectionView1.register(UINib.init(nibName: "RulesCompareCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "rulescell1")
        self.collectionView2.dataSource = self
        self.collectionView2.delegate = self
        self.collectionView2.register(UINib.init(nibName: "RulesCompareCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "rulescell2")
        self.collectionView1.isScrollEnabled = false
        self.collectionView2.isScrollEnabled = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionView1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "rulescell1", for: indexPath as IndexPath) as! RulesCompareCollectionViewCell
            
            if flag1[indexPath.row] {
                cell.rulesImage.image = UIImage(named: list[indexPath.row])
            } else {
                cell.rulesImage.image = UIImage(named: list[indexPath.row]+"_x")
            }
            
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "rulescell2", for: indexPath as IndexPath) as! RulesCompareCollectionViewCell
            
            if flag2[indexPath.row] {
                cell.rulesImage.image = UIImage(named: list[indexPath.row])
            } else {
                cell.rulesImage.image = UIImage(named: list[indexPath.row]+"_x")
            }
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width:CGFloat = (UIScreen.main.bounds.width/6)
        let height:CGFloat = width
        return CGSize(width: width, height: height)
    }
    
}

