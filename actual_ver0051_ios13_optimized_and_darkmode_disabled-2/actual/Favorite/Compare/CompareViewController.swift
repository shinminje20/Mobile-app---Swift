//
//  CompareViewController.swift
//  actual
//
//  Created by Sukkwon On on 2019-08-06.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit
import MapKit

class CompareViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var cellArray = [cellData]()
    var rowsInSection = [1, 1, 6, 3, 10, 1, 1]
    //9/13 변경 transSubTitles
    var transSubTitles = ["", "", ""]
    //    var detailSubTitles = ["Price", "", "Bedroom", "", "Bathroom"]
    var detailSubTitles = ["Price", "", "", "", ""]
    var detailTitleImages = ["", "", "bed_room", "", "bath_image"]
    //    var specSubTitles = ["Verification", "", "Condition", "", "Room Size", "", "Room Type", "", "Move-in Date"]
    var specSubTitles = ["Verification", "", "Condition", "", "", "", "", "", ""]
    var specTitleImages = ["", "", "", "", "room_size", "", "room_type", "", "move_in"]
    
    var property1 : Property?
    var property2 : Property?
    var ud : userDestination?
    
    var price1: String!
    var price2: String!
    var numBed1: String!
    var numBed2: String!
    var numBath1: String!
    var numBath2: String!
    var verified1: String!
    var verified2: String!
    var condition1: String!
    var condition2: String!
    var size1: String!
    var size2: String!
    var type1: String!
    var type2: String!
    var moveInDate1: String!
    var moveInDate2: String!
    var latitude1:Double!
    var latitude2:Double!
    var longitude1:Double!
    var longitude2:Double!
    var image1:UIImage!
    var image2:UIImage!

    var destinationInitial:String = ""
    var destinationLatitude : Double = 0.0
    var destinationLongitude : Double = 0.0
    
    @objc func terminateCompare(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("123412341234================================12345========================================")
        print(property1!.party)
        print(property1!.manonly)
        print(property1!.womanonly)
        print(property1!.both)
        print(property2!.party)
        print(property2!.manonly)
        print(property2!.womanonly)
        print(property2!.both)
        print("123412341234==================================12345======================================")
        
        let longTitleLabel = UILabel()
        longTitleLabel.text = "C O M P A R E"
        longTitleLabel.font = UIFont(name:"FiraSans-Bold",size:20)
        longTitleLabel.textColor =  UIColor(rgb: 0x8389BA)
        longTitleLabel.sizeToFit()
        
        self.navigationItem.titleView = longTitleLabel
        
        if let property1 = property1 {
            self.price1 = "$ \(property1.price)"
            self.numBed1 = "\(property1.numBed)"
            self.numBath1 = "\(property1.numBath)"
            self.verified1 = (property1.verified) ? "O" : "X"
            self.condition1 = property1.condition
            self.size1 = "\(property1.size)"
            self.type1 = property1.type
            self.moveInDate1 = property1.moveInDate
            self.latitude1 = property1.address.latitude
            self.longitude1 = property1.address.longitude
            self.image1 = property1.images[0]
        }
        if let property2 = property2 {
            self.price2 = "$ \(property2.price)"
            self.numBed2 = "\(property2.numBed)"
            self.numBath2 = "\(property2.numBath)"
            self.verified2 = (property2.verified) ? "O" : "X"
            self.condition2 = property2.condition
            self.size2 = "\(property2.size)"
            self.type2 = property2.type
            self.moveInDate2 = property2.moveInDate
            self.latitude2 = property2.address.latitude
            self.longitude2 = property2.address.longitude
            self.image2 = property2.images[0]
        }
        if let ud = ud {
            self.destinationInitial = ud.name
            self.destinationLatitude = ud.latitude
            self.destinationLongitude = ud.longitude
        }
        
        let closeImage  = UIImage(named: "icon_close")!
        let closeButton = UIBarButtonItem(image: closeImage, style: .plain, target: self, action: #selector(terminateCompare))
        closeButton.tintColor = UIColor(rgb: 0x8389BA)
        navigationItem.rightBarButtonItem = closeButton
        
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.frame = .zero
        let dummyViewHeight = CGFloat(45)
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: dummyViewHeight))
        self.tableView.contentInset = UIEdgeInsets(top: -dummyViewHeight, left: 0, bottom: 0, right: 0)
