//
//  ListingViewController.swift
//  actual
//
//  Created by Sukkwon On on 2019-03-17.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit
import Firebase

class ListingViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITabBarControllerDelegate {
    
    var db: Firestore!
    let storageRef = Storage.storage().reference()

    var fetchingMore = false
    var reloadingStatus = false
    var fetchingStartPoint = -1
    
    var testProperty = [Property]()
    var displayedImages = [UIImage]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var gradient: CAGradientLayer!  //test gradient
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func awakeFromNib() {
        // [FIREBASE START setup]
        db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
//        loadCollectionTestProperty()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("inside")
        print(self.navigationController!.navigationBar.frame.size.height)
        print("inside")
        
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            let email = user.email
            let photoURL = user.photoURL
        }
        
        // keyboard hiding when draggin collection view
        self.collectionView.keyboardDismissMode = .onDrag
        
        self.tabBarController?.delegate = self
        
        let nibNameFirst = UINib(nibName: "ListingCollectionViewCell", bundle: nil)
        collectionView.register(nibNameFirst, forCellWithReuseIdentifier: "listingcell")
        
        
//        loadTestProperty()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        self.view.addSubview(collectionView)
        
        let searchImage = UIImage(named: "list_searchOff")!
        let searchButton = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(toSearchList))
        searchButton.tintColor = UIColor(rgb: 0x8389BA)
        navigationItem.rightBarButtonItems = [searchButton]

        let longTitleLabel = UILabel()
        longTitleLabel.text = "List"
        longTitleLabel.font = UIFont(name:"FiraSans-Bold",size:27)
        longTitleLabel.textColor = UIColor(rgb: 0x8389BA)
        longTitleLabel.sizeToFit()

        let leftItem = UIBarButtonItem(customView: longTitleLabel)
        self.navigationItem.leftBarButtonItem = leftItem
        
        guard
            let navigationController = navigationController,
            let flareGradientImage = CAGradientLayer.primaryGradient(on: navigationController.navigationBar)
            else {
                print("Error creating gradient color!")
                return
        }

        navigationController.navigationBar.barTintColor = UIColor(red: 255, green: 255, blue: 255)    //UIColor(patternImage: flareGradientImage) //
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
//            if isFiltering(){
//                selectedProperty = collectionFilteredProperties[selectedIndexPath.row]
//            } else {
            selectedProperty = testProperty[selectedIndexPath.row]
