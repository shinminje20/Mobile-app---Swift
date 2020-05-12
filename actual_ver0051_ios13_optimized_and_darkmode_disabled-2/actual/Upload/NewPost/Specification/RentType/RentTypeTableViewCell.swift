//
//  rentTypeTableViewCell.swift
//  actual
//
//  Created by Minjae Shin on 2019-08-19.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit

class RentTypeTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var typeList:[String] = ["TakeOver", "RoomRent", "RoomShare", "None"]
    var colorList:[UIColor] = [UIColor(rgb: 0x73acdd), UIColor(rgb: 0xa4cc67), UIColor(rgb: 0xe59c6f), UIColor(rgb: 0x464749)]
    var offColor = UIColor.lightGray
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(UINib.init(nibName: "RentTypeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "typecell")
        self.collectionView.allowsMultipleSelection = false
        self.collectionView.isScrollEnabled = false
        
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: self.frame.height*0.1, left: UIScreen.main.bounds.width/3.5/4, bottom: self.frame.height*0.1, right: UIScreen.main.bounds.width/3.5/4)
////        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3.5, height: UIScreen.main.bounds.height)
//        layout.minimumInteritemSpacing = 0
//        UIScreen.main.bounds.width/18
//
//        
//        collectionView!.collectionViewLayout = layout
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return typeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "typecell", for: indexPath as IndexPath) as! RentTypeCollectionViewCell
        
        
        
        
        cell.typeLabel.text = typeList[indexPath.row]
//        cell.typeLabel.frame.size = CGSize(width: UIScreen.main.bounds.width/3.5, height: self.frame.height*0.8)
//        cell.layout
//        cell.
//        let Xvalue = UIScreen.main.bounds.width/4 * CGFloat(indexPath.row) + UIScreen.main.bounds.width/9
//        cell.layer.frame = CGRect(x:Xvalue, y: self.bounds.height/cell.frame.height, width: UIScreen.main.bounds.width/4, height: cell.frame.height)
//        cell.typeLabel.frame.size = CGSize(width: 0, height: UIScreen.main.bounds.height)
        cell.onColor = offColor
        cell.offColor = colorList[indexPath.row]
//        cell.typeLabel.layer.cornerRadius = 15
//        cell.typeLabel.clipsToBounds = true
        cell.typeLabel.layer.borderWidth = 1.2
        cell.typeLabel.backgroundColor = UIColor.white
        cell.typeLabel.layer.borderColor = offColor.cgColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "buildingcell", for: indexPath as IndexPath) as! BuildingCollectionViewCell
        //        cell.On = onList[indexPath.row]
        print("Selected row is \(indexPath.row)")
        RENTTYPE = typeList[indexPath.row]
    }


    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        //        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "buildingcell", for: indexPath as IndexPath) as! BuildingCollectionViewCell
        //        cell.Off = offList[indexPath.row]
        print("Deselected row is \(indexPath.row)")
        RENTTYPE = typeList[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
//        let width:CGFloat = self.collectionView.frame.width/2.068
//        let height:CGFloat = self.collectionView.bounds.height*0.9
//        //return CGSize(width: width, height: height)
//        let size = CGSize(width: UIScreen.main.bounds.width*106/375, height: self.frame.height*32/40)
//        return CGSize(width: CGFloat((collectionView.frame.size.width / 3)), height: collectionView.frame.size.height * 32/40)
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: self.frame.height*0.1, left: UIScreen.main.bounds.width/3.5/4, bottom: self.frame.height*0.1, right: UIScreen.main.bounds.width/3.5/4)
//        //        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3.5, height: UIScreen.main.bounds.height)
//        layout.minimumInteritemSpacing = 0
//        UIScreen.main.bounds.width/18
        //        collectionView!.collectionViewLayout = layout
        
//        let numberOfItemsPerRow:CGFloat = 4
//        let spacingBetweenCells:CGFloat = 16
//
//        let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
//
//        if let collection = self.collectionView{
//            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
//            return CGSize(width: width, height: width)
//        }else{
//            return CGSize(width: 0, height: 0)
//        }
        


        
        let yourWidth = collectionView.bounds.width/4.0
        let yourHeight = yourWidth
        
        return CGSize(width: yourWidth, height: yourHeight)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
//    {
//        let width:CGFloat = self.collectionView.frame.width/2.068
//        let height:CGFloat = self.collectionView.bounds.height*0.9
//        //return CGSize(width: width, height: height)
//
//        return CGSize(width: width, height: height)
//    }
    
}
