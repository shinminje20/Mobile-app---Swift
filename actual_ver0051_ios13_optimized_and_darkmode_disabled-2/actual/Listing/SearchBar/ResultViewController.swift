//
//  ResultViewController.swift
//  actual
//
//  Created by Jinwook Kim on 2019-08-21.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit
import Firebase

class ResultViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITabBarControllerDelegate, UIViewControllerTransitioningDelegate {
    
    let transition = CircularTransition()
    var filterBtn:UIButton!
    
    var data : String?
    var db: Firestore!
    let storageRef = Storage.storage().reference()
    var isStation : Bool = true //later to implement city search
    
    var fetchingMore = false
    var reloadingStatus = false
    var fetchingStartPoint = -1
    var fetchingStartDocumentID = ""
    
    var testProperty = [Property]()
    var displayedImages = [UIImage]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var gradient: CAGradientLayer!  //test gradient
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    //    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //추가 및 변경
    override func viewWillAppear(_ animated: Bool) {
        print("&&&&&==============================12341234")
        print("before filtering")
        print("&&&&&==============================12341234")
        // FROMFILTERING은 view가 FilterViewController에서 왔는지 DetailedViewController에서 왔는지를 구분해준다
        if FILTERING && FROMFILTERING {
            fetchingMore = false
            reloadingStatus = false
            fetchingStartPoint = -1
            fetchingStartDocumentID = ""
            testProperty = []
            print("&&&&&==============================12341234")
            print("inside filtering")
            print("&&&&&==============================12341234")
            self.loadCollectionTestProperty()
        }
    }
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        if let index = data!.firstIndex(of: ",") {
            data = String(data!.prefix(upTo: index))
            isStation = false
        }
        //        let btn = UIButton(image: UIImage(named: "list_filter"), style: .plain, target: self, action: #selector(toFilter))
        
        let btnFrame = CGRect(x: Double(UIScreen.main.bounds.width) * 0.75, y: Double(UIScreen.main.bounds.height) *  0.8, width: Double(UIScreen.main.bounds.width) * 0.17, height: Double(UIScreen.main.bounds.width) * 0.17 )
        filterBtn = UIButton(type: .custom)
        filterBtn.frame = btnFrame
        
