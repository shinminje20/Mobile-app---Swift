//
//  AmenitiesCompareTableViewCell.swift
//  actual
//
//  Created by Sukkwon On on 2019-08-07.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit

class AmenitiesCompareTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var flag1:[Bool] = []
    var flag2:[Bool] = []
    var list:[String] = ["icon_aircon", "icon_balcony", "icon_closet", "icon_dishwash", "icon_fridge", "icon_heater", "icon_tv", "icon_wifi", "icon_Bed", "icon_Tub(public)", "icon_Toilet(private)", "icon_Stove", "icon_Microwave", "icon_Dryer(public)", "icon_Laundry(public)", "icon_Deskchair", "icon_Hanger", "icon_parking"]
    
    @IBOutlet weak var collectionView1: UICollectionView!
    @IBOutlet weak var collectionView2: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.collectionView1.dataSource = self
        self.collectionView1.delegate = self
        self.collectionView1.register(UINib.init(nibName: "AmenitiesCompareCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "amenitiescell1")
        self.collectionView2.dataSource = self
        self.collectionView2.delegate = self
        self.collectionView2.register(UINib.init(nibName: "AmenitiesCompareCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "amenitiescell2")
        
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "amenitiescell1", for: indexPath as IndexPath) as! AmenitiesCompareCollectionViewCell
            
            if flag1[indexPath.row] {
                cell.amenitiesImage.image = UIImage(named: list[indexPath.row])
            } else {
                cell.amenitiesImage.image = UIImage(named: list[indexPath.row]+"_x")
            }
            
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "amenitiescell2", for: indexPath as IndexPath) as! AmenitiesCompareCollectionViewCell
            
            if flag2[indexPath.row] {
                cell.amenitiesImage.image = UIImage(named: list[indexPath.row])
            } else {
                cell.amenitiesImage.image = UIImage(named: list[indexPath.row]+"_x")
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
