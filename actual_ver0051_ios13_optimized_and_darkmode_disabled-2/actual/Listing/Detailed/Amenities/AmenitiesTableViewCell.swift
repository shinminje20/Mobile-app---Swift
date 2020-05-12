//
//  AmenitiesTableViewCell.swift
//  actual
//
//  Created by Sukkwon On on 2019-03-26.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit

class AmenitiesTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var flag:[Bool] = []
    var list:[String] = ["icon_aircon", "icon_balcony", "icon_closet", "icon_dishwash", "icon_fridge", "icon_heater", "icon_tv", "icon_wifi", "icon_Bed", "icon_Tub(public)", "icon_Toilet(private)", "icon_Stove", "icon_Microwave", "icon_Dryer(public)", "icon_Laundry(public)", "icon_Deskchair", "icon_Hanger", "icon_parking"]
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(UINib.init(nibName: "AmenitiesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "amenitiescell")
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "amenitiescell", for: indexPath as IndexPath) as! AmenitiesCollectionViewCell
        
        if flag[indexPath.row] {
            cell.amenitiesImage.image = UIImage(named: list[indexPath.row])
        } else {
            cell.amenitiesImage.image = UIImage(named: list[indexPath.row]+"_x")
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