        //        let myFirstButton = UIButton()
        filterBtn.layer.cornerRadius = 0.5 * filterBtn.bounds.size.width
        filterBtn.clipsToBounds = true
        filterBtn.setImage(UIImage(named: "list_filter"), for: .normal)
        filterBtn.backgroundColor = UIColor(rgb: 0x8389BA)
        filterBtn.addTarget(self, action: #selector(toFilter(sender:)), for: .touchUpInside)
        
        filterBtn.layer.shadowColor = UIColor.black.cgColor
        filterBtn.layer.masksToBounds = false
        filterBtn.layer.shadowRadius = 3
        filterBtn.layer.shadowOpacity = 1.0
        filterBtn.layer.shadowOffset = CGSize(width: 2, height: 2)
        
        //        filterBtn.addTarget(self, action: #selector(wasDragged(button:event:)), for: UIControl.Event.touchDragInside)
        
        // [FIREBASE START setup]
        db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        // keyboard hiding when draggin collection view
        self.collectionView.keyboardDismissMode = .onDrag
        
        self.tabBarController?.delegate = self
        
        let nibNameFirst = UINib(nibName: "ListingCollectionViewCell", bundle: nil)
        collectionView.register(nibNameFirst, forCellWithReuseIdentifier: "listingcell")
        
        loadCollectionTestProperty()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        self.view.addSubview(collectionView)
        
        let longTitleLabel = UILabel()
        longTitleLabel.text = data
        longTitleLabel.font = UIFont(name:"FiraSans-Bold",size:27)
        longTitleLabel.textColor = UIColor(rgb: 0x8389BA)
        longTitleLabel.sizeToFit()
        
        let rightItem = UIBarButtonItem(customView: longTitleLabel)
        self.navigationItem.rightBarButtonItem = rightItem
        
        self.view.addSubview(filterBtn)
        
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
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        let tabBarIndex = tabBarController.selectedIndex
        
        print(tabBarIndex)
        
        if tabBarIndex == 0 {
            self.collectionView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
    
    //추가 및 변경
    private func loadCollectionTestProperty() {
        //        var reference = db.collection("canada").document("BC").collection("Vancouver").order(by: "timeStamp", descending: true)
        var reference: Query = db.collection("NorthAmerica").document("Canada").collection("BC")
        
        print("==================")
        print("Before if FILTERING")
        print("==================")
        
        if FILTERING {
            print("==================")
            print("inside if FILTERING")
            print("==================")
            var conditions:[String] = []
            switch true {
            case CONDITION[0]:
                conditions.append("RoomShare")
            case CONDITION[1]:
                conditions.append("RoomRent")
            case CONDITION[2]:
                conditions.append("TakeOver")
            default :
                print("nothing in conditions")
            }
            
            var type:String!
            switch true {
            case BUILDINGTYPES[0]:
                type = "Condo"
            case BUILDINGTYPES[1]:
                type = "House"
            default :
                type = ""
            }
            
            print("+++++=================+++++++")
            print("2번쨰 print")
            print(PRICE_MAX)
            print(PRICE_MIN)
            print(NUMBED)
            print(NUMBATH)
            print("+++++=================+++++++")
            // 여기서 reference.whereField("transportation.station", isEqualTo: data).whereField("price", isLessThanOrEqualTo: PRICE_MAX).whereField("price", isGreaterThanOrEqualTo: PRICE_MIN).order(by: "price") 이러고 잇었음
            // 레알 군대갔다온놈인가 싶음
            // reference = 이거 해줬어야함. 그래도 민재는 멋있으니까 넘어감
            reference = reference.whereField("transportation.station", isEqualTo: data)
            if NUMBED == "Studio" {
                reference = reference.whereField("numBed", isEqualTo: 1)
                print("1")
            } else {
                reference = reference.whereField("numBed", isEqualTo: Int(NUMBED))
                print("2")
            }
            if NUMBATH != "" {
                reference = reference.whereField("numBath", isEqualTo: Int(NUMBATH))
                print("3")
            }
            if type != "" {
                reference = reference.whereField("type", isEqualTo: type)
                print("5")
            }
            if PRICE_MAX > -1 {
                reference = reference.whereField("price", isLessThanOrEqualTo: PRICE_MAX)
                print("6")
            }
            if PRICE_MIN > -1 {
                reference = reference.whereField("price", isGreaterThanOrEqualTo: PRICE_MIN)
                print("7")
            }
            
            if conditions.count == 0 {
                if PRICE_MIN > -1 || PRICE_MAX > -1 {
                    reference = reference.order(by: "price")
                    print("8")
                }
                reference = reference.order(by: "timeStamp", descending: true)
            }
            
            for condition in conditions {
                var innerRef = reference
                innerRef = innerRef.whereField("condition", isEqualTo: condition)
                if PRICE_MIN > -1 || PRICE_MAX > -1 {
                    innerRef = innerRef.order(by: "price")
                    print("8")
                }
                innerRef = innerRef.order(by: "timeStamp", descending: true)
                if fetchingStartPoint < 0 {
                    innerRef = innerRef.limit(to: 5)
                } else {
                    innerRef = innerRef.start(after: [fetchingStartPoint]).limit(to: 5)
                }
                
                innerRef.getDocuments(){ (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        let group = DispatchGroup()
                        for document in querySnapshot!.documents {
                            if let newProperty = Property(dictionary: document.data()) {
                                newProperty.address.fullAddress = newProperty.address.address+", "+newProperty.address.city+", "+newProperty.address.province
                                self.fetchingStartPoint = newProperty.timeStamp
                                self.fetchingStartDocumentID = newProperty.documentID
                                newProperty.documentID = document.documentID
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
        } else {
            if isStation {
                reference = reference.whereField("transportation.station", isEqualTo: data).order(by: "timeStamp", descending: true)
            } else {
                reference = reference.whereField("address.city", isEqualTo: data).order(by: "timeStamp", descending: true)
            }
        }
        print("+++++=================+++++++")
        print("2번쨰 print")
        print(PRICE_MAX)
        print(PRICE_MIN)
        print("+++++=================+++++++")
        
        // Filter 때문에 위에서 testProperty에 element 가 들어갔다면, 다시 할필요가 없음
        if !FILTERING {
            if fetchingStartPoint < 0 {
                reference = reference.limit(to: 5)
            } else {
                reference = reference.start(after: [fetchingStartPoint]).limit(to: 5)
            }
            self.activityIndicator.startAnimating()
            reference.getDocuments(){ (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    let group = DispatchGroup()
                    for document in querySnapshot!.documents {
                        if let newProperty = Property(dictionary: document.data()) {
                            newProperty.address.fullAddress = newProperty.address.address+", "+newProperty.address.city+", "+newProperty.address.province
                            self.fetchingStartPoint = newProperty.timeStamp
                            self.fetchingStartDocumentID = newProperty.documentID
                            newProperty.documentID = document.documentID
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
        //        if isFiltering(){
        //            return collectionFilteredProperties.count
        //        }
        return testProperty.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listingcell", for: indexPath) as! ListingCollectionViewCell
        var property = Property()
        
        property = testProperty[indexPath.row]
        
        cell.listingImage.image = property.images[0]
        cell.listingImage.layer.sublayers?.popLast()
        
        //9/13 변경
//        let gradient = CAGradientLayer()
//        gradient.frame = cell.bounds
//        gradient.colors = [UIColor(red: 70, green: 71, blue: 73).withAlphaComponent(0.4).cgColor, UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor(red: 70, green: 71, blue: 73).withAlphaComponent(0.4).cgColor]
//        gradient.locations = [0, 0.2, 0.8, 1.0]
//        cell.listingImage.layer.insertSublayer(gradient, at:0)
        
        //9/13 추가
        cell.bedIcon.image = UIImage(named: "icon_bed2")
        cell.bathIcon.image = UIImage(named: "icon_bath")
        cell.moveIcon.image = UIImage(named: "icon_moveIn")
        
        // =====================================================================
        // Changing Font
        // =====================================================================
        //        cell.priceLable.font = UIFont(name:"FiraSans-Regular",size:14)
        
        cell.priceLable.text = "$\(property.price)"
        cell.priceLable.font = UIFont(name:"FiraSans-Bold",size:16)
        //9/13 변경
        cell.priceLable.textColor = .black//UIColor(red: 255, green: 255, blue: 255)
        
        if property.verified == true {
            cell.verifiedIconImage.image = UIImage(named: "list_verified")
        }
        
        //9/13 추가
        cell.firstIconImage.image = UIImage(named: "\(property.condition)_point")
        cell.secondIconImage.image = UIImage(named: "\(property.condition)_point")
//        var image:String?
//        print("======================================================")
//        print(property.condition)
//        print("======================================================")
        
//        switch property.condition {
//
//        case "TakeOver":
//            image = "mainTakeOverBtn"
//        case "RoomRent" :
//            image = "list_roomrent"
//        default:
//            image = "mainShareBtn"
//        }
        
//        cell.typeIconImage.image = UIImage(named: "icon_\(property.condition)")
        cell.cityLabel.text = property.address.city
        cell.cityLabel.font = UIFont(name:"FiraSans-Bold",size:16)
        cell.cityLabel.adjustsFontSizeToFitWidth = true
        //9/13 변경
        cell.cityLabel.textColor = .black//UIColor(red: 255, green: 255, blue: 255)
        
        //        cell.typeIconImage.image = UIImage(named: "list_\(property.type)")
        
        cell.bedLabel.text = "\(property.numBed) Br"
        //        cell.bedLabel.font = UIFont.systemFont(ofSize: 12)
        cell.bedLabel.adjustsFontSizeToFitWidth = true
        cell.bedLabel.textAlignment = .center
        //9/13 변경
        cell.bedLabel.textColor = .black//UIColor(red: 255, green: 255, blue: 255)
        
        cell.bathLabel.text = "\(property.numBath) Ba"
        //        cell.bathLabel.font = UIFont.systemFont(ofSize: 12)
        cell.bathLabel.adjustsFontSizeToFitWidth = true
        cell.bathLabel.textAlignment = .center
        //9/13 변경
        cell.bathLabel.textColor = .black//UIColor(red: 255, green: 255, blue: 255)
        
        cell.moveLabel.text = property.moveInDate
        //        cell.moveLabel.font = UIFont.systemFont(ofSize: 12)
        cell.moveLabel.adjustsFontSizeToFitWidth = true
        cell.moveLabel.textAlignment = .center
        //9/13 변경
        cell.moveLabel.textColor = .black//UIColor(red: 255, green: 255, blue: 255)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.width*220/375
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "DetailedListingViewController", sender: indexPath)
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL, completion: @escaping (_ success: Bool) -> Void) {
        // Do something
        print("Download Started")
        //        group.enter()
        
        let queue = DispatchQueue(label: "imageLoad", attributes: .concurrent)
        
        queue.async {
            self.getData(from: url) { data, response, error in
                guard let data = data, error == nil else { return }
                print(response?.suggestedFilename ?? url.lastPathComponent)
                print("Download Finished")
                self.displayedImages.append(UIImage(data: data)!)
                // Call completion, when finished, success or faliure
                completion(true)
                //                group.leave()
                //                group.notify(queue: DispatchQueue.main) {
                
                //                }
            }
        }
    }
    
    @objc func toFilter(sender: UIButton) {
        
        performSegue(withIdentifier: "filter", sender: nil)
    }
    
    //    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    //        transition.transitionMode = .present
    //        transition.startingPoint = filterBtn.center
    //        transition.circleColor = filterBtn.backgroundColor!
    //
    //        return transition
    //    }
    //
    //    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    //        transition.transitionMode = .dismiss
    //        transition.startingPoint = filterBtn.center
    //        transition.circleColor = filterBtn.backgroundColor!
    //
    //        return transition
    //    }
    //
    
    
    
    @objc func wasDragged(button: UIButton, event : UIEvent) {
        print("dragged")
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
