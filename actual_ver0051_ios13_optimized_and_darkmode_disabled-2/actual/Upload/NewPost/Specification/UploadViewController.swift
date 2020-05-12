//
//  UploadViewController.swift
//  actual
//
//  Created by Sukkwon On on 2019-08-13.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit
import MapKit

var buildingTypeMultiSelectionFlag = false

class UploadViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var progressBar: UIProgressView!
    var property:Property?
    //    var preparedData : uploadData?
    var count = 0
    
    @IBOutlet weak var nextBtn: UIButton!
//    var nextBtn:UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    let numbersOfRowsAtSection = [1, 1, 1, 1, 1, 1, 1, 1]
    let firstcellheight:CGFloat = 129.5
    let secondcellheight:CGFloat = 137
    var initBool = false
    
    var cellArray = [cellData]()
    
    private let tableHeaderViewHeight: CGFloat = UIScreen.main.bounds.height*0.75
    private let tableHeaderViewCutaway: CGFloat = 40.0
    var headerMaskLayer: CAShapeLayer!
    
    weak var cellDelegate: AmenityTableViewCell?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(count == 0 ) {
            progressBar.setProgress(0.4, animated: true)
            progressBar.trackTintColor = UIColor(rgb: 0xdedede)
            progressBar.tintColor = UIColor(rgb: 0x8389BA)
            progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 3.5)
            self.view.addSubview(progressBar)
            count = count + 1
        }
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = .zero
        self.view.addSubview(tableView)
        self.tableView.separatorStyle = .none
        
        PRICE = ""
        BUILDINGTYPES = [false, false]
        AMENITIES = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
        RULES = [false, false, false, false, false, false, false, false]
        NUMBED = ""
        NUMBATH = ""
        SIZEROOM = ""
        RENTTYPE = ""
