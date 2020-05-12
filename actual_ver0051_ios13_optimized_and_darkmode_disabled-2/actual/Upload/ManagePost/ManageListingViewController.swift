//
//  ListingViewController.swift
//  actual
//
//  Created by Sukkwon On on 2019-03-17.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit
import Firebase

class ManageListingViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITabBarControllerDelegate {
    
    var db: Firestore!
    let storageRef = Storage.storage().reference()
    
    var fetchingMore = false
    var reloadingStatus = false
    var fetchingStartPoint = -1
    
    var testProperty = [Property]()
    var displayedImages = [UIImage]()
    //    var collectionFilteredProperties = [Property]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var gradient: CAGradientLayer!  //test gradient
    
    //    let searchController = UISearchController(searchResultsController: nil)
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // [FIREBASE START setup]
        db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        // keyboard hiding when draggin collection view
        self.collectionView.keyboardDismissMode = .onDrag
        
        self.tabBarController?.delegate = self
        
        
        let nibNameFirst = UINib(nibName: "ManageListingCollectionViewCell", bundle: nil)
        collectionView.register(nibNameFirst, forCellWithReuseIdentifier: "listingcell")
        
        loadCollectionTestProperty()
        //        loadTestProperty()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        self.view.addSubview(collectionView)
        
        let longTitleLabel = UILabel()
        longTitleLabel.text = "M Y L I S T"
        longTitleLabel.font = UIFont(name:"FiraSans-Bold",size:20)
        longTitleLabel.textColor = UIColor(rgb: 0x8389BA)
        longTitleLabel.textAlignment = .center
        longTitleLabel.sizeToFit()
        
        self.navigationItem.titleView = longTitleLabel
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.color = UIColor(rgb: 0x8389BA)
        self.view.addSubview(activityIndicator)
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
        if segue.identifier == "edit"{ //+++++++++++++++++++바꿔+++++++++++++++++++++++++++++++
            //Making sure the destination is correct
            guard let selectedIndexPath = sender as? NSIndexPath else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            //Selected recipe is different depending on filter status
            var selectedProperty = Property()
            
            selectedProperty = testProperty[selectedIndexPath.row]
            
            
            //Can't pass data to a nagivationController directly. Must keep going through scenes until DetailedRecipeViewController
            if segue.identifier == "edit"{ //+++++바꿔야댐+=++++++++
                
                if segue.destination is EditViewController
                {
                    let vc = segue.destination as? EditViewController
                    vc?.property = selectedProperty
                }
            }
        }
        // Else, user wants to upload a list
        //else if segue.identifier == "AddViewController"{
        //}
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        let tabBarIndex = tabBarController.selectedIndex
        
        print(tabBarIndex)
        
