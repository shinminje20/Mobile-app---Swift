//
//  ScheduleViewController.swift
//  actual
//
//  Created by Jinwook Kim on 2019-08-15.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit
import MapKit

enum MyTheme {
    case light
    case dark
}

class ScheduleViewController: UIViewController, CLLocationManagerDelegate {
    var theme = MyTheme.light
    var property:Property?
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var nextBtn: UIButton!
//    var nextBtn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //추가
        
        let closeImage  = UIImage(named: "icon_close")!
        let closeButton = UIBarButtonItem(image: closeImage, style: .plain, target: self, action: #selector(toChoose))
        closeButton.tintColor = UIColor(rgb: 0x8389BA)
        navigationItem.rightBarButtonItem = closeButton
//
//        let screenHeight = UIScreen.main.bounds.height
//        let screenWidth = UIScreen.main.bounds.width
//        let navigationBarHeight = screenHeight * 88/812 //self.navigationController?.navigationBar.frame.height ?? 0
//        let tapBarHeight = self.tabBarController?.tabBar.frame.height ?? 0
//        let realScreenHeight = screenHeight - navigationBarHeight - tapBarHeight
//
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
        nextBtn.backgroundColor = UIColor(rgb: 0x8389BA)
        nextBtn.setTitle("Next",for: .normal)
        nextBtn.tintColor = .white
        nextBtn.titleLabel?.font = UIFont(name:"FiraSans-Bold", size: 18)
        
        nextBtn.addTarget(self, action: #selector(toNext), for: .touchUpInside)

        //여기까지 추가
        
        progressBar.setProgress(0.6, animated: true)
        progressBar.trackTintColor = UIColor(rgb: 0xdedede)
        progressBar.tintColor = UIColor(rgb: 0x8389BA)
        progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 3.5)
        self.view.addSubview(progressBar)
        
        let longTitleLabel = UILabel()
        longTitleLabel.text = "MOVE IN DATE"
        longTitleLabel.font = UIFont(name:"FiraSans-Bold",size:20)
        longTitleLabel.textColor = UIColor(rgb: 0x8389BA)
        longTitleLabel.textAlignment = .center
        longTitleLabel.sizeToFit()
        
        //        if let property = property {
        //            print("--------")
        //            print("\(property.smoking)")
        //            print("\(property.drug)")
        //            print("\(property.cats)")
        //            print("\(property.dogs)")
        //            print("\(property.cableTV)")
        //            print("\(property.airCon)")
        //            print("--------")
        //        }
        
        self.navigationItem.titleView = longTitleLabel
        self.navigationController?.navigationBar.isTranslucent=false
        self.view.backgroundColor=Style.bgColor
        
        view.addSubview(calenderView)
        calenderView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive=true
        calenderView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive=true
        calenderView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive=true
        calenderView.heightAnchor.constraint(equalToConstant: 365).isActive=true
        
//        calenderView.layer.frame = CGRect(x: <#T##CGFloat#>, y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
//        let nextBtn : UIBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(toNext))
//
//        self.navigationItem.rightBarButtonItem = nextBtn
//        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(rgb: 0x8389BA)
        
        //        print("======================================================================================")
        //        print("======================================================================================")
        //        print(preparedData.address)
        //        print(preparedData.coordinate)
        //        print(preparedData.selectedYear)
        //        print(preparedData.selectedMonth)
        //        print(preparedData.selectedDate)
        //        print("======================================================================================")
        //        print("======================================================================================")
//        self.view.addSubview(nextBtn)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare()")
        super.prepare(for: segue, sender: sender)
        //setting back button in navigation bar
        let backItem = UIBarButtonItem()
        backItem.title = ""
        backItem.tintColor = UIColor(rgb: 0x8389BA)
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == "description"{
            if segue.destination is DescriptionViewController
            {
                property?.moveInDate = "\(calenderView.selectedDate)/" + "\(calenderView.selectedMonth)/" + "\(calenderView.selectedYear)"
                let vc = segue.destination as? DescriptionViewController
                vc!.property = property
                //                vc!.preparedData?.coordinate = preparedData?.coordinate
                //                vc!.preparedData?.address = preparedData?.address
                //                vc!.preparedData?.selectedYear = calenderView.selectedYear
                //                vc!.preparedData?.selectedMonth = calenderView.selectedMonth
                //                vc!.preparedData?.selectedDate = calenderView.selectedDate
            }
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        calenderView.myCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    
    //
    //    @objc func rightBarBtnAction(sender: UIBarButtonItem) {
    //        sender.title = "Next"
    //        self.view.backgroundColor=Style.bgColor
    //    }
    
    let calenderView: CalendarView = {
        let v=CalendarView(theme: MyTheme.light)
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    @objc func toNext(sender: UIButton) {
        performSegue(withIdentifier: "description", sender: nil)
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

