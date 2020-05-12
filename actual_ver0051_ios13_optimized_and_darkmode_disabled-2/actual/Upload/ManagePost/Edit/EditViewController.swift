
import Foundation
import UIKit
import CoreData
import MapKit
import ImageSlideshow
import MessageUI
import Firebase

class EditViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {
    
    var db: Firestore!
    let storageRef = Storage.storage().reference()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var slideshow:ImageSlideshow!
    @IBOutlet weak var deleteButton: UIButton!
    
    var property : Property?
    let firstcellheight:CGFloat = 129.5
    let secondcellheight:CGFloat = 137
    
    var cellArray = [cellData]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var readButtonTitle:String = "Read More"
    var numOfTextLines:Int = 0
    
    private let tableHeaderViewHeight: CGFloat = UIScreen.main.bounds.height*0.75
    private let tableHeaderViewCutaway: CGFloat = 40.0
    var headerMaskLayer: CAShapeLayer!
    
    var rentType:String!
    //추가
    var verified:Bool!
    // property member variables
    var author: String!
    var detailDescription: String!
    var mapView: MKMapView!
    var hostPhone: String!
    var hostEmail: String!
    var numBath: String!
    var numBed: String!
    var size: String!
    //    var smokingLabel: UILabel!
    //    var petLabel: UILabel!
    var address: String!
    var postalCode: String!
    var latitude: Double = 0.0
    var longitude: Double!
    var price: String!
    var moveInDate: String!
    var type:String!
    
    // Amenities
    var airCon: Bool!
    var balcony: Bool!
    var closet: Bool!
    var dishWash: Bool!
    var fridge: Bool!
    var heater: Bool!
    var kitchen: Bool!
    var laundry: Bool!
    var parking: Bool!
    var tub: Bool!
    var cableTV: Bool!
    var internet: Bool!
    var bed: Bool!
    var tubPublic: Bool!
    var toiletPublic: Bool!
    var stove: Bool!
    var microwave: Bool!
    var dryerPublic: Bool!
    var deskChair: Bool!
    var hanger: Bool!
    
    // Rules
    var dog: Bool!
    var cat: Bool!
    var smoking: Bool!
    var drug: Bool!
    //추가
    var party: Bool!
    var manonly: Bool!
    var womanonly: Bool!
    var both: Bool!
    //추가 9/13
    var restAddress: String!
    var provinceAddress: String!
    var streetAddress: String!
    
    var transportationName: String!
    var transportationTime: String!
    
    var documentID: String!
    
    var uid: String!
    
    var images:[ImageSource] = []
    var imageURLs:[String] = []
    var displayedImages = [UIImage]()
    
    var profileImage:UIImage!
    
