//
//  FilteringViewController.swift
//  actual
//
//  Created by Sukkwon On on 2019-05-19.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit


class FilteringViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    let numbersOfRowsAtSection = [3, 1, 1, 1, 1]//, 1, 1]
    let firstcellheight:CGFloat = 129.5
    let secondcellheight:CGFloat = 137
    var initBool = false
    @IBOutlet weak var applyBtn: UIButton!
    
    //    //추가
    //    var btnOnOff = [false,false,false]
    //    //여기까지 추가
    var cellArray = [cellData]()
    
    let filterColor = [
        UIColor(red: 230/255.0, green: 156/255.0, blue: 110/255.0, alpha: 1.0),
        UIColor(red: 164/255.0, green: 205/255.0, blue: 103/255.0, alpha: 1.0),
        UIColor(red: 113/255.0, green: 171/255.0, blue: 221/255.0, alpha: 1.0)
    ]
    //    let filterColor = [
    //        UIColor(red: 113/255.0, green: 171/255.0, blue: 221/255.0, alpha: 1.0),
    //        UIColor(red: 164/255.0, green: 205/255.0, blue: 103/255.0, alpha: 1.0),
    //        UIColor(red: 230/255.0, green: 156/255.0, blue: 110/255.0, alpha: 1.0),
    //        UIColor(red: 173/255.0, green: 134/255.0, blue: 201/255.0, alpha: 1.0)
    //    ]
    
    //    let filterImage = ["filter_verifyBox", "filter_roomrentBox", "filter_urgentBox", "filter_takeoverBox" ]
    let filterImage = ["filter_roomrentBox", "filter_urgentBox", "filter_takeoverBox" ]
    
    private let tableHeaderViewHeight: CGFloat = UIScreen.main.bounds.height*0.75
    private let tableHeaderViewCutaway: CGFloat = 40.0
    var headerMaskLayer: CAShapeLayer!
    
    weak var cellDelegate: AmenityTableViewCell?
    
    //추가 및 변경
    @objc func filterSwitchClicked(_ sender:UISwitch!){
        if sender.isOn{
            switch sender.tag {
            case 0:
                CONDITION[0] = true
                CONDITION[1] = false
                CONDITION[2] = false
                //                btnOnOff[0] = true
                //                btnOnOff[1] = false
            //                btnOnOff[2] = false
            case 1:
                CONDITION[1] = true
                CONDITION[0] = false
                CONDITION[2] = false
                //                btnOnOff[1] = true
                //                btnOnOff[0] = false
            //                btnOnOff[2] = false
            default :
                CONDITION[2] = true
                CONDITION[0] = false
                CONDITION[1] = false
                //                btnOnOff[2] = true
                //                btnOnOff[0] = false
                //                btnOnOff[1] = false
            }
            print("button \(sender.tag) on")
        }
        else{
            switch sender.tag {
            case 0:
                CONDITION[0] = false
            //                btnOnOff[0] = false
            case 1:
                CONDITION[1] = false
            //                btnOnOff[1] = false
            default :
                CONDITION[2] = false
                //                btnOnOff[2] = false
            }
            print("button \(sender.tag) off")
        }
    }
    //여기까지 추가 및 변경
    
    
    @objc func toList(sender: UIButton) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btnFrame = CGRect(x: Double(UIScreen.main.bounds.width) * 0.75, y: Double(UIScreen.main.bounds.height) *  0.8, width: Double(UIScreen.main.bounds.width) * 0.17, height: Double(UIScreen.main.bounds.width) * 0.17 )
        //9/13 변경
        applyBtn.backgroundColor = UIColor(rgb: 0x8389BA)
        applyBtn.setTitle("Next",for: .normal)
        applyBtn.tintColor = .white
        applyBtn.titleLabel?.font = UIFont(name:"FiraSans-Bold", size: 18)
        
        applyBtn.addTarget(self, action: #selector(toApply), for: .touchUpInside)
//        let applyBtn = UIButton(type: .custom)
//        applyBtn.frame = btnFrame
//
//        //        let myFirstButton = UIButton()
//        applyBtn.layer.cornerRadius = 0.5 * applyBtn.bounds.size.width
//        applyBtn.clipsToBounds = true
//        applyBtn.setImage(UIImage(named: "list_filter"), for: .normal)
//        applyBtn.backgroundColor = UIColor(rgb: 0x8389BA)
//        applyBtn.addTarget(self, action: #selector(toApply), for: .touchUpInside)
//        applyBtn.layer.shadowColor = UIColor.black.cgColor
//
//        applyBtn.layer.masksToBounds = false
//        applyBtn.layer.shadowRadius = 3
//        applyBtn.layer.shadowOpacity = 1.0
//        applyBtn.layer.shadowOffset = CGSize(width: 2, height: 2)
        
        // GLOBAL Initialization
        PRICE_MIN = -1
        PRICE_MAX = -1
        BUILDINGTYPES = [false, false]
        AMENITIES = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
        RULES = [false, false, false, false, false, false, false, false]
        NUMBED = ""
        NUMBATH = ""
        SIZEROOM = ""
        FILTERING = false
        //추가
        CONDITION = [false, false, false, false]
        
        print("2=================================================================")
        tableView.delegate = self
        print("3=================================================================")
        tableView.dataSource = self
        tableView.frame = .zero
        self.view.addSubview(tableView)
        self.tableView.separatorStyle = .none
        buildingTypeMultiSelectionFlag = false
        
        // =====================================================================
        // Table Data Init
        // =====================================================================
        //SampleData
        
        cellArray = [
            //            cellData(cell : 1, title: "V E R I F I C A T I O N", height: 60, name: "VerificationTableViewCell", identifier: "verificationcell"),
            cellData(cell : 1, title: "C O N D I T I O N", height: 60, name: "ConditionTableViewCell", identifier: "conditioncell"),
            //추가 testing 중
            cellData(cell : 2, title: "P R I C E", height: 60, name: "testPriceTableViewCell", identifier: "testpricecell"),
            //            cellData(cell : 2, title: "P R I C E", height: 90, name: "PriceTableViewCell", identifier: "pricecell"),
            cellData(cell : 3, title: "B E D R O O M S", height: 75, name: "BedroomsTableViewCell", identifier: "bedroomscell"),
            cellData(cell : 4, title: "B A T H R O O M S", height: 75, name: "BathroomsTableViewCell", identifier: "bathroomscell"),
            cellData(cell : 5, title: "B U I L D I N G  T Y P E", height: 90, name: "BuildingTableViewCell", identifier: "buildingcell"),
            //            cellData(cell : 7, title: "A M E N I T I E S", height: 230, name: "AmenityTableViewCell", identifier: "amenitycell"),
            //            cellData(cell : 8, title: "R U L E S", height: 110, name: "RuleTableViewCell", identifier: "rulecell")
        ]
        
        for cell in cellArray {
            let nibName = UINib(nibName: cell.name, bundle: nil)
            tableView.register(nibName, forCellReuseIdentifier: cell.identifier)
        }
        // Ver 2
        var initButtonImage = UIImage(named: "filter_switchSmall")!
        initButtonImage = initButtonImage.withRenderingMode(.alwaysOriginal)
        //        var closeImage  = UIImage(named: "icon_close")!
        //        closeImage = closeImage.withRenderingMode(.alwaysOriginal)
        
        let initButton   = UIBarButtonItem(image: initButtonImage,  style: .plain, target: self, action: #selector(toReset))
        //추가 및 변경:  여기 image: 부분 변경
        let closeButton = UIBarButtonItem(image: UIImage(named: "icon_close"),  style: .plain, target: self, action: #selector(toList))
        
        navigationItem.rightBarButtonItem = closeButton
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(rgb: 0x8389BA)
        
        navigationItem.leftBarButtonItem = initButton
        self.navigationItem.leftBarButtonItem?.tintColor = .white
        //=======center FILTER Label===============
        let filterLabel = UILabel()
        
        filterLabel.text = "F I L T E R"
        filterLabel.font = UIFont(name:"FiraSans-Bold",size:20)
        filterLabel.textColor = UIColor(rgb: 0x8389BA)
        filterLabel.sizeToFit()
        
        self.navigationItem.titleView = filterLabel
        
        let dummyViewHeight = CGFloat(50)
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: dummyViewHeight))
        self.tableView.contentInset = UIEdgeInsets(top: -dummyViewHeight, left: 0, bottom: 0, right: 0)
        
        tableView.allowsSelection = false
        
        //9/13 변경
//        self.view.addSubview(applyBtn)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numbersOfRowsAtSection[section] // ******* See upper code for future code *******
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let curcell:cellData = cellArray[indexPath.section]
        
        switch curcell.cell {
            //        case 1 :
            //            let cell = tableView.dequeueReusableCell(withIdentifier: curcell.identifier, for: indexPath) as! VerificationTableViewCell
            //
            //            cell.verificationImage.image = UIImage(named: filterImage[0])
            //            cell.verificationSwitch.onTintColor = filterColor[0]
            //            cell.verificationSwitch.tintColor = UIColor(red: 237/255.0, green: 236/255.0, blue: 234/255.0, alpha: 1.0)
            //
            //            return cell
            
        case 1   :
            let cell = tableView.dequeueReusableCell(withIdentifier: curcell.identifier, for: indexPath) as! ConditionTableViewCell
            
            //            switch indexPath.row {
            //            case 0:
            cell.conditionImage.image = UIImage(named: filterImage[indexPath.row])
            cell.conditionSwitch.onTintColor = filterColor[indexPath.row]
            cell.conditionSwitch.tintColor = UIColor(red: 237/255.0, green: 236/255.0, blue: 234/255.0, alpha: 1.0)
            cell.conditionSwitch.tag = indexPath.row
            cell.conditionSwitch.addTarget(self, action: #selector(filterSwitchClicked(_:)), for: .valueChanged)
            //                cell.conditionSwitch.isOn = btnOnOff[indexPath.row]
            //            case 1:
            //                cell.conditionImage.image = UIImage(named: filterImage[indexPath.row])
            //                cell.conditionSwitch.onTintColor = filterColor[indexPath.row]
            //                cell.conditionSwitch.tintColor = UIColor(red: 237/255.0, green: 236/255.0, blue: 234/255.0, alpha: 1.0)
            //                //추가아아아아아아아아아아아아앙 김옥찐
            //                cell.conditionSwitch.tag = indexPath.row
            //                //여기까지 추가
            //                cell.conditionSwitch.addTarget(self, action: #selector(filterSwitchClicked(_:)), for: .valueChanged)
            //            default :
            //                cell.conditionImage.image = UIImage(named: filterImage[indexPath.row])
            //                cell.conditionSwitch.onTintColor = filterColor[indexPath.row]
            //                cell.conditionSwitch.tintColor = UIColor(red: 237/255.0, green: 236/255.0, blue: 234/255.0, alpha: 1.0)
            //                //추가아아아아아아아아아아아아앙 김옥찐
            //                cell.conditionSwitch.tag = indexPath.row
            //                //여기까지 추가
            //                cell.conditionSwitch.addTarget(self, action: #selector(filterSwitchClicked(_:)), for: .valueChanged)
            //            }
            
            
            return cell
            
        case 2   :
            let cell = tableView.dequeueReusableCell(withIdentifier: curcell.identifier, for: indexPath) as! testPriceTableViewCell
            
            return cell
            
        case 3   :
            let cell = tableView.dequeueReusableCell(withIdentifier: curcell.identifier, for: indexPath) as! BedroomsTableViewCell
            return cell
            
        case 4   :
            let cell = tableView.dequeueReusableCell(withIdentifier: curcell.identifier, for: indexPath) as! BathroomsTableViewCell
            return cell
            
        default   :
            let cell = tableView.dequeueReusableCell(withIdentifier: curcell.identifier, for: indexPath) as! BuildingTableViewCell
            return cell
            
            //        case 7   :
            //            let cell = tableView.dequeueReusableCell(withIdentifier: curcell.identifier, for: indexPath) as! AmenityTableViewCell
            //            return cell
            
            //        default   :
            //            let cell = tableView.dequeueReusableCell(withIdentifier: curcell.identifier, for: indexPath) as! RuleTableViewCell
            //            return cell
            
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
        label.font = UIFont(name:"FiraSans",size:18)
        label.textAlignment = .center
        return label
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = UIColor.white
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height:CGFloat = 50.0
        return height
    }
    
    //    @objc func toChoose(sender: UIButton) {
    //        //광역변수 초기화
    ////        PRICE = ""
    ////        BUILDINGTYPES = [false, false]
    ////        AMENITIES = [false, false, false, false, false, false, false, false, false, false, false, false]
    ////        RULES = [false, false, false, false]
    ////        NUMBED = ""
    ////        NUMBATH = ""
    ////        SIZEROOM = ""
    ////        RENTTYPE = ""
    //        navigationController?.popViewController(animated: true)
    //        dismiss(animated: true, completion: nil)
    //    }
    
    @objc func toApply(sender: UIButton) {
        FILTERING = true
        FROMFILTERING = true
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func toResult(sender: UIButton) {
        //광역변수 초기화
        PRICE_MIN = -1
        PRICE_MAX = -1
        BUILDINGTYPES = [false, false]
        AMENITIES = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
        RULES = [false, false, false, false, false, false, false, false]
        NUMBED = ""
        NUMBATH = ""
        SIZEROOM = ""
        FILTERING = false
        //CONDITION 추가해주세요우~ propertyClassess에다가 아주그냥 추가좀
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        
    }
    
    @objc func toReset(sender: UIButton) {
        FILTERING = false
    }
}