//            }
            
            //Can't pass data to a nagivationController directly. Must keep going through scenes until DetailedRecipeViewController
            if segue.identifier == "DetailedListingViewController"{

                if segue.destination is DetailedListingViewController
                {
                    let vc = segue.destination as? DetailedListingViewController
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
    
    private func loadCollectionTestProperty() {
        var reference = db.collection("NorthAmerica").document("Canada").collection("BC").order(by: "timeStamp", descending: true)
//        var reference = db.collection("NorthAmerica").document("Canada").collection("BC").order(by: "timeStamp", descending: true)
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
        
//        let gradient = CAGradientLayer()
//        gradient.frame = cell.bounds
//        gradient.colors = [UIColor(red: 70, green: 71, blue: 73).withAlphaComponent(0.4).cgColor, UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor(red: 70, green: 71, blue: 73).withAlphaComponent(0.8).cgColor]
//        gradient.locations = [0, 0.2, 0.6, 1.0]
//        cell.listingImage.layer.insertSublayer(gradient, at:0)
        
        //추가 9/13
        cell.bedIcon.image = UIImage(named: "icon_bed2")
        cell.bathIcon.image = UIImage(named: "icon_bath")
        cell.moveIcon.image = UIImage(named: "icon_moveIn")

        cell.priceLable.text = "$\(property.price)"
        cell.priceLable.font = UIFont(name:"FiraSans-Bold",size:16)
        cell.priceLable.textColor = .black//UIColor(red: 255, green: 255, blue: 255)

        if property.verified == true {
            cell.verifiedIconImage.image = UIImage(named: "list_verified")
        }
        cell.firstIconImage.image = UIImage(named: "\(property.condition)_point")
        cell.secondIconImage.image = UIImage(named: "\(property.condition)_point")
        cell.firstIconImage.tintColor = .black
        cell.secondIconImage.tintColor = .black
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
        
//        cell.typeIconImage.image = UIImage(named: image!)
        cell.cityLabel.text = property.address.city
        cell.cityLabel.font = UIFont(name:"FiraSans-Bold",size:16)
        cell.cityLabel.adjustsFontSizeToFitWidth = true
        cell.cityLabel.textColor = .black//UIColor(red: 255, green: 255, blue: 255)
        
//        cell.typeIconImage.image = UIImage(named: "list_\(property.type)")
        
        cell.bedLabel.text = "\(property.numBed) Br"
        cell.bedLabel.font = UIFont.systemFont(ofSize: 14)
        cell.bedLabel.adjustsFontSizeToFitWidth = true
        cell.bedLabel.textAlignment = .center
        cell.bedLabel.textColor = .black//UIColor(red: 255, green: 255, blue: 255)
        
        cell.bathLabel.text = "\(property.numBath) Ba"
        cell.bathLabel.font = UIFont.systemFont(ofSize: 14)
        cell.bathLabel.adjustsFontSizeToFitWidth = true
        cell.bathLabel.textAlignment = .center
        cell.bathLabel.textColor = .black//UIColor(red: 255, green: 255, blue: 255)
        
        cell.moveLabel.text = property.moveInDate
        cell.moveLabel.font = UIFont.systemFont(ofSize: 14)
        cell.moveLabel.adjustsFontSizeToFitWidth = true
        cell.moveLabel.textAlignment = .center
        cell.moveLabel.textColor = .black//UIColor(red: 255, green: 255, blue: 255)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.width*270/375
        
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
            }
        }
    }
    
    @objc func toSearchList(sender: UIButton) {
        performSegue(withIdentifier: "search", sender: nil)
    }
}

extension CAGradientLayer {
    
    class func primaryGradient(on view: UIView) -> UIImage? {
        let gradient = CAGradientLayer()
        let startColor = UIColor(rgb: 0x9D7AB5)
        let endColor = UIColor(rgb: 0x659CC1)
        var bounds = view.bounds
        bounds.size.height += UIApplication.shared.statusBarFrame.size.height
        gradient.frame = bounds
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        return gradient.createGradientImage(on: view)
    }
    
    private func createGradientImage(on view: UIView) -> UIImage? {
        var gradientImage: UIImage?
        UIGraphicsBeginImageContext(view.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
        }
        UIGraphicsEndImageContext()
        return gradientImage
    }
}

// =====================================================================
// Search Bar Color
// =====================================================================
extension UISearchBar {

    func getTextField() -> UITextField? { return value(forKey: "searchField") as? UITextField }
    func setText(color: UIColor) { if let textField = getTextField() { textField.textColor = color } }

    func setTextField(color: UIColor) {
        guard let textField = getTextField() else { return }
        switch searchBarStyle {
        case .minimal:
            textField.layer.backgroundColor = color.cgColor
            textField.layer.cornerRadius = 6
        case .prominent, .default: textField.backgroundColor = color
        }
    }

    func setSearchImage(color: UIColor) {
        guard let imageView = getTextField()?.leftView as? UIImageView else { return }
        imageView.tintColor = color
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
    }
}

extension Array {
    func insertionIndexOf(elem: Element, isOrderedBefore: (Element, Element) -> Bool) -> Int {
        var lo = 0
        var hi = self.count - 1
        while lo <= hi {
            let mid = (lo + hi)/2
            if isOrderedBefore(self[mid], elem) {
                lo = mid + 1
            } else if isOrderedBefore(elem, self[mid]) {
                hi = mid - 1
            } else {
                return mid // found at position mid
            }
        }
        return lo // not found, would be inserted at position lo
    }
}