    var stationName:String!
    var stationDistance:String!
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBAction func deleteButtonIsTapped(_ sender: Any) {
        print("delete Button tapped")
        // delete all
        deleteData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = .zero
        self.view.addSubview(tableView)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.color = UIColor(rgb: 0x8389BA)
        self.view.addSubview(activityIndicator)
        profileImage = UIImage(named: "profile_default")
        
        deleteButton.backgroundColor = UIColor(rgb: 0xde522f)
        deleteButton.setTitle("D E L E T E",for: .normal)
        deleteButton.tintColor = .white
        deleteButton.titleLabel?.font = UIFont(name:"FiraSans-Bold", size: 18)
        if let property = property {
            displayedImages.append(property.images[0])
            // Search in CoreData of this property has been liked already
            let context = appDelegate.persistentContainer.viewContext
            
            let requestListings = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
            requestListings.returnsObjectsAsFaults = false
            
            do{
                let results = try context.fetch(requestListings)
                
                for data in results as! [NSManagedObject]{
                    // simply retrieve data from core data
                    let searchAddress = data.value(forKey: "addressAddress") as! String
                    let searchCity = data.value(forKey: "addressCity") as! String
                    let searchProvince = data.value(forKey: "addressProvince") as! String
                    let searchPostalCode = data.value(forKey: "addressPostalCode") as! String
                    
                    // if we find the correct listing, fill in the heart button
                    if (searchAddress == property.address.address &&
                        searchCity == property.address.city &&
                        searchProvince == property.address.province &&
                        searchPostalCode == property.address.postalCode){
                        
//                        button.isSelected = true
                    }
                }
            } catch{
                fatalError()
            }
            self.rentType = property.condition
            self.author = property.author
            self.address = property.address.city
            self.postalCode = property.address.postalCode
            self.provinceAddress = property.address.province
            self.streetAddress = property.address.address
            self.restAddress = streetAddress + ", " + provinceAddress + ", " + postalCode
            self.latitude = property.address.latitude
            self.longitude = property.address.longitude
            self.hostEmail = property.hostEmail
            self.hostPhone = property.hostPhone
            self.price = "$ \(property.price)"
            self.numBed = "\(property.numBed) BR"
            self.numBath = "\(property.numBath) BR"
            self.moveInDate = property.moveInDate
            //            dateFormatter.dateFormat = "MMM DD"
            //            let displayedMoveInDate = dateFormatter.string(from: date!)
            //            self.moveInDate = displayedMoveInDate
            self.size = "\(property.size) sqft"
            self.detailDescription = property.description
            self.type = property.type
            //추가 9/12
            self.verified = property.verified
            self.airCon = property.airCon
            self.balcony = property.balcony
            self.closet = property.closet
            self.dishWash = property.dishWash
            self.fridge = property.fridge
            self.heater = property.heater
//            self.kitchen = property.kitchen
            self.laundry = property.laundry
            self.parking = property.parking
            self.tub = property.tub
            self.cableTV = property.cableTV
            self.internet = property.internet
            self.bed = property.bed
            self.tubPublic = property.tubPublic
            self.toiletPublic = property.toiletPublic
            self.stove = property.stove
            self.microwave = property.microwave
            self.dryerPublic = property.dryerPublic
            self.deskChair = property.deskChair
            self.hanger = property.hanger
            
            
            self.dog = property.dogs
            self.cat = property.cats
            self.smoking = property.smoking
            self.drug = property.drug
            self.party = property.party
            self.manonly = property.manonly
            self.womanonly = property.womanonly
            self.both = property.both
            self.transportationName = property.transportation.placeName
            self.transportationTime = property.transportation.displayedTime
            
            self.documentID = property.documentID
            
            self.uid = property.uid
            
            self.stationName = property.transportation.placeName
            self.stationDistance = property.transportation.displayedTime
            let group = DispatchGroup()
            self.activityIndicator.startAnimating()
            if property.imageURL.count == 1 {
                group.enter()
                // Create a reference to the file you want to download
                let islandRef = self.storageRef.child("User/\(property.uid)/0")
                // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                islandRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    if let error = error {
                        print("DetailedListingViewController - error in getting data from storage: ", error)
                    } else {
                        let image = UIImage(data: data!)
                        self.profileImage = image!
                        group.leave()
                    }
                }
            }
            else {
                group.enter()
                for i in 1...property.imageURL.count-1 {
                 
                    print(i)
                    let myURL = property.imageURL[i]
                 
                    self.downloadImage(from: URL(string: myURL)!, completion: {(success) -> Void in
                        if self.displayedImages.count == property.imageURL.count {
                            print("fejfelfe")
                            print(self.displayedImages[0].size)
                            let islandRef = self.storageRef.child("User/\(property.uid)/0")
                        
                            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                            islandRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                                group.leave()
                                if let error = error {
                                    print("DetailedListingViewController - error in getting data from storage: ", error)
                                } else {
                                    let image = UIImage(data: data!)
                                    self.profileImage = image!
                                }
                            }
                        
                        }
                    })
                   
                }
            }
            
            group.notify(queue: DispatchQueue.main) {
                self.activityIndicator.stopAnimating()
               
                print("*************")
                print("NOW BYE")
                print("*************")
                
                for image in self.displayedImages {
                    self.images.append(ImageSource(image: image))
                }
                self.slideshow.setImageInputs(self.images)
                self.tableView.allowsSelection = false
                let pageIndicator = UIPageControl()
                pageIndicator.currentPageIndicatorTintColor = UIColor.white
                pageIndicator.pageIndicatorTintColor = UIColor.lightGray
                // Dot indicator size
                pageIndicator.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                self.slideshow.pageIndicator = pageIndicator
                self.slideshow.circular = false
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
                self.slideshow.addGestureRecognizer(gestureRecognizer)
                self.tableView.reloadData()
            }

        }
        
        // =====================================================================
        // Table Data Init
        // =====================================================================
        cellArray = [
            cellData(cell : 1, title: "", height: UIScreen.main.bounds.width/2, name: "ProfileTableViewCell", identifier: "profilecell"),
            cellData(cell : 2, title: "Building Type", height: 70, name: "BuildingTypeTableViewCell", identifier: "buildingtypecell"),
            cellData(cell : 3, title: "Amenities", height: 350, name: "AmenitiesTableViewCell", identifier: "amenitiescell"),
            cellData(cell: 4, title: "Rules", height: 150, name: "RulesTableViewCell", identifier: "rulescell"),
            cellData(cell : 5, title: "Descriptions", height: 75, name: "DescriptionTableViewCell", identifier: "descriptionecell"),
            cellData(cell : 6, title: "Transportation by Walk", height: 50, name: "TransportationTableViewCell", identifier: "transportationcell"),
            cellData(cell : 7, title: "Map", height: 250, name: "MapTableViewCell", identifier: "mapcell") //ORIGINAL HEIGHT = 170
        ]
        
        for cell in cellArray {
            let nibName = UINib(nibName: cell.name, bundle: nil)
            tableView.register(nibName, forCellReuseIdentifier: cell.identifier)
        }
    }
    
    @objc func didTap() {
        slideshow.presentFullScreenController(from: self)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        print("prepare()")
//        super.prepare(for: segue, sender: sender)
//
//        //setting back button in navigation bar
//        let backItem = UIBarButtonItem()
//        backItem.title = ""
//        backItem.tintColor = UIColor(rgb: 0x8389BA)
//        navigationItem.backBarButtonItem = backItem
//
//        if segue.identifier == "editmapview"{
//            if segue.destination is DetailedMapViewController
//            {
//                let locationCoordinate = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
//                let vc = segue.destination as? DetailedMapViewController
//                vc?.coordination = locationCoordinate
//            }
//        }
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return comments.count
        return 1 // ******* See upper code for future code *******
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let curcell:cellData = cellArray[indexPath.section]
     
        switch curcell.cell {
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: curcell.identifier, for: indexPath) as! ProfileTableViewCell
            cell.priceLabel.text = self.price
            cell.priceLabel.font = UIFont(name:"FiraSans-Bold", size: 25)
            cell.priceLabel.textColor = UIColor(rgb:0x464749)

            //9/12 색상 변경 및 레이블 추가
            
            //            cell.addressLabel.text = "#1302-1992 Room X street,\nVancouver, BC, V6M1R2"
//            cell.addressLabel.text = self.address
//            //            cell.addressLabel.font = UIFont(name:"FiraSans-UltraLight", size: 4)
//            cell.addressLabel.font = UIFont.systemFont(ofSize: 16)
          
            cell.addressLabel.text = self.address
            cell.addressLabel.font = UIFont.systemFont(ofSize: 20)
            cell.addressLabel.textColor = .black
            
            cell.restAddress.text = self.restAddress
            cell.restAddress.font = UIFont.systemFont(ofSize: 15)
            cell.restAddress.textColor = .darkGray
            //여기까지 보셈 9/12
            cell.addressLabel.adjustsFontSizeToFitWidth = true
            cell.addressLabel.numberOfLines = 2
            cell.addressLabel.textColor = UIColor(rgb:0x464749)
            
            cell.profileImage.image = profileImage
            cell.profileImage.layer.cornerRadius = UIScreen.main.bounds.width/12
            cell.profileImage.layer.masksToBounds = true
            
            cell.profileNameLabel.text = author
            cell.profileNameLabel.font = UIFont(name:"FiraSans-Bold", size: 15)
            cell.profileNameLabel.adjustsFontSizeToFitWidth = true
            cell.profileNameLabel.textColor = UIColor(rgb:0x464749)
          
            
            //추가 8월 28일
//            var image:String?
//
//            switch rentType {
//
//            case "TakeOver":
//                image = "mainTakeover"
//            case "RoomRent" :
//                image = "list_roomrent"
//            default:
//                image = "mainShareBtn"
//            }
//
//            cell.typeIconImage.image = UIImage(named: image!)
            if verified == true {
                cell.thirdIconImage.image = UIImage(named: "list_verified")
            }
           
            cell.firstIconImage.image = UIImage(named: "\(rentType ?? "")_point")
            cell.secondIconImage.image = UIImage(named: "\(rentType ?? "")_point")
            cell.firstIconImage.tintColor = .black
            cell.secondIconImage.tintColor = .black
//            cell.newIconImage.image = UIImage(named: "list_new")
//            cell.typeIconImage.image = UIImage(named: "list_roomrent")
//            cell.verifiedIconImage.image = UIImage(named: "list_verified")
            // 여기까지 추가 및 변경
            cell.detailImage.image = UIImage(named: "detail_spec")
            
            cell.bedLabel.text = self.numBed
            //            cell.bedLabel.font = UIFont(name:"FiraSans-UltraLight",size: 3)
            cell.bedLabel.font = UIFont.systemFont(ofSize: 12)
            cell.bedLabel.textAlignment = .center
            cell.bedLabel.textColor = UIColor(rgb:0x464749)
            
            cell.bathLabel.text = self.numBath
            //            cell.bathLabel.font = UIFont(name:"FiraSans-UltraLight",size: 8)
            cell.bathLabel.font = UIFont.systemFont(ofSize: 12)
            cell.bathLabel.textColor = UIColor(rgb:0x464749)
            cell.bathLabel.textAlignment = .center
            
            cell.moveInDateLabel.text = self.moveInDate
            //            cell.moveInDateLabel.font = UIFont(name:"FiraSans-UltraLight",size: 8)
            cell.moveInDateLabel.font = UIFont.systemFont(ofSize: 12)
            cell.moveInDateLabel.textColor = UIColor(rgb:0x464749)
            cell.moveInDateLabel.textAlignment = .center
            
            cell.sqftLabel.text = self.size
            //            cell.sqftLabel.font = UIFont(name:"FiraSans-UltraLight",size: 30)
            cell.sqftLabel.font = UIFont.systemFont(ofSize: 12)
            cell.sqftLabel.textColor = UIColor(rgb:0x464749)
            cell.sqftLabel.textAlignment = .center
            
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: curcell.identifier, for: indexPath) as! BuildingTypeTableViewCell
            switch self.type {
            case "Condo":
                cell.buildingTypeImage.image = UIImage(named: "icon_condo")
            case "House":
                cell.buildingTypeImage.image = UIImage(named: "icon_house")
            default:
                cell.buildingTypeImage.image = UIImage(named: "icon_house")
            }
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: curcell.identifier, for: indexPath) as! AmenitiesTableViewCell
        cell.flag += [airCon, balcony, closet, dishWash, fridge, heater, cableTV, internet, bed]
        cell.flag += [tubPublic, toiletPublic, stove, microwave, dryerPublic, laundry, deskChair, hanger, parking]
            //            cell.list += ["icon_aircon", "icon_balcony", "icon_closet", "icon_dishwash", "icon_fridge", "icon_heater", "icon_kitchen", "icon_laundry", "icon_parking", "icon_tub", "icon_tv", "icon_wifi"]
            return cell
            
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: curcell.identifier, for: indexPath) as! RulesTableViewCell
            cell.flag += [dog, cat, smoking, drug, party, manonly, womanonly, both]
            return cell
            
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: curcell.identifier, for: indexPath) as! DescriptionTableViewCell
            cell.descriptionLabel.text = self.detailDescription
            cell.descriptionLabel.font = UIFont.systemFont(ofSize: 15)
            
            if readButtonTitle != "Read More" {
                cell.descriptionLabel.lineBreakMode = .byWordWrapping
                cell.descriptionLabel.numberOfLines = 0
                cell.descriptionLabel.sizeToFit()
                print(cell.descriptionLabel.calculateMaxLines())
            }
            numOfTextLines = cell.descriptionLabel.calculateMaxLines()
            
            cell.readMoreButton.tag = curcell.cell
            cell.readMoreButton.addTarget(self, action: #selector(readMoreBtn), for: .touchUpInside)
            cell.readMoreButton.setTitle(readButtonTitle,for: .normal)
            cell.readMoreButton.tintColor = .gray
            cell.readMoreButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            cell.readMoreButton.adjustsImageWhenHighlighted = false
            return cell
            
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: curcell.identifier, for: indexPath) as! TransportationTableViewCell
            cell.stationNameLabel.text = stationName
            cell.stationNameLabel.font = UIFont.systemFont(ofSize: 17)
            cell.stationNameLabel.textColor = UIColor(rgb:0x464749)
            cell.stationNameLabel.textAlignment = .left
            
            cell.distanceLabel.text = stationDistance
            cell.distanceLabel.font = UIFont.systemFont(ofSize: 17)
            cell.distanceLabel.textColor = UIColor(rgb:0x464749)
            cell.distanceLabel.textAlignment = .right
            return cell
            
        default:
           
            let cell = tableView.dequeueReusableCell(withIdentifier: curcell.identifier, for: indexPath) as! MapTableViewCell
            
            let locationCoordinate = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
            
            let region = MKCoordinateRegion(center: locationCoordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            cell.mapView.setRegion(region, animated: false)
            let anno = MKPointAnnotation()
            anno.coordinate = locationCoordinate
            cell.mapView.addAnnotation(anno)
            
            let mapViewTap = UITapGestureRecognizer(target: self, action: #selector(mapViewTapped))
            mapViewTap.numberOfTapsRequired = 1
            cell.mapView.addGestureRecognizer(mapViewTap)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellArray[indexPath.section].height
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return cellArray[section].title
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = UIColor.white
        //        let header = view as! UITableViewHeaderFooterView
        //        header.textLabel?.textColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            let height:CGFloat = 0.0
            return height
        }
        let height:CGFloat = 55.0
        return height
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL, completion: @escaping (_ success: Bool) -> Void) {
        print("Download Started")
        //        group.enter()
        let queue = DispatchQueue(label: "imageLoad", attributes: .concurrent)
        
        queue.sync {
            getData(from: url) { data, response, error in
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
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    //map zoomin //맵수정
    @objc func mapViewTapped() {
        performSegue(withIdentifier: "editmapview", sender: nil)
    }
    
    @objc func addTapped(sender: UIButton) {
        //        self.tabBarController?.tabBar.isHidden = false
        //        self.navigationController?.popViewController(animated: true)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        print("1")
        if !sender.isSelected {
            print("2 selected")
            // Save to CoreData
            let entity = NSEntityDescription.entity(forEntityName: "Favorites", in: context)
            let newListing = NSManagedObject(entity: entity!, insertInto: context)
            
            newListing.setValue(property?.address.address, forKey: "addressAddress")
            newListing.setValue(property?.address.city, forKey: "addressCity")
            newListing.setValue(property?.address.postalCode, forKey: "addressPostalCode")
            newListing.setValue(property?.address.province, forKey: "addressProvince")
            newListing.setValue(property?.address.latitude, forKey: "addressLatitude")
            newListing.setValue(property?.address.longitude, forKey: "addressLongitude")
            newListing.setValue(property?.constructionDate, forKey: "constructionDate")
            newListing.setValue(property?.furnished, forKey: "furnished")
            newListing.setValue(property?.hostEmail, forKey: "hostEmail")
            newListing.setValue(property?.hostPhone, forKey: "hostPhone")
            newListing.setValue(property?.numBath, forKey: "numBath")
            newListing.setValue(property?.numBed, forKey: "numBed")
            newListing.setValue(property?.description, forKey: "pDescription")
            newListing.setValue(property?.price, forKey: "price")
            newListing.setValue(property?.requiredTerm, forKey: "requiredTerm")
            newListing.setValue(property?.size, forKey: "size")
            newListing.setValue(property?.new, forKey: "new")
            newListing.setValue(property?.type, forKey: "type")
            newListing.setValue(property?.verified, forKey: "verified")
            
            newListing.setValue(property?.dogs, forKey: "dogs")
            newListing.setValue(property?.cats, forKey: "cats")
            newListing.setValue(property?.smoking, forKey: "smoking")
            newListing.setValue(property?.drug, forKey: "drug")
            
            newListing.setValue(property?.internet, forKey: "internet")
            newListing.setValue(property?.cableTV, forKey: "cableTV")
            newListing.setValue(property?.fridge, forKey: "fridge")
//            newListing.setValue(property?.kitchen, forKey: "kitchen")
            newListing.setValue(property?.airCon, forKey: "airCon")
            newListing.setValue(property?.heater, forKey: "heater")
            newListing.setValue(property?.dishWash, forKey: "dishWash")
            newListing.setValue(property?.laundry, forKey: "laundry")
            newListing.setValue(property?.balcony, forKey: "balcony")
            newListing.setValue(property?.closet, forKey: "closet")
            newListing.setValue(property?.parking, forKey: "parking")
            newListing.setValue(property?.tub, forKey: "tub")
            //추가 및 변경
            newListing.setValue(property?.bed, forKey: "bed")
            newListing.setValue(property?.tubPublic, forKey: "tubPublic")
            newListing.setValue(property?.toiletPublic, forKey: "toiletPublic")
            newListing.setValue(property?.stove, forKey: "stove")
            newListing.setValue(property?.microwave, forKey: "microwave")
            newListing.setValue(property?.dryerPublic, forKey: "dryerPublic")
            newListing.setValue(property?.deskChair, forKey: "deskChair")
            newListing.setValue(property?.hanger, forKey: "hanger")
            
            do {
                // make sure to save the addition
                try context.save()
            } catch {
                print("Failed saving")
            }
            // set selected true
            sender.isSelected = true
            print("isSelected")
            
        } else {
            print("2 not selected")
            // Delete from CoreData
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
            request.returnsObjectsAsFaults = false
            do {
                print("deleting 1 ")
                let resultListings = try context.fetch(request)
                for listing in resultListings as! [NSManagedObject]{
                    
                    let searchAddress = listing.value(forKey: "addressAddress") as! String
                    let searchCity = listing.value(forKey: "addressCity") as! String
                    let searchProvince = listing.value(forKey: "addressProvince") as! String
                    let searchPostalCode = listing.value(forKey: "addressPostalCode") as! String
                    
                    if (searchAddress == property?.address.address &&
                        searchCity == property?.address.city &&
                        searchProvince == property?.address.province &&
                        searchPostalCode == property?.address.postalCode){
                        
                        context.delete(listing)
                        
                        do {
                            // make sure to save the deletion
                            try context.save()
                        } catch {
                            print("Save Error")
                        }
                        // set selcted false
                        sender.isSelected = false
                        print("isNotSelected")
                        return
                    }
                }
            } catch {
                print("Failed")
            }
        }
    }
    
    @objc func readMoreBtn(sender: UIButton, int: Int) {
        
        if sender.isSelected {
            // set deselected
            readButtonTitle = "Read More"
            cellArray[sender.tag-1].height = 75
            numOfTextLines = 0
            sender.isSelected = false
        } else {
            // set selected
            readButtonTitle = "Read Less"
            cellArray[sender.tag-1].height = CGFloat(numOfTextLines*17 + 75)
            sender.isSelected = true
        }
        tableView.reloadData()
    }
    
    func deleteData() {
        
            let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete your property?", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                print("delete ready")
                
                self.deleteCollectionProperty()
                print("present alertXContorller+_+_+_+_+__+_+_+__+_++")
                print("alertController====================")
               
                let alertController = UIAlertController(title: "Completed!", message:
                    "Successfully Deleted!", preferredStyle: .alert)
                //                self.present(alertController, animated: true, completion: nil)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                    self.navigationController?.popToRootViewController(animated: true)
                }))
                print("alertController====================")
                self.present(alertController, animated: true, completion: nil)
            }))
        
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                    return
            }))
            print("present alert_+_+_+_+_+__+_+_+__+_++")
            present(alert, animated: true, completion: nil)
    }
    
    private func deleteCollectionProperty() {
        var documentID = ""
        documentID = property!.documentID
        print(documentID)
        let db = Firestore.firestore()
        db.collection("NorthAmerica").document("Canada").collection("BC").document(documentID).delete() { err in if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        
        let storage = Storage.storage()
        
        for i in 0...property!.imageURL.count-1 {
            print("=======================")
            print(documentID)
            print("\(i)")
            let storagePath = "gs://roomx-5f041.appspot.com/" + documentID + "/"
            let reference = storage.reference(forURL: storagePath).child("\(i)")
            reference.delete { error in
                if let error = error {
                    print("Error while deleteing Storage : \(error)")
                } else {
                    print("delete Storage successfully")
                }
            }
            print("=======================")
        }
    }
    func backToManage() {
        dismiss(animated: true, completion: nil)
    }
}
