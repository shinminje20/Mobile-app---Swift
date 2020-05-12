//
//  DetailedListingViewController.swift
//  actual
//
//  Created by Sukkwon On on 2019-04-01.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import MapKit
import ImageSlideshow
import MessageUI
import Firebase

class DetailedListingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {
    let storageRef = Storage.storage().reference()
    
    @IBOutlet weak var tableView: UITableView!
    var property : Property?
    let firstcellheight:CGFloat = 129.5
    let secondcellheight:CGFloat = 137
    @IBOutlet weak var slideshow:ImageSlideshow!
    var cellArray = [cellData]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var contactButton: UIButton!
    
    var readButtonTitle:String = "Read More"
    var numOfTextLines:Int = 0
    
    private let tableHeaderViewHeight: CGFloat = UIScreen.main.bounds.height*0.75
    private let tableHeaderViewCutaway: CGFloat = 40.0
    var headerMaskLayer: CAShapeLayer!
    
    var rentType:String!
    var verified:Bool!
    // property member variables
    var author:String!
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
    //추가
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
    
    @IBAction func contactButtonIsTapped(_ sender: Any) {
        print("success")
        // Send email
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        
        sendEmail()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("======OPTIONAL CHECK===============1")
        
        FROMFILTERING = false
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = .zero
        tableView.allowsSelection = false
//        let dummyViewHeight = CGFloat(55)
//        self.tableView.contentInset = UIEdgeInsets(top: -dummyViewHeight, left: 0, bottom: 0, right: 0)
        self.view.addSubview(tableView)
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.color = UIColor(rgb: 0x8389BA)
        self.view.addSubview(activityIndicator)
        
        profileImage = UIImage(named: "profile_default")
        
        for url in property!.imageURL {
            imageURLs.append(url)
        }
        print("======OPTIONAL CHECK===============2")

        // =====================================================================
        // Save Point
        // =====================================================================
//        let dummyViewHeight = CGFloat(40)
//        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: dummyViewHeight))
//        self.tableView.contentInset = UIEdgeInsets(top: -dummyViewHeight, left: 0, bottom: 0, right: 0)
        
        contactButton.backgroundColor = UIColor(rgb: 0x8389BA)
        contactButton.setTitle("Contact Landlord",for: .normal)
        contactButton.tintColor = .white
        contactButton.titleLabel?.font = UIFont(name:"FiraSans-Bold", size: 18)
        print("======OPTIONAL CHECK===============3")
        // =====================================================================
        // Bar Button Items
        // =====================================================================
        //create a new button
        let button = UIButton(type: .custom)
        var rightBarButtonImage = UIImage(named: "icon_favouriteOff")
        rightBarButtonImage = rightBarButtonImage?.withRenderingMode(.alwaysOriginal)
        var rightBarButtonImageSelected = UIImage(named: "icon_favouriteOn")
        rightBarButtonImageSelected = rightBarButtonImageSelected?.withRenderingMode(.alwaysOriginal)
        //set image for button
        button.setImage(rightBarButtonImage, for: .normal)
        button.setImage(rightBarButtonImageSelected, for: .selected)
        //add function for button
        button.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        //set frame
        button.frame = CGRect(x: 0, y: 0, width: 53, height: 51)
        print("======OPTIONAL CHECK===============4")
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
                    let documentID = data.value(forKey: "documentID") as! String
                    
                    // if we find the correct listing, fill in the heart button
                    if (documentID == property.documentID){
                        button.isSelected = true
                    }
                }
            } catch{
                fatalError()
            }
            
            self.rentType = property.condition
            //추가 9/12일
            self.verified = property.verified
            //여기까지
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
            self.size = "\(property.size) sqft"
            self.detailDescription = property.description
            self.type = property.type
            
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
            //추가
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
                        group.leave()
                    } else {
                        let image = UIImage(data: data!)
                        self.profileImage = image!
                        self.activityIndicator.stopAnimating()
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
            print("======OPTIONAL CHECK===============7")
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
        print("======OPTIONAL CHECK===============8")
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButton
        
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
        print("======OPTIONAL CHECK===============9")
        for cell in cellArray {
            let nibName = UINib(nibName: cell.name, bundle: nil)
            tableView.register(nibName, forCellReuseIdentifier: cell.identifier)
        }
    }
    
    @objc func didTap() {
        slideshow.presentFullScreenController(from: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare()")
        super.prepare(for: segue, sender: sender)
        
        //setting back button in navigation bar
        let backItem = UIBarButtonItem()
        backItem.title = ""
        backItem.tintColor = UIColor(rgb: 0x8389BA)
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == "DetailedMapViewController"{
            if segue.identifier == "DetailedMapViewController"{
                if segue.destination is DetailedMapViewController
                {
                    let locationCoordinate = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
                    let vc = segue.destination as? DetailedMapViewController
                    vc?.coordination = locationCoordinate
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return comments.count
        return 1 // ******* See upper code for future code *******
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let curcell:cellData = cellArray[indexPath.section]
        print("======OPTIONAL CHECK===============10")
        switch curcell.cell {
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: curcell.identifier, for: indexPath) as! ProfileTableViewCell
            cell.priceLabel.text = self.price
            cell.priceLabel.font = UIFont(name:"FiraSans-Bold", size: 25)
            cell.priceLabel.textColor = UIColor(rgb:0x464749)
            
            //9/12 색상 변경 및 레이블 추가
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
            
//            cell.newIconImage.image = UIImage(named: "list_new")
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
            
//            cell.typeIconImage.image = UIImage(named: image!)
            //            cell.verifiedIconImage.image = UIImage(named: "list_verified")
            
//            cell.verifiedIconImage.image = UIImage(named: "list_verified")
            
            //추가 했음
            if verified == true {
                cell.thirdIconImage.image = UIImage(named: "list_verified")
            }
            cell.firstIconImage.image = UIImage(named: "\(rentType ?? "")_point")
            cell.secondIconImage.image = UIImage(named: "\(rentType ?? "")_point")
            cell.firstIconImage.tintColor = .black
            cell.secondIconImage.tintColor = .black
            //여기까지 추가함 9/12일
            
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
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let context = appDelegate.persistentContainer.viewContext
            let requestListings = NSFetchRequest<NSFetchRequestResult>(entityName: "UserIntroduction")
            requestListings.returnsObjectsAsFaults = false
            
            print("*After Context Set")
            do{
                let results = try context.fetch(requestListings)
                print("* After fetching results")
                for data in results as! [NSManagedObject]{
                    // simply retrieve data from core data
                    let titleText:String = data.value(forKey: "title") as! String
                    let bodyText:String = data.value(forKey: "body") as! String
                    
                    let mail = MFMailComposeViewController()
                    mail.mailComposeDelegate = self
                    print(titleText)
                    print(bodyText)
                    mail.setToRecipients([hostEmail])
                    mail.setSubject(titleText)
                    mail.setMessageBody(bodyText, isHTML: true)
                    
                    present(mail, animated: true)
                    return
                }
                // simply retrieve data from core data
                let titleText:String = ""
                let bodyText:String = ""
                
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                print(titleText)
                print(bodyText)
                mail.setToRecipients([hostEmail])
                mail.setSubject(titleText)
                mail.setMessageBody(bodyText, isHTML: true)
                
                present(mail, animated: true)
                return
            } catch{
                fatalError()
            }
        } else {
            let alertController = UIAlertController(title: "Oops", message:
                "Mail service is not available.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            }))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
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
    
    //map zoomin
    @objc func mapViewTapped() {
        performSegue(withIdentifier: "DetailedMapViewController", sender: nil)
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
            
            newListing.setValue(property?.author, forKey: "author")
            newListing.setValue(property?.condition, forKey: "condition")
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
            newListing.setValue(property?.moveInDate, forKey: "moveInDate")
            
            newListing.setValue(property?.dogs, forKey: "dogs")
            newListing.setValue(property?.cats, forKey: "cats")
            newListing.setValue(property?.smoking, forKey: "smoking")
            newListing.setValue(property?.drug, forKey: "drug")
            //추가
            newListing.setValue(property?.party, forKey: "party")
            newListing.setValue(property?.manonly, forKey: "manonly")
            newListing.setValue(property?.womanonly, forKey: "womanonly")
            newListing.setValue(property?.both, forKey: "both")
            
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
            //추가 하아...
            newListing.setValue(property?.bed, forKey: "bed")
            newListing.setValue(property?.tubPublic, forKey: "tubPublic")
            newListing.setValue(property?.toiletPublic, forKey: "toiletPublic")
            newListing.setValue(property?.stove, forKey: "stove")
            newListing.setValue(property?.microwave, forKey: "microwave")
            newListing.setValue(property?.dryerPublic, forKey: "dryerPublic")
            newListing.setValue(property?.deskChair, forKey: "deskChair")
            newListing.setValue(property?.hanger, forKey: "hanger")
        
            newListing.setValue(property?.transportation.placeName, forKey: "transportationName")
            newListing.setValue(property?.transportation.displayedTime, forKey: "transportationTime")
            
            newListing.setValue(imageURLs, forKey: "imageurl")
            
            newListing.setValue(property?.documentID, forKey: "documentID")
            newListing.setValue(property?.uid, forKey: "uid")
            
//            newListing.setValue(property?.imageURL[0], forkey: "imageURL1")
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
                    
                    let documentID = listing.value(forKey: "documentID") as! String
                    
                    if (documentID == property?.documentID){
                        
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
    
    @objc func buttonAction(sender: UIButton) {
        print("dd")
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
}

extension UILabel {
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
}