//        let nextBtn : UIBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(toNext))
//        
//        self.navigationItem.rightBarButtonItem = nextBtn
//        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(rgb: 0x8389BA)
        
        buildingTypeMultiSelectionFlag = false
        
        // =====================================================================
        // Table Data Init
        // =====================================================================
        //SampleData
        
        cellArray = [
            cellData(cell : 1, title: " Select rent type", height: 40, name: "RentTypeTableViewCell", identifier: "typecell"),
            cellData(cell : 2, title: " Price per month", height: 80, name: "PriceUploadTableViewCell", identifier: "priceuploadcell"),
            cellData(cell : 3, title: " Select room type", height: 90, name: "BuildingTableViewCell", identifier: "buildingcell"),
            cellData(cell : 4, title: " Number of rooms", height: 80, name: "BedUploadTableViewCell", identifier: "bedcell"),
            cellData(cell : 5, title: " Number of washrooms", height: 80, name: "BathUploadTableViewCell", identifier: "bathcell"),
            cellData(cell : 6, title: " Total size of room (Optional)", height: 80, name: "SizeUploadTableViewCell", identifier: "sizeuploadcell"),
            cellData(cell : 7, title: " Select Amenities", height: 355, name: "AmenityTableViewCell", identifier: "amenitycell"),
            cellData(cell : 8, title: " Rules in your room", height: 150, name: "RuleTableViewCell", identifier: "rulecell")
        ]
        
        for cell in cellArray {
            let nibName = UINib(nibName: cell.name, bundle: nil)
            tableView.register(nibName, forCellReuseIdentifier: cell.identifier)
        }
        
        let longTitleLabel = UILabel()
        longTitleLabel.text = "D E T A I L S"
        longTitleLabel.font = UIFont(name:"FiraSans-Bold",size:20)
        longTitleLabel.textColor = UIColor(rgb: 0x8389BA)
        longTitleLabel.textAlignment = .center
        longTitleLabel.sizeToFit()
        
        self.navigationItem.titleView = longTitleLabel
        
        let dummyViewHeight = CGFloat(30)
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: dummyViewHeight))
        self.tableView.contentInset = UIEdgeInsets(top: -dummyViewHeight, left: 0, bottom: 0, right: 0)
        
        tableView.allowsSelection = false
        self.hideKeyboardWhenTappedAround()
        
        //추가
        
        let closeImage  = UIImage(named: "icon_close")!
        let closeButton = UIBarButtonItem(image: closeImage, style: .plain, target: self, action: #selector(toChoose))
        closeButton.tintColor = UIColor(rgb: 0x8389BA)
        navigationItem.rightBarButtonItem = closeButton
        
        nextBtn.backgroundColor = UIColor(rgb: 0x8389BA)
        nextBtn.setTitle("Next",for: .normal)
        nextBtn.tintColor = .white
        nextBtn.titleLabel?.font = UIFont(name:"FiraSans-Bold", size: 18)
        
        nextBtn.addTarget(self, action: #selector(toNext), for: .touchUpInside)
//
//        let screenHeight = UIScreen.main.bounds.height
//        let screenWidth = UIScreen.main.bounds.width
//        let navigationBarHeight = screenHeight * 88/812 //self.navigationController?.navigationBar.frame.height ?? 0
//        let tapBarHeight = self.tabBarController?.tabBar.frame.height ?? 0
//        let realScreenHeight = screenHeight - navigationBarHeight - tapBarHeight
        
//        let nextBtnFrame = CGRect(x: screenWidth * 297/375, y: navigationBarHeight + realScreenHeight * 600/724, width: screenWidth * 40/375, height: screenWidth * 40/375)
//        nextBtn = UIButton(frame: nextBtnFrame)
//        nextBtn.setImage(UIImage(named: "872"), for: .normal)
//        nextBtn.addTarget(self, action: #selector(toNext), for: .touchUpInside)
//        nextBtn.backgroundColor = UIColor(rgb: 0x8389BA)
//        nextBtn.layer.cornerRadius = 0.5 * nextBtn.bounds.size.width
//        nextBtn.clipsToBounds = true
////        nextBtn.isEnabled = false
//
//        nextBtn.layer.shadowColor = UIColor.black.cgColor
//        nextBtn.layer.masksToBounds = false
//        nextBtn.layer.shadowRadius = 3
//        nextBtn.layer.shadowOpacity = 1.0
//        nextBtn.layer.shadowOffset = CGSize(width: 2, height: 2)
        
//        self.view.addSubview(nextBtn)
        //여기까지 추가
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepasre()")
        super.prepare(for: segue, sender: sender)
        //setting back button in navigation bar
        let backItem = UIBarButtonItem()
        backItem.title = ""
        backItem.tintColor = UIColor(rgb: 0x8389BA)
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == "schedule"{
            if segue.destination is ScheduleViewController
            {
                property?.price = Int(PRICE) ?? 0
                
                for (index, element) in BUILDINGTYPES.enumerated() {
                    if element {
                        property!.type = (index==0) ? "Condo" : "House"
                    }
                }
                
                print("aaaa numbed aaaa")
                print("\(NUMBED)")
                print("aaaa numbed aaaa")
                property?.condition = RENTTYPE
                
                property?.numBed = Int(NUMBED) ?? 0
                property?.numBath = Int(NUMBATH) ?? 0
                property?.size = Int(SIZEROOM) ?? 0
                
                property?.airCon = AMENITIES[0]
                property?.balcony = AMENITIES[1]
                property?.closet = AMENITIES[2]
                property?.dishWash = AMENITIES[3]
                property?.fridge = AMENITIES[4]
                property?.heater = AMENITIES[5]
                property?.cableTV = AMENITIES[6]
                property?.internet = AMENITIES[7]
                property?.bed = AMENITIES[8]
                property?.tub = AMENITIES[9]
                property?.toiletPublic = AMENITIES[10]
                property?.stove = AMENITIES[11]
                property?.microwave = AMENITIES[12]
                property?.dryerPublic = AMENITIES[13]
                property?.laundry = AMENITIES[14]
                property?.deskChair = AMENITIES[15]
                property?.hanger = AMENITIES[16]
                property?.parking = AMENITIES[17]
                
//                property?.kitchen = AMENITIES[3]
                
                
                property?.dogs = RULES[0]
                property?.cats = RULES[1]
                property?.smoking = RULES[2]
                property?.drug = RULES[3]
                property?.party = RULES[4]
                property?.manonly = RULES[5]
                property?.womanonly = RULES[6]
                property?.both = RULES[7]
                
                let vc = segue.destination as? ScheduleViewController
                vc!.property = property
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numbersOfRowsAtSection[section] // ******* See upper code for future code *******
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let curcell:cellData = cellArray[indexPath.section]
        
        switch curcell.cell {
        case 1   :
            let cell = tableView.dequeueReusableCell(withIdentifier: curcell.identifier, for: indexPath) as! RentTypeTableViewCell
            return cell
            
        case 2 :
            let cell = tableView.dequeueReusableCell(withIdentifier: curcell.identifier, for: indexPath) as! PriceUploadTableViewCell
            
            cell.preLabel.text = "$"
            cell.preLabel.font = UIFont(name:"FiraSans",size:15)
            cell.preLabel.textAlignment = .right
            cell.postLabel.text = "/ month"
            cell.postLabel.font = UIFont(name:"FiraSans",size:15)
            cell.postLabel.textAlignment = .left
            
            return cell
            
        case 3   :
            let cell = tableView.dequeueReusableCell(withIdentifier: curcell.identifier, for: indexPath) as! BuildingTableViewCell
            return cell
            
        case 4   :
            let cell = tableView.dequeueReusableCell(withIdentifier: curcell.identifier, for: indexPath) as! BedUploadTableViewCell
            
            return cell
            
        case 5   :
            let cell = tableView.dequeueReusableCell(withIdentifier: curcell.identifier, for: indexPath) as! BathUploadTableViewCell
            
            return cell
            
        case 6   :
            let cell = tableView.dequeueReusableCell(withIdentifier: curcell.identifier, for: indexPath) as! SizeUploadTableViewCell
            cell.postLabel.text = "sqft"
            cell.postLabel.font = UIFont(name:"FiraSans",size:15)
            cell.postLabel.textAlignment = .left
            
            return cell
            
        case 7   :
            let cell = tableView.dequeueReusableCell(withIdentifier: curcell.identifier, for: indexPath) as! AmenityTableViewCell
            return cell
            
        default   :
            let cell = tableView.dequeueReusableCell(withIdentifier: curcell.identifier, for: indexPath) as! RuleTableViewCell
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellArray[indexPath.section].height
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellArray.count
    }
    
    //    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        return cellArray[section].title
    //    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = cellArray[section].title
        label.font = UIFont(name:"FiraSans-Bold",size:15)
        return label
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height:CGFloat = 30.0
        return height
    }
    
    @objc func toNext(sender: UIButton) {
        
        if (PRICE == "" || (BUILDINGTYPES[0] == false && BUILDINGTYPES[1] == false)){
            let alertController = UIAlertController(title: "Oops", message:
                "Please fill all required entries", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            }))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        performSegue(withIdentifier: "schedule", sender: nil)
    }
    @objc func toChoose(sender: UIButton) {
        //광역변수 초기화
        PRICE = ""
        BUILDINGTYPES = [false, false]
        AMENITIES = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
        RULES = [false, false, false, false, false, false, false, false]
        NUMBED = ""
        NUMBATH = ""
        SIZEROOM = ""
        RENTTYPE = ""
        navigationController?.popViewController(animated: true)
//        dismiss(animated: true, completion: nil)
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
}

