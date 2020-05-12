//
//  FavoriteViewController.swift
//  actual
//
//  Created by Jinwook Kim on 2019-05-09.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class FavoriteViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITabBarControllerDelegate {
    
    var testProperty = [Property]()
    var cellArray = [cellData]()
    
    var displayedImages = [UIImage]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadFavTestProperty()
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let longTitleLabel = UILabel()
        longTitleLabel.text = "Favourite"
        longTitleLabel.font = UIFont(name:"FiraSans-Bold",size:27)
        longTitleLabel.textColor = UIColor(rgb: 0x8389BA)
        longTitleLabel.sizeToFit()
        
        let leftItem = UIBarButtonItem(customView: longTitleLabel)
        self.navigationItem.leftBarButtonItem = leftItem
        
        let compareBtn : UIBarButtonItem = UIBarButtonItem(title: "Compare", style: .plain, target: self, action: #selector(toCompare))
        
        self.navigationItem.rightBarButtonItem = compareBtn
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(rgb: 0x8389BA)
//
//        guard
//            let navigationController = navigationController,
//            let flareGradientImage = CAGradientLayer.primaryGradient(on: navigationController.navigationBar)
//            else {
//                print("Error creating gradient color!")
//                return
//        }
//
//        navigationController.navigationBar.barTintColor = UIColor(patternImage: flareGradientImage)
        
        // =====================================================================
        // Table Data Init
        // =====================================================================
        cellArray = [
            cellData(cell : 1, title: "", height: 270, name: "MapFavoriteCollectionViewCell", identifier: "mapfavoritecell"),
            cellData(cell : 2, title: "", height: UIScreen.main.bounds.width * 110/366, name: "FavoriteCollectionViewCell", identifier: "favoritecell")
            //            cellData(cell : 2, title: "Descriptions", height: 75, name: "DescriptionTableViewCell", identifier: "descriptionecell")
        ]
        
        for cell in cellArray {
            let nibName = UINib(nibName: cell.name, bundle: nil)
            collectionView.register(nibName, forCellWithReuseIdentifier: cell.identifier)
        }
        
        // keyboard hiding when draggin collection view
        self.collectionView.keyboardDismissMode = .onDrag
        
        self.tabBarController?.delegate = self
        
        //        loadFavTestProperty()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        self.view.addSubview(collectionView)
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.color = UIColor(rgb: 0x8389BA)
        self.view.addSubview(activityIndicator)
    }
    
    private func loadFavTestProperty() {
        
        testProperty = []
        let context = appDelegate.persistentContainer.viewContext
        
        let requestListings = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
        requestListings.returnsObjectsAsFaults = false
        
        print("*After Context Set")
        do{
            let results = try context.fetch(requestListings)
            print("* After fetching results")
            let group = DispatchGroup()
            
            for data in results as! [NSManagedObject]{
                
                let newProperty = Property()
                
//                if let author = data.value(forKey: "author") {
//                    newProperty.author = author as! String
//                } else {
//                    newProperty.author = ""
//                    print("author not found.")
//                }
//                if let condition = data.value(forKey: "condition") {
//                    newProperty.condition = condition as! String
//                } else {
//                    newProperty.condition = ""
//                    print("condition not found.")
//                }
//                if let addressAddress = data.value(forKey: "addressAddress") {
//                    newProperty.address.address = addressAddress as! String
//                } else {
//                    newProperty.address.address = ""
//                }
//                if let addressCity = data.value(forKey: "addressCity") {
//                    newProperty.address.city = addressCity as! String
//                } else {
//                    newProperty.address.city = ""
//                }
//                if let addressPostalCode = data.value(forKey: "addressPostalCode") {
//                    newProperty.address.postalCode = addressPostalCode as! String
//                } else {
//                    newProperty.address.postalCode = ""
//                }
//                if let addressProvince = data.value(forKey: "addressProvince") {
//                    newProperty.address.province = addressProvince as! String
//                } else {
//                    newProperty.address.province = ""
//                }
//                if let addressLatitude = data.value(forKey: "addressLatitude") {
//                    newProperty.address.latitude = addressLatitude as! Double
//                } else {
//                    newProperty.address.latitude = -1.0
//                }
//                if let addressLongitude = data.value(forKey: "addressLongitude") {
//                    newProperty.address.longitude = addressLongitude as! Double
//                } else {
//                    newProperty.address.longitude = -1.0
//                }
//                if let constructionDate = data.value(forKey: "constructionDate") {
//                    newProperty.constructionDate = constructionDate as! Int
//                } else {
//                    newProperty.constructionDate = -1
//                }
                
                
                // simply retrieve data from core data
                newProperty.author = data.value(forKey: "author") as! String
                newProperty.condition = data.value(forKey: "condition") as! String
                newProperty.address.address = data.value(forKey: "addressAddress") as! String
                newProperty.address.city = data.value(forKey: "addressCity") as! String
                newProperty.address.postalCode = data.value(forKey: "addressPostalCode") as! String
                newProperty.address.province = data.value(forKey: "addressProvince") as! String
                newProperty.address.postalCode = data.value(forKey: "addressPostalCode") as! String
                newProperty.address.latitude = data.value(forKey: "addressLatitude") as! Double
                newProperty.address.longitude = data.value(forKey: "addressLongitude") as! Double
                newProperty.constructionDate = data.value(forKey: "constructionDate") as! Int
                
                newProperty.furnished = data.value(forKey: "furnished") as! Bool
                newProperty.hostEmail = data.value(forKey: "hostEmail") as! String
                newProperty.hostPhone = data.value(forKey: "hostPhone") as! String
                newProperty.numBath = data.value(forKey: "numBath") as! Int
                newProperty.numBed = data.value(forKey: "numBed") as! Int
                newProperty.description = data.value(forKey: "pDescription") as! String
                newProperty.price = data.value(forKey: "price") as! Int
                newProperty.requiredTerm = data.value(forKey: "requiredTerm") as! Int
                newProperty.size = data.value(forKey: "size") as! Int
                newProperty.new = data.value(forKey: "new") as! Bool
                newProperty.type = data.value(forKey: "type") as! String
                newProperty.verified = data.value(forKey: "verified") as! Bool
                newProperty.moveInDate = data.value(forKey: "moveInDate") as! String
                newProperty.internet = data.value(forKey: "internet") as! Bool
                newProperty.cableTV = data.value(forKey: "cableTV") as! Bool
                newProperty.fridge = data.value(forKey: "fridge") as! Bool
//                newProperty.kitchen = data.value(forKey: "kitchen") as! Bool
                newProperty.airCon = data.value(forKey: "airCon") as! Bool
                newProperty.heater = data.value(forKey: "heater") as! Bool
                newProperty.dishWash = data.value(forKey: "dishWash") as! Bool
                newProperty.laundry = data.value(forKey: "laundry") as! Bool
                newProperty.balcony = data.value(forKey: "balcony") as! Bool
                newProperty.closet = data.value(forKey: "laundry") as! Bool
                newProperty.parking = data.value(forKey: "parking") as! Bool
                newProperty.tub = data.value(forKey: "tub") as! Bool
                //추가 ㅏㅎ하ㅓ허하ㅓㅓㅎ
                newProperty.bed = data.value(forKey: "bed") as! Bool
                newProperty.tubPublic = data.value(forKey: "tubPublic") as! Bool
                newProperty.toiletPublic = data.value(forKey: "toiletPublic") as! Bool
                newProperty.stove = data.value(forKey: "stove") as! Bool
                newProperty.microwave = data.value(forKey: "microwave") as! Bool
                newProperty.dryerPublic = data.value(forKey: "dryerPublic") as! Bool
                newProperty.deskChair = data.value(forKey: "deskChair") as! Bool
                newProperty.hanger = data.value(forKey: "hanger") as! Bool
                
                newProperty.cats = data.value(forKey: "cats") as! Bool
                newProperty.dogs = data.value(forKey: "dogs") as! Bool
                newProperty.smoking = data.value(forKey: "smoking") as! Bool
                newProperty.drug = data.value(forKey: "drug") as! Bool
                //추가 시팔 이거 언제 이렇게 다 해놨냐 더덕책
                newProperty.party = data.value(forKey: "party") as! Bool
                newProperty.manonly = data.value(forKey: "manonly") as! Bool
                newProperty.womanonly = data.value(forKey: "womanonly") as! Bool
                newProperty.both = data.value(forKey: "both") as! Bool
                
                newProperty.transportation.placeName = (data.value(forKey: "transportationName") as! String)
                newProperty.transportation.displayedTime = (data.value(forKey: "transportationTime") as! String)

                newProperty.imageURL = data.value(forKey: "imageurl") as! [String]

                newProperty.documentID = data.value(forKey: "documentID") as! String
                newProperty.uid = data.value(forKey: "uid") as! String
                
                self.activityIndicator.startAnimating()
                
                group.enter()
                let myURL = newProperty.imageURL[0]
                self.downloadImage(from: URL(string: myURL)!, property: newProperty, completion: {(success) -> Void in
                    if self.displayedImages.count == 1 {
                        newProperty.images = self.displayedImages
                        self.testProperty.append(newProperty)
                        self.displayedImages = []
                        group.leave()
                    }
                })
                
                group.notify(queue: DispatchQueue.main) {
                    self.activityIndicator.stopAnimating()
                    print("*************")
                    print("NOW BYE")
                    print("*************")
                    
                    self.collectionView.reloadData()
                }
            }
        } catch{
            
            fatalError()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare()")
        super.prepare(for: segue, sender: sender)
        //setting back button in navigation bar
        let backItem = UIBarButtonItem()
        backItem.title = ""
        backItem.tintColor = UIColor(rgb: 0x8389BA)
        navigationItem.backBarButtonItem = backItem
        
        // If user wants to look at a recipe in more detail
        if segue.identifier == "DetailedListingViewController"{
            //Making sure the destination is correct
            guard let selectedIndexPath = sender as? NSIndexPath else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            //Selected recipe is different depending on filter status
            var selectedProperty = Property()
            selectedProperty = testProperty[selectedIndexPath.row]
            
            if segue.identifier == "DetailedListingViewController"{
                if segue.destination is DetailedListingViewController
                {
                    let vc = segue.destination as? DetailedListingViewController
                    vc?.property = selectedProperty
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1 // map
        }
        else {
            return testProperty.count // favorite cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let curcell:cellData = cellArray[indexPath.section]
        
        if curcell.cell == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: curcell.identifier, for: indexPath) as! MapFavoriteCollectionViewCell
            
            let allAnnotations = cell.mapView.annotations
            cell.mapView.removeAnnotations(allAnnotations)
            
            var annotationArray:[MKPointAnnotation] = []
            
            if testProperty.count >= 1 {
                
                for property in testProperty {
                    let locationCoordinate = CLLocationCoordinate2D(latitude: property.address.latitude, longitude: property.address.longitude)
                    let anno = MKPointAnnotation()
                    anno.coordinate = locationCoordinate
                    cell.mapView.addAnnotation(anno)
                    annotationArray.append(anno)
                }
                cell.mapView.fitAll()
                
//                cell.mapView.showAnnotations(annotationArray, animated: true)
            }
            
            
            return cell
        }
            
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: curcell.identifier, for: indexPath) as! FavoriteCollectionViewCell
            var property = Property()
            property = testProperty[indexPath.row]
            cell.favoriteImage.image = property.images[0]

            //stretch image to fill area
            cell.favoriteImage.contentMode = UIView.ContentMode.scaleAspectFill
            
            
            // =====================================================================
            // Changing Font
            // =====================================================================
            //        cell.priceLable.font = UIFont(name:"FiraSans-Regular",size:14)
            
            cell.priceLabel.text = "$\(property.price)"
            cell.priceLabel.adjustsFontSizeToFitWidth = true
            cell.priceLabel.font = UIFont(name:"FiraSans-Bold",size: cell.priceLabel.font.pointSize)
            cell.addressLabel.text = "\(property.address.city)"
            cell.addressLabel.adjustsFontSizeToFitWidth = true
            //cell.addressLabel.font = UIFont.systemFont(ofSize: 15)
            
            //추가 및 변경

//            if property.new == true {
//                cell.newIconImage.image = UIImage(named: "list_new")
//            }
            if property.verified == true {
                cell.newIconImage.image = UIImage(named: "list_verified")
            }
            
            cell.firstIconImage.image = UIImage(named: "\(property.condition)_point")
            cell.secondIconImage.image = UIImage(named: "\(property.condition)_point")
            
            cell.bedLabel.text = "\(property.numBed) BR"
//            cell.bedLabel.font = UIFont.systemFont(ofSize: 10)
            cell.bedLabel.textColor = UIColor(rgb:0x464749)
            cell.bedLabel.textAlignment = .center
            
            cell.bathLabel.text = "\(property.numBath) BA"
//            cell.bathLabel.font = UIFont.systemFont(ofSize: 10)
            cell.bathLabel.textColor = UIColor(rgb:0x464749)
            cell.bathLabel.textAlignment = .center
            
            cell.moveInLabel.text = property.moveInDate
//            cell.moveInLabel.font = UIFont.systemFont(ofSize: 10)
            cell.moveInLabel.textColor = UIColor(rgb:0x464749)
            cell.moveInLabel.textAlignment = .center
            
//            cell.sqftLabel.text = "\(property.size) sqrt"
//            cell.sqftLabel.font = UIFont.systemFont(ofSize: 10)
//            cell.sqftLabel.textColor = UIColor(rgb:0x464749)
//            cell.sqftLabel.textAlignment = .center
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = UIScreen.main.bounds.width
        let height:CGFloat = cellArray[indexPath.section].height
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            self.performSegue(withIdentifier: "DetailedListingViewController", sender: indexPath)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return cellArray.count
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL, property: Property, completion: @escaping (_ success: Bool) -> Void) {
        print("Download Started")
        
        let queue = DispatchQueue(label: "imageLoad", attributes: .concurrent)
        
        queue.async {
            self.getData(from: url) { data, response, error in
                if error != nil {
                    print("dddd", error)
                }
                guard let data = data, error == nil else {
                    if let error = error {
                        print("FavoriteViewController - Downloading URL errer : ", error)
                    }
                    return
                }
                print(response?.suggestedFilename ?? url.lastPathComponent)
                if (response?.suggestedFilename ?? url.lastPathComponent).prefix(1) != "0" {
                    self.displayedImages.append(UIImage(named: "profile_default")!)
                    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
                    request.returnsObjectsAsFaults = false
                    do {
                        print("deleting 1 ")
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        let context = appDelegate.persistentContainer.viewContext
                        let resultListings = try context.fetch(request)
                        for listing in resultListings as! [NSManagedObject]{
                            
                            let searchAddress = listing.value(forKey: "addressAddress") as! String
                            let searchCity = listing.value(forKey: "addressCity") as! String
                            let searchProvince = listing.value(forKey: "addressProvince") as! String
                            let searchPostalCode = listing.value(forKey: "addressPostalCode") as! String
                            let searchDescription = listing.value(forKey: "pDescription") as! String
                            
                            if (searchAddress == property.address.address &&
                                searchCity == property.address.city &&
                                searchProvince == property.address.province &&
                                searchPostalCode == property.address.postalCode &&
                                searchDescription == property.description){
                                
                                context.delete(listing)
                                
                                do {
                                    // make sure to save the deletion
                                    try context.save()
                                } catch {
                                    print("Save Error")
                                }
                                completion(true)
                                return
                            }
                        }
                    } catch {
                        print("Failed")
                    }
                }
                print("Download Finished")
                print(data)
                self.displayedImages.append(UIImage(data: data)!)
                print("doucnt \(self.displayedImages.count)")
                completion(true)
            }
        }
    }
    
    @objc func toCompare(sender: UIButton) {
        performSegue(withIdentifier: "compare", sender: nil)
    }
}
