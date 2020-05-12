//
//  BuildingTableViewCell.swift
//  actual
//
//  Created by Mojave Minjae on 2019-05-19.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit

class BuildingTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    var offList:[String] = ["filter_condoOff", "filter_houseOff"]
    var onList:[String] = ["filter_condoOn", "filter_houseOn"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(UINib.init(nibName: "BuildingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "buildingcell")
        
        if buildingTypeMultiSelectionFlag {
            self.collectionView.allowsMultipleSelection = true
        }
        else {
            self.collectionView.allowsMultipleSelection = false
        }
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return offList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "buildingcell", for: indexPath as IndexPath) as! BuildingCollectionViewCell
        
        cell.buildingImage.image = UIImage(named: offList[indexPath.row])
        
        cell.On = offList[indexPath.row]
        cell.Off = onList[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "buildingcell", for: indexPath as IndexPath) as! BuildingCollectionViewCell
//        cell.On = onList[indexPath.row]
        print("Selected row is \(indexPath.row)")
        BUILDINGTYPES[indexPath.row] = true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "buildingcell", for: indexPath as IndexPath) as! BuildingCollectionViewCell
//        cell.Off = offList[indexPath.row]
        print("Deselected row is \(indexPath.row)")
        BUILDINGTYPES[indexPath.row] = false
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width:CGFloat = self.collectionView.frame.width/2.068
        let height:CGFloat = self.collectionView.bounds.height*0.9
        //return CGSize(width: width, height: height)
        
        return CGSize(width: width, height: height)
    }
    
}
