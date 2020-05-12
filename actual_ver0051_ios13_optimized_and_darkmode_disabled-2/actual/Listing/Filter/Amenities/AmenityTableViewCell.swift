//
//  AmenityTableViewCell.swift
//  actual
//
//  Created by Mojave Minjae on 2019-05-19.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit

class AmenityTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var offList:[String] = ["icon_aircon_x", "icon_balcony_x", "icon_closet_x", "icon_dishwash_x", "icon_fridge_x", "icon_heater_x", "icon_tv_x", "icon_wifi_x", "icon_Bed_x", "icon_Tub(public)_x", "icon_Toilet(private)_x", "icon_Stove_x", "icon_Microwave_x", "icon_Dryer(public)_x", "icon_Laundry(public)_x", "icon_Deskchair_x", "icon_Hanger_x", "icon_parking_x"]

    var onList:[String] = ["icon_aircon", "icon_balcony", "icon_closet", "icon_dishwash", "icon_fridge", "icon_heater", "icon_tv", "icon_wifi", "icon_Bed", "icon_Tub(public)", "icon_Toilet(private)", "icon_Stove", "icon_Microwave", "icon_Dryer(public)", "icon_Laundry(public)", "icon_Deskchair", "icon_Hanger", "icon_parking"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(UINib.init(nibName: "AmenityCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "amenitycell")
        
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "amenitycell", for: indexPath as IndexPath) as! AmenityCollectionViewCell
        
        cell.amenityImage.image = UIImage(named: offList[indexPath.row])
        
        cell.On = offList[indexPath.row]
        cell.Off = onList[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("s")
        AMENITIES[indexPath.row] = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("d")
        AMENITIES[indexPath.row] = false
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width:CGFloat = UIScreen.main.bounds.width/6
        let height:CGFloat = width
        return CGSize(width: width, height: height)
    }
}