//        self.view.addSubview(tableView)

        cellArray = [
            cellData(cell : 1, title: "", height: 202/375*UIScreen.main.bounds.width, name: "ImageCompareTableViewCell", identifier: "imagecell"),
            cellData(cell : 2, title: "  Map-to-Destination", height: 310, name: "MapCompareTableViewCell", identifier: "mapcell"),
            cellData(cell : 3, title: "  Detail", height: 40, name: "DefaultCompareTableViewCell", identifier: "detailcell"),
            cellData(cell : 4, title: "  Transportation", height: 40, name: "DefaultCompareTableViewCell", identifier: "transcell"),
            cellData(cell : 5, title: "  Specification", height: 40, name: "DefaultCompareTableViewCell", identifier: "speccell"),
            cellData(cell : 6, title: "  Amenities", height: 700, name: "AmenitiesCompareTableViewCell", identifier: "amenitiescell"),
            cellData(cell : 7, title: "  Rules", height: 320, name: "RulesCompareTableViewCell", identifier: "rulescell")
//            cellData(cell: 5, title: "Amenities", height: 75, name: "RulesTableViewCell", identifier: "rulescell"),
//            cellData(cell : 6, title: "Rules", height: 250, name: "MapTableViewCell", identifier: "mapcell") //ORIGINAL HEIGHT = 170
        ]
        
        for cell in cellArray {
            let nibName = UINib(nibName: cell.name, bundle: nil)
            tableView.register(nibName, forCellReuseIdentifier: cell.identifier)
        }
        
        tableView.allowsSelection = false
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowsInSection[section];
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let curcell:cellData = cellArray[indexPath.section]
        switch curcell.cell {
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: curcell.identifier, for: indexPath) as! ImageCompareTableViewCell
            cell.imageView1.image = image1.imageWithBorder(width: 5, color: UIColor(rgb: 0x7EB2E0))
            cell.imageView2.image = image2.imageWithBorder(width: 5, color: UIColor(rgb: 0xE59C6F))
            cell.imageView1.layer.cornerRadius = 11
            cell.imageView2.layer.cornerRadius = 11
            //추가 9/11
            cell.numOne.image = UIImage(named: "numOne")
            cell.numTwo.image = UIImage(named: "numTwo")
            //여기까지 추가
            cell.imageView1.clipsToBounds = true
            cell.imageView2.clipsToBounds = true
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: curcell.identifier, for: indexPath) as! MapCompareTableViewCell
            
            let sourceLocation1 = CLLocationCoordinate2D(latitude: latitude1, longitude: longitude1)
            let sourceLocation2 = CLLocationCoordinate2D(latitude: latitude2, longitude: longitude2)
            let destinationLocation = CLLocationCoordinate2D(latitude: destinationLatitude, longitude: destinationLongitude)
            
            let sourcePin1 = customPin(pinTitle: "Home 1", pinSubTitle: "", location: sourceLocation1)
            let sourcePin2 = customPin(pinTitle: "Home 2", pinSubTitle: "", location: sourceLocation2)
            let destinationPin = customPin(pinTitle: destinationInitial, pinSubTitle: "Destination", location: destinationLocation)
            cell.mapView.addAnnotation(sourcePin1)
            cell.mapView.addAnnotation(sourcePin2)
            cell.mapView.addAnnotation(destinationPin)
            
            let sourcePlaceMark1 = MKPlacemark(coordinate: sourceLocation1)
            let sourcePlaceMark2 = MKPlacemark(coordinate: sourceLocation2)
            let destinationPlaceMark = MKPlacemark(coordinate: destinationLocation)
            
            let directionRequest1 = MKDirections.Request()
            directionRequest1.source = MKMapItem(placemark: sourcePlaceMark1)
            directionRequest1.destination = MKMapItem(placemark: destinationPlaceMark)
            directionRequest1.transportType = .automobile
            
            let directionRequest2 = MKDirections.Request()
            directionRequest2.source = MKMapItem(placemark: sourcePlaceMark2)
            directionRequest2.destination = MKMapItem(placemark: destinationPlaceMark)
            directionRequest2.transportType = .automobile
            
            let directions1 = MKDirections(request: directionRequest1)
            directions1.calculate{ (response, error) in
                guard let directionResponse = response else {
                    if let error = error {
                        print("we have error getting directions==\(error.localizedDescription)")
                    }
                    return
                }
                
                let route = directionResponse.routes[0]
                print("===========================================================")
                print(self.stringFromTimeInterval(interval: route.expectedTravelTime))
                print("===========================================================")
                cell.p1Label.text = self.stringFromTimeInterval(interval: route.expectedTravelTime) as String
                cell.backgroundColor = UIColor(rgb: 0xf5f5f5)
                cell.p1Label.font = UIFont(name:"FiraSans", size: 15)
                cell.p1Label.textAlignment = .center
                cell.p1Label.textColor = UIColor(rgb:0x464749)
                cell.mapView.addOverlay(route.polyline, level: .aboveRoads)
                
//                let rect = route.polyline.boundingMapRect
//                cell.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
                
                let directions2 = MKDirections(request: directionRequest2)
                directions2.calculate{ (response, error) in
                    guard let directionResponse = response else {
                        if let error = error {
                            print("we have error getting directions==\(error.localizedDescription)")
                        }
                        return
                    }
                    
                    let route = directionResponse.routes[0]
                    print("===========================================================")
                    print(self.stringFromTimeInterval(interval: route.expectedTravelTime))
                    print("===========================================================")
                    cell.p2Label.text = self.stringFromTimeInterval(interval: route.expectedTravelTime) as String
                    cell.p2Label.font = UIFont(name:"FiraSans", size: 15)
                    cell.p2Label.textAlignment = .center
                    cell.p2Label.textColor = UIColor(rgb:0x464749)
                    cell.mapView.addOverlay(route.polyline, level: .aboveRoads)
                    
                    cell.carImage.image = UIImage(named: "icon_Car")
//                    cell.carLabel.text = "Car"
//                    cell.carLabel.textAlignment = .center
//                    cell.carLabel.textColor = UIColor(rgb:0x464749)
//                    cell.carLabel.font = UIFont(name:"FiraSans", size: 15)
//                    let rect = route.polyline.boundingMapRect
//                    cell.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
                    
                    cell.mapView.fitAll()
                }
            }
            
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: curcell.identifier, for: indexPath) as! DefaultCompareTableViewCell
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = .white
                
                if(detailTitleImages[indexPath.row] == "") {
                    cell.centerLabel.text = detailSubTitles[indexPath.row]
                } else {
                    cell.centerLabel.addTextWithImage(text: detailSubTitles[indexPath.row], image: UIImage(named: detailTitleImages[indexPath.row])!, imageBehindText: false, keepPreviousText: false)
                }
                
                cell.centerLabel.font = UIFont(name:"FiraSans", size: 30)
                cell.centerLabel.textAlignment = .center
                cell.centerLabel.textColor = UIColor(rgb:0x464749)
                cell.p1Label.text = ""
                cell.p2Label.text = ""
            }
            else {
                switch indexPath.row {
                case 1:
                    cell.backgroundColor = UIColor(rgb: 0xf5f5f5)
                    cell.p1Label.text = self.price1
                    cell.p1Label.font = UIFont(name:"FiraSans", size: 15)
                    cell.p1Label.textAlignment = .center
                    cell.p1Label.textColor = UIColor(rgb:0x464749)
                    cell.p2Label.text = self.price2
                    cell.p2Label.font = UIFont(name:"FiraSans", size: 15)
                    cell.p2Label.textAlignment = .center
                    cell.p2Label.textColor = UIColor(rgb:0x464749)
                    cell.centerLabel.text = ""
                case 3:
                    cell.backgroundColor = UIColor(rgb: 0xf5f5f5)
                    cell.p1Label.text = self.numBed1
                    cell.p1Label.font = UIFont(name:"FiraSans", size: 15)
                    cell.p1Label.textAlignment = .center
                    cell.p1Label.textColor = UIColor(rgb:0x464749)
                    cell.p2Label.text = self.numBed2
                    cell.p2Label.font = UIFont(name:"FiraSans", size: 15)
                    cell.p2Label.textAlignment = .center
                    cell.p2Label.textColor = UIColor(rgb:0x464749)
                    cell.centerLabel.text = ""
                case 5:
                    cell.backgroundColor = UIColor(rgb: 0xf5f5f5)
                    cell.p1Label.text = self.numBath1
                    cell.p1Label.font = UIFont(name:"FiraSans", size: 15)
                    cell.p1Label.textAlignment = .center
                    cell.p1Label.textColor = UIColor(rgb:0x464749)
                    cell.p2Label.text = self.numBath2
                    cell.p2Label.font = UIFont(name:"FiraSans", size: 15)
                    cell.p2Label.textAlignment = .center
                    cell.p2Label.textColor = UIColor(rgb:0x464749)
                    cell.centerLabel.text = ""
                default:
                    break
                }
            }
            return cell

        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: curcell.identifier, for: indexPath) as! DefaultCompareTableViewCell
            if (indexPath.row % 2 == 0) && (indexPath.row != 2) {
                cell.backgroundColor = .white
//                cell.centerLabel.text = transSubTitles[indexPath.row]
//                cell.centerLabel.font = UIFont(name:"FiraSans", size: 30)
//                cell.centerLabel.textAlignment = .center
//                cell.centerLabel.textColor = UIColor(rgb:0x464749)
                //9/13 추가 및 변경
                cell.skytrainImage.image = UIImage(named: "icon_Skytrain")
                //여기까지
                cell.p1Label.text = ""
                cell.p2Label.text = "(by walk)"
                cell.p2Label.font = UIFont(name:"FiraSans", size: 30)
                cell.p2Label.textColor = .lightGray
            }
            else {
                switch indexPath.row {
                case 1:
                    cell.backgroundColor = UIColor(rgb: 0xf5f5f5)
                    //9/13 추가
                    cell.skytrainImage.image = .none
                    //여기까지
                    if(property1?.transportation.placeName == ""){
                        cell.p1Label.text = "N/A"
                    } else {
                        cell.p1Label.text = property1?.transportation.placeName
                    }
                    cell.p1Label.font = UIFont(name:"FiraSans", size: 15)
                    cell.p1Label.textAlignment = .center
                    cell.p1Label.textColor = UIColor(rgb:0x464749)
                    cell.p1Label.adjustsFontSizeToFitWidth = true
                    if(property2?.transportation.placeName == ""){
                        cell.p2Label.text = "N/A"
                    } else {
                        cell.p2Label.text = property2?.transportation.placeName
                    }
                    cell.p2Label.font = UIFont(name:"FiraSans", size: 15)
                    cell.p2Label.textAlignment = .center
                    cell.p2Label.textColor = UIColor(rgb:0x464749)
                    cell.p2Label.adjustsFontSizeToFitWidth = true
                    cell.centerLabel.text = ""
                case 2:
                    //9/13 추가
                    cell.skytrainImage.image = .none
                    //여기까지
                    cell.backgroundColor = .white
                    if(property1?.transportation.placeName == ""){
                        cell.p1Label.text = "N/A"
                    } else {
                        cell.p1Label.text = property1?.transportation.displayedTime
                    }
                    cell.p1Label.font = UIFont(name:"FiraSans", size: 15)
                    cell.p1Label.textAlignment = .center
                    cell.p1Label.textColor = UIColor(rgb:0x464749)
                    if(property2?.transportation.placeName == ""){
                        cell.p2Label.text = "N/A"
                    } else {
                        cell.p2Label.text = property2?.transportation.displayedTime
                    }
                    cell.p2Label.font = UIFont(name:"FiraSans", size: 15)
                    cell.p2Label.textAlignment = .center
                    cell.p2Label.textColor = UIColor(rgb:0x464749)
                    cell.centerLabel.text = ""
                default:
                    break
                }
            }
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: curcell.identifier, for: indexPath) as! DefaultCompareTableViewCell
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = .white
                if(specTitleImages[indexPath.row] == "") {
                    cell.centerLabel.text = specSubTitles[indexPath.row]
                } else {
                    cell.centerLabel.addTextWithImage(text: specSubTitles[indexPath.row], image: UIImage(named: specTitleImages[indexPath.row])!, imageBehindText: false, keepPreviousText: false)
                }
                cell.centerLabel.font = UIFont(name:"FiraSans", size: 30)
                cell.centerLabel.textAlignment = .center
                cell.centerLabel.textColor = UIColor(rgb:0x464749)
                cell.p1Label.text = ""
                cell.p2Label.text = ""
            }
            else {
                switch indexPath.row {
                case 1:
                    cell.backgroundColor = UIColor(rgb: 0xf5f5f5)
                    cell.p1Label.text = self.verified1
                    cell.p1Label.font = UIFont(name:"FiraSans", size: 15)
                    cell.p1Label.textAlignment = .center
                    cell.p1Label.textColor = UIColor(rgb:0x464749)
                    cell.p2Label.text = self.verified2
                    cell.p2Label.font = UIFont(name:"FiraSans", size: 15)
                    cell.p2Label.textAlignment = .center
                    cell.p2Label.textColor = UIColor(rgb:0x464749)
                    cell.centerLabel.text = ""
                case 3:
                    cell.backgroundColor = UIColor(rgb: 0xf5f5f5)
                    
                    //9/13 추가 및변경
                    
                    var imageOne = "\(self.condition1 ?? "")_point"
                    var imageTwo = "\(self.condition2 ?? "")_point"
                    if self.condition1 == "None" {
                        imageOne = "agent_point"
                    }
                    if self.condition2 == "None" {
                        imageTwo = "agent_point"
                    }
                    let image1 = UIImage(named: imageOne)
                    let image2 = UIImage(named: imageTwo)
//                    switch self.condition1 {
                    
//                    case "TakeOver":
//                        image = "mainTakeover"
//                    case "RoomRent" :
//                        image = "list_roomrent"
//                    default:
//                        image = "mainShareBtn"
//                    }
//
//                    switch self.condition2 {
//
//                    case "TakeOver":
//                        image = "mainTakeover"
//                    case "RoomRent" :
//                        image = "list_roomrent"
//                    default:
//                        image = "mainShareBtn"
//                    }
                    //9/13 image1 , image 2 잘 때려박으셈
                    cell.p1Label.addTextWithImage(text: "", image: image1!, imageBehindText: false, keepPreviousText: false)
                    cell.p1Label.font = UIFont(name:"FiraSans", size: 15)
                    cell.p1Label.textAlignment = .center
                    cell.p1Label.textColor = UIColor(rgb:0x464749)
                    cell.p2Label.addTextWithImage(text: "", image: image2!, imageBehindText: false, keepPreviousText: false)
                    cell.p2Label.font = UIFont(name:"FiraSans", size: 15)
                    cell.p2Label.textAlignment = .center
                    cell.p2Label.textColor = UIColor(rgb:0x464749)
                    cell.centerLabel.text = ""
                case 5:
                    cell.backgroundColor = UIColor(rgb: 0xf5f5f5)
                    cell.p1Label.text = self.size1
                    cell.p1Label.font = UIFont(name:"FiraSans", size: 15)
                    cell.p1Label.textAlignment = .center
                    cell.p1Label.textColor = UIColor(rgb:0x464749)
                    cell.p2Label.text = self.size2
                    cell.p2Label.font = UIFont(name:"FiraSans", size: 15)
                    cell.p2Label.textAlignment = .center
                    cell.p2Label.textColor = UIColor(rgb:0x464749)
                    cell.centerLabel.text = ""
                case 7:
                    cell.backgroundColor = UIColor(rgb: 0xf5f5f5)
                    cell.p1Label.text = self.type1
                    cell.p1Label.font = UIFont(name:"FiraSans", size: 15)
                    cell.p1Label.textAlignment = .center
                    cell.p1Label.textColor = UIColor(rgb:0x464749)
                    cell.p2Label.text = self.type2
                    cell.p2Label.font = UIFont(name:"FiraSans", size: 15)
                    cell.p2Label.textAlignment = .center
                    cell.p2Label.textColor = UIColor(rgb:0x464749)
                    cell.centerLabel.text = ""
                case 9:
                    cell.backgroundColor = UIColor(rgb: 0xf5f5f5)
                    cell.p1Label.text = self.moveInDate1
                    cell.p1Label.font = UIFont(name:"FiraSans", size: 15)
                    cell.p1Label.textAlignment = .center
                    cell.p1Label.textColor = UIColor(rgb:0x464749)
                    cell.p1Label.adjustsFontSizeToFitWidth = true
                    cell.p2Label.text = self.moveInDate2
                    cell.p2Label.font = UIFont(name:"FiraSans", size: 15)
                    cell.p2Label.textAlignment = .center
                    cell.p2Label.textColor = UIColor(rgb:0x464749)
                    cell.p2Label.adjustsFontSizeToFitWidth = true
                    cell.centerLabel.text = ""
                default:
                    break
                }
            }
            return cell
            //추가 및 변경 해야되는데 어케함?
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: curcell.identifier, for: indexPath) as! AmenitiesCompareTableViewCell
            cell.flag1 += [property1!.airCon, property1!.balcony, property1!.closet, property1!.dishWash, property1!.fridge, property1!.heater, property1!.laundry, property1!.parking, property1!.tub, property1!.cableTV, property1!.internet, property1!.bed, property1!.toiletPublic, property1!.stove, property1!.microwave, property1!.dryerPublic, property1!.deskChair, property1!.hanger]
            cell.flag2 += [property2!.airCon, property2!.balcony, property2!.closet, property2!.dishWash, property2!.fridge, property2!.heater, property2!.laundry, property2!.parking, property2!.tub, property2!.cableTV, property2!.internet, property2!.bed, property2!.toiletPublic, property2!.stove, property2!.microwave, property2!.dryerPublic, property2!.deskChair, property2!.hanger]
            return cell
        case 7:
            let cell = tableView.dequeueReusableCell(withIdentifier: curcell.identifier, for: indexPath) as! RulesCompareTableViewCell
            cell.flag1 += [property1!.dogs, property1!.cats, property1!.smoking, property1!.drug, property1!.party, property1!.manonly, property1!.womanonly, property1!.both]
            cell.flag2 += [property2!.dogs, property2!.cats, property2!.smoking, property2!.drug, property2!.party, property2!.manonly, property2!.womanonly, property2!.both]
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: curcell.identifier, for: indexPath) as! DefaultCompareTableViewCell
            return cell
        }
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellArray[indexPath.section].height
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = cellArray[section].title
        label.font = UIFont(name:"FiraSans-Bold",size:20)
        return label
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return cellArray[section].title
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            let height:CGFloat = 0.0
            return height
        }
        let height:CGFloat = 45.0
        return height
    }

    
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
//        view.tintColor = UIColor.white
//        
//    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> NSString {
        
        let ti = NSInteger(interval)
        
        // for milisecond
        //let ms = Int((interval.truncatingRemainder(dividingBy: 1)) * 1000)
        
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        
        if hours == 0
        {
            return NSString(format: "%d mins",minutes)
        }
        
        return NSString(format: "%dh %dmins",hours,minutes)
        
        // for milisecond
        //return NSString(format: "%0.2d:%0.2d:%0.2d.%0.3d",hours,minutes,seconds,ms)
    }
}

class customPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(pinTitle:String, pinSubTitle:String, location: CLLocationCoordinate2D) {
        self.title = pinTitle
        self.subtitle = pinSubTitle
        self.coordinate = location
    }
}

extension UIImage {
    func imageWithBorder(width: CGFloat, color: UIColor) -> UIImage? {
        let square = CGSize(width: min(size.width, size.height) + width * 2, height: min(size.width, size.height) + width * 2)
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: square))
        imageView.contentMode = .center
        imageView.image = self
        imageView.layer.borderWidth = width
        imageView.layer.borderColor = color.cgColor
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}

extension UILabel {
    /**
     This function adding image with text on label.
     
     - parameter text: The text to add
     - parameter image: The image to add
     - parameter imageBehindText: A boolean value that indicate if the imaga is behind text or not
     - parameter keepPreviousText: A boolean value that indicate if the function keep the actual text or not
     */
    func addTextWithImage(text: String, image: UIImage, imageBehindText: Bool, keepPreviousText: Bool) {
        let lAttachment = NSTextAttachment()
        lAttachment.image = image
        
        // 1pt = 1.32px
        let lFontSize = round(self.font.pointSize * 1.32)
        let lRatio = image.size.width / image.size.height
        
        lAttachment.bounds = CGRect(x: 0, y: ((self.font.capHeight - lFontSize) / 2).rounded(), width: lRatio * lFontSize, height: lFontSize)
        
        let lAttachmentString = NSAttributedString(attachment: lAttachment)
        
        if imageBehindText {
            let lStrLabelText: NSMutableAttributedString
            
            if keepPreviousText, let lCurrentAttributedString = self.attributedText {
                lStrLabelText = NSMutableAttributedString(attributedString: lCurrentAttributedString)
                lStrLabelText.append(NSMutableAttributedString(string: text))
            } else {
                lStrLabelText = NSMutableAttributedString(string: text)
            }
            
            lStrLabelText.append(lAttachmentString)
            self.attributedText = lStrLabelText
        } else {
            let lStrLabelText: NSMutableAttributedString
            
            if keepPreviousText, let lCurrentAttributedString = self.attributedText {
                lStrLabelText = NSMutableAttributedString(attributedString: lCurrentAttributedString)
                lStrLabelText.append(NSMutableAttributedString(attributedString: lAttachmentString))
                lStrLabelText.append(NSMutableAttributedString(string: text))
            } else {
                lStrLabelText = NSMutableAttributedString(attributedString: lAttachmentString)
                lStrLabelText.append(NSMutableAttributedString(string: text))
            }
            
            self.attributedText = lStrLabelText
        }
    }
    
    func removeImage() {
        let text = self.text
        self.attributedText = nil
        self.text = text
    }
}
