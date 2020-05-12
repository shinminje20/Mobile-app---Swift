//
//  SelectCompareViewController.swift
//  actual
//
//  Created by Sukkwon On on 2019-08-06.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class SelectCompareViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITabBarControllerDelegate {

    var testProperty = [Property]()
    var cellArray = [cellData]()

    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var compareBtn: UIButton!

    var selectedIndex = [IndexPath]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    var displayedImages = [UIImage]()

    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()

    override func viewWillAppear(_ animated: Bool) {
        loadFavTestProperty()
        collectionView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let longTitleLabel = UILabel()
        longTitleLabel.text = "Select 2 items to compare"
        longTitleLabel.font = UIFont(name:"FiraSans-Bold",size:18)
        longTitleLabel.textColor = UIColor(rgb: 0x8389BA)
        longTitleLabel.textAlignment = .center
        longTitleLabel.sizeToFit()

        self.navigationItem.titleView = longTitleLabel

        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = true

        compareBtn.backgroundColor = .lightGray
        compareBtn.setTitle("P r o c e e d",for: .normal)
        compareBtn.tintColor = .white
        compareBtn.titleLabel?.font = UIFont(name:"FiraSans-Bold", size: 18)

        compareBtn.addTarget(self, action: #selector(compareReady), for: .touchUpInside)

        // =====================================================================
        // Table Data Init
        // =====================================================================
        cellArray = [
            cellData(cell : 1, title: "", height: UIScreen.main.bounds.width * 110/366, name: "CompareFavoriteCollectionViewCell", identifier: "comparefavoritecell")
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
                //추가 및 변경
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
                //추가
                newProperty.party = data.value(forKey: "party") as! Bool
                newProperty.manonly = data.value(forKey: "manonly") as! Bool
                newProperty.womanonly = data.value(forKey: "womanonly") as! Bool
                newProperty.both = data.value(forKey: "both") as! Bool
                print("================================12345========================================")
                print(newProperty.party)
                print(newProperty.manonly)
                print(newProperty.womanonly)
                print(newProperty.both)
                print("==================================12345======================================")
                newProperty.transportation.placeName = (data.value(forKey: "transportationName") as! String)
                newProperty.transportation.displayedTime = (data.value(forKey: "transportationTime") as! String)

                newProperty.imageURL = data.value(forKey: "imageurl") as! [String]

                newProperty.documentID = data.value(forKey: "documentID") as! String
                newProperty.uid = data.value(forKey: "uid") as! String

                self.activityIndicator.startAnimating()
                group.enter()
                let myURL = newProperty.imageURL[0]
                self.downloadImage(from: URL(string: myURL)!, completion: {(success) -> Void in
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
        //setting back button in navigation bar
        let backItem = UIBarButtonItem()
        backItem.title = ""
        backItem.tintColor = UIColor(rgb: 0x8389BA)
        navigationItem.backBarButtonItem = backItem

        super.prepare(for: segue, sender: sender)
        if let list = collectionView.indexPathsForSelectedItems {
            if list.count == 2 {
                if segue.identifier == "SelectDestinationViewController"{
                    var selectedProperty1 = Property()
                    selectedProperty1 = testProperty[list[0].row]
                    var selectedProperty2 = Property()
                    selectedProperty2 = testProperty[list[1].row]

                    if segue.identifier == "SelectDestinationViewController"{
                        if segue.destination is SelectDestinationViewController
                        {
                            let vc = segue.destination as? SelectDestinationViewController
                            vc?.property1 = selectedProperty1
                            vc?.property2 = selectedProperty2
                            collectionView.deselectAllItems(animated: true)
                            compareBtn.backgroundColor = .lightGray
                        }
                    }
                }
            }
        }

    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if section == 0 {
            return testProperty.count // favorite cell
        }
        else {
            return 1
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let curcell:cellData = cellArray[indexPath.section]


        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: curcell.identifier, for: indexPath) as! CompareFavoriteCollectionViewCell

        var property = Property()
        property = testProperty[indexPath.row]
        //for testing

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

        //        if property.new == true {
        //            cell.newIconImage.image = UIImage(named: "list_new")
        //        }
        //        if property.verified == true {
        //            cell.secondIconImage.image = UIImage(named: "list_verified")
        //        }
        //        cell.firstIconImage.image = UIImage(named: "list_\(property.type)")
        if property.verified == true {
            cell.newIconImage.image = UIImage(named: "list_verified")
        }

        cell.firstIconImage.image = UIImage(named: "\(property.condition)_point")
        cell.secondIconImage.image = UIImage(named: "\(property.condition)_point")

        cell.bedLabel.text = "\(property.numBed) BR"
        cell.bedLabel.font = UIFont.systemFont(ofSize: 10)
        cell.bedLabel.textColor = UIColor(rgb:0x464749)
        cell.bedLabel.textAlignment = .center

        cell.bathLabel.text = "\(property.numBath) Bath"
        cell.bathLabel.font = UIFont.systemFont(ofSize: 10)
        cell.bathLabel.textColor = UIColor(rgb:0x464749)
        cell.bathLabel.textAlignment = .center

        cell.moveInLabel.text = "May 31"
        cell.moveInLabel.font = UIFont.systemFont(ofSize: 10)
        cell.moveInLabel.textColor = UIColor(rgb:0x464749)
        cell.moveInLabel.textAlignment = .center

        //        cell.sqftLabel.text = "\(property.size) sqrt"
        //        cell.sqftLabel.font = UIFont.systemFont(ofSize: 10)
        //        cell.sqftLabel.textColor = UIColor(rgb:0x464749)
        //        cell.sqftLabel.textAlignment = .center

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = UIScreen.main.bounds.width
        let height:CGFloat = cellArray[indexPath.section].height

        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("cell selected at row \(indexPath.row)")

        if let list = collectionView.indexPathsForSelectedItems {
            if list.count == 1 {
                if let cell = collectionView.cellForItem(at: indexPath) {
                    cell.layer.borderWidth = 5.0
                    cell.layer.borderColor = UIColor(rgb:0x7EB2E0).cgColor
                }
                //                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "comparefavoritecell", for: indexPath) as! CompareFavoriteCollectionViewCell
                //                cell.numImage.image = UIImage(named: "numOne")



                print("11111")
            }
            else if list.count == 2 {
                if let cell = collectionView.cellForItem(at: indexPath) {
                    cell.layer.borderWidth = 5.0
                    cell.layer.borderColor = UIColor(rgb:0xE59C6F).cgColor
                    compareBtn.backgroundColor = UIColor(rgb: 0x8389BA)
                    //추가 9/12일
                    //                    cell.numImage.image = UIImage(named: "numTwo")

                }
                //                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "comparefavoritecell", for: indexPath) as! CompareFavoriteCollectionViewCell
                //                cell.numImage.image = UIImage(named: "numTwo")


                print("22222")
            }
            else if list.count >= 3 {
                let alertController = UIAlertController(title: "Oops", message:
                    "You are limited to \(2) selections", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                }))
                self.present(alertController, animated: true, completion: nil)
                collectionView.deselectItem(at: indexPath, animated: false)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let list = collectionView.indexPathsForSelectedItems {
            if list.count < 2 {
                if list.count == 1 {
                    if let cell = collectionView.cellForItem(at: list[0]) {
                        cell.layer.borderColor = UIColor(rgb:0x7EB2E0).cgColor
                    }
                }
                compareBtn.backgroundColor = .lightGray
            }
        }
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.layer.borderWidth = 0.0
            cell.layer.borderColor = UIColor.white.cgColor
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

    func downloadImage(from url: URL, completion: @escaping (_ success: Bool) -> Void) {
        print("Download Started")
        let queue = DispatchQueue(label: "imageLoad", attributes: .concurrent)

        queue.async {
            self.getData(from: url) { data, response, error in
                guard let data = data, error == nil else { return }
                print(response?.suggestedFilename ?? url.lastPathComponent)
                print("Download Finished")
                self.displayedImages.append(UIImage(data: data)!)
                completion(true)
            }
        }
    }

    @objc func compareReady(sender: UIButton) {
        if let list = collectionView.indexPathsForSelectedItems {
            if list.count == 2 {
                performSegue(withIdentifier: "SelectDestinationViewController", sender: nil)
            }
            else {
                let alertController = UIAlertController(title: "Oops", message:
                    "You are limited to \(2) selections", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                }))
                self.present(alertController, animated: true, completion: nil)
            }
        }

    }
}

extension UICollectionView {

    func deselectAllItems(animated: Bool) {
        guard let selectedItems = indexPathsForSelectedItems else { return }
        for indexPath in selectedItems {
            deselectItem(at: indexPath, animated: animated)
            if let cell = self.cellForItem(at: indexPath) {
                cell.layer.borderWidth = 0.0
                cell.layer.borderColor = UIColor.white.cgColor
            }
        }
    }
}