        if tabBarIndex == 0 {
            self.collectionView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
    
    
    //+++++바꿔야댐+=++++++++//+++++바꿔야댐+=++++++++//+++++바꿔야댐+=++++++++//+++++바꿔야댐+=++++++++
    private func loadCollectionTestProperty() {
        //        var reference = db.collection("canada").document("BC").collection("Vancouver").order(by: "timeStamp", descending: true)
        let user = Auth.auth().currentUser
        print("========================================")
        print("before reference")
        print(user)
        var reference = db.collection("NorthAmerica").document("Canada").collection("BC").whereField("uid", isEqualTo: user!.uid).order(by: "timeStamp", descending: true)
        
        if fetchingStartPoint < 0 {
            reference = reference.limit(to: 5)
        } else {
            reference = reference.start(after: [fetchingStartPoint]).limit(to: 5)
        }
        
        self.activityIndicator.startAnimating()
        reference.getDocuments {(querySnapshot, err) in

            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let group = DispatchGroup()
                for document in querySnapshot!.documents {
                    if let newProperty = Property(dictionary: document.data()) {
                        newProperty.address.fullAddress = newProperty.address.address+", "+newProperty.address.city+", "+newProperty.address.province
                        self.fetchingStartPoint = newProperty.timeStamp
                        newProperty.documentID = document.documentID
                        print("\(newProperty.timeStamp)")
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
                        
                    } else {
                        print("Document does not exist")
                    }
                }
                group.notify(queue: DispatchQueue.main) {
                    self.activityIndicator.stopAnimating()
                    print("*************")
                    print("NOW BYE")
                    print("*************")
                    
                    self.collectionView.reloadData()
                    self.fetchingMore = false
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height && contentHeight > 0 {
            if !fetchingMore {
                beginBatchFetch()
            }
        }
    }
    
    func beginBatchFetch() {
        fetchingMore = true
        print("fetching begin")
        
        loadCollectionTestProperty()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return testProperty.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listingcell", for: indexPath) as! ManageListingCollectionViewCell
        var property = Property()
        property = testProperty[indexPath.row]
        
        cell.listingImage.image = property.images[0]
        cell.listingImage.layer.sublayers?.popLast()
//        9/13 변경
//        let gradient = CAGradientLayer()
//        gradient.frame = cell.bounds
//        gradient.colors = [UIColor(red: 70, green: 71, blue: 73).withAlphaComponent(0.4).cgColor, UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor(red: 70, green: 71, blue: 73).withAlphaComponent(0.4).cgColor]
//        gradient.locations = [0, 0.2, 0.8, 1.0]
//        cell.listingImage.layer.insertSublayer(gradient, at:0)
        
        
        //9/13 추가 및 변경
//        cell.bedIcon.image = UIImage(named: "list_bed")
//        cell.bathIcon.image = UIImage(named: "list_bath")
//        cell.moveIcon.image = UIImage(named: "list_moveIn")
        cell.bedIcon.image = UIImage(named: "icon_bed2")
        cell.bathIcon.image = UIImage(named: "icon_bath")
        cell.moveIcon.image = UIImage(named: "icon_moveIn")
        
        cell.priceLable.text = "$\(property.price)"
        cell.priceLable.font = UIFont(name:"FiraSans-Bold",size:16)
        //9/13 색상  블랙
        cell.priceLable.textColor = .black//UIColor(red: 255, green: 255, blue: 255)
        
        if property.verified == true {
            cell.verifiedIconImage.image = UIImage(named: "list_verified")
        }
        cell.firstIconImage.image = UIImage(named: "\(property.condition)_point")
        cell.secondIconImage.image = UIImage(named: "\(property.condition)_point")
        // 추가 8월 28일  + xib file 에도 city label 추가
//        var image:String?
//        print("======================================================")
//        print(property.condition)
//        print("======================================================")
//
//        switch property.condition {
//
//        case "TakeOver":
//            image = "mainTakeOverBtn"
//        case "RoomRent" :
//            image = "list_roomrent"
//        default:
//            image = "mainShareBtn"
//        }
//
//        cell.typeIconImage.image = UIImage(named: image!)
        cell.cityLabel.text = property.address.city
        cell.cityLabel.font = UIFont(name:"FiraSans-Bold",size:16)
        cell.cityLabel.adjustsFontSizeToFitWidth = true
        //9/13 색상  블랙
        cell.cityLabel.textColor = .black//UIColor(red: 255, green: 255, blue: 255)
//        cell.typeIconImage.image = UIImage(named: "list_\(property.type)")
        //여기까지 추가 및 변경
        cell.bedLabel.text = "\(property.numBed) Br"
        cell.bedLabel.adjustsFontSizeToFitWidth = true
        cell.bedLabel.textAlignment = .center
        //9/13 색상  블랙
        cell.bedLabel.textColor = .black//UIColor(red: 255, green: 255, blue: 255)
        
        cell.bathLabel.text = "\(property.numBath) Ba"
        cell.bathLabel.adjustsFontSizeToFitWidth = true
        cell.bathLabel.textAlignment = .center
        //9/13 색상  블랙
        cell.bathLabel.textColor = .black//UIColor(red: 255, green: 255, blue: 255)
        
        cell.moveLabel.text = property.moveInDate
        cell.moveLabel.adjustsFontSizeToFitWidth = true
        cell.moveLabel.textAlignment = .center
        //9/13 색상  블랙
        cell.moveLabel.textColor = .black//UIColor(red: 255, green: 255, blue: 255)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.width*270/375
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "edit", sender: indexPath)
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL, completion: @escaping (_ success: Bool) -> Void) {
        // Do something
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
}
