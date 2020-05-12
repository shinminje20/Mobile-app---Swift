//
//  chooseViewController.swift
//  actual
//
//  Created by Minjae Shin on 2019-08-19.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit

class ChooseViewController: UIViewController {


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //추가 및 변경
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        let navigationBarHeight = screenHeight * 88/812 //self.navigationController?.navigationBar.frame.height ?? 0
        let tapBarHeight = self.tabBarController?.tabBar.frame.height ?? 0
        let realScreenHeight = screenHeight - navigationBarHeight - tapBarHeight
        
        let manageFrame = CGRect(x: screenWidth * 78/375, y: navigationBarHeight + realScreenHeight * 252/(724-77.7), width: screenWidth * 220/375, height: realScreenHeight * 48/(724-77.7))
        let uploadFrame = CGRect(x: screenWidth * 78/375, y: navigationBarHeight + realScreenHeight * 566/(724-77.7), width: screenWidth * 220/375, height: realScreenHeight * 48/(724-77.7))
        
        let manageBtn = UIButton(frame: manageFrame)
        let uploadBtn = UIButton(frame: uploadFrame)
        
        let manageImageFrame = CGRect(x: screenWidth * 90/375, y: navigationBarHeight + realScreenHeight * 32/(724-77.7), width: screenWidth * 195/375, height: realScreenHeight * 204/724 )
        let uploadImageFrame = CGRect(x: screenWidth * 83/375, y: navigationBarHeight + realScreenHeight * 382/(724-77.7), width: screenWidth * 209/375, height: realScreenHeight * 152/724 )

        manageBtn.addTarget(self, action: #selector(toManage(sender:)), for: .touchUpInside)

        manageBtn.setTitle("Manage your Posting", for: .normal)
        manageBtn.setTitleColor(UIColor(rgb: 0x8389BA), for: .normal)
        manageBtn.layer.borderColor = UIColor(rgb: 0x8389BA).cgColor
        manageBtn.titleLabel?.font = UIFont(name:"FiraSans-Bold",size:15)
        manageBtn.layer.borderWidth = 2
        manageBtn.layer.cornerRadius = 20
        manageBtn.clipsToBounds = true
        
        uploadBtn.addTarget(self, action: #selector(toUpload(sender:)), for: .touchUpInside)
        uploadBtn.setTitle("Add new posting", for: .normal)
        uploadBtn.setTitleColor(UIColor.white, for: .normal)
        uploadBtn.titleLabel?.font = UIFont(name:"FiraSans-Bold",size:15)
        uploadBtn.backgroundColor = UIColor(rgb: 0x8389BA)
        uploadBtn.layer.borderColor = UIColor.clear.cgColor
        uploadBtn.layer.borderWidth = 1.2
        uploadBtn.layer.cornerRadius = 20
        uploadBtn.clipsToBounds = true
        
        
        let manageImage = UIImageView(image: UIImage(named: "managePost"))
        let uploadImage = UIImageView(image: UIImage(named: "newPost"))
        uploadImage.frame = uploadImageFrame
        manageImage.frame = manageImageFrame
        
        let separatorFrame = CGRect(x: UIScreen.main.bounds.width * 32.5/375, y: navigationBarHeight + realScreenHeight * 323/(724-77.7), width: screenWidth * 310.5/375, height: realScreenHeight * 17/(724-77.7))
        let separatorImage = UIImageView(image: UIImage(named: "separator"))
        separatorImage.frame = separatorFrame
        //여기까지 추가
        
        let longTitleLabel = UILabel()
        longTitleLabel.text = "Posting"
        longTitleLabel.font = UIFont(name:"FiraSans-Bold",size:27)
        longTitleLabel.textColor = UIColor(rgb: 0x8389BA)
        longTitleLabel.sizeToFit()
        
        let leftItem = UIBarButtonItem(customView: longTitleLabel)
        self.navigationItem.leftBarButtonItem = leftItem
        
        self.view.addSubview(uploadBtn)
        self.view.addSubview(manageBtn)
        self.view.addSubview(uploadImage)
        self.view.addSubview(manageImage)
        self.view.addSubview(separatorImage)
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        //setting back button in navigation bar
        let backItem = UIBarButtonItem()
        backItem.title = ""
        backItem.tintColor = UIColor(rgb: 0x8389BA)
        navigationItem.backBarButtonItem = backItem
    }

    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @objc func toUpload(sender: UIButton) {
        performSegue(withIdentifier: "address", sender: nil)
    }
    //추가
    @objc func toManage(sender: UIButton) {
        performSegue(withIdentifier: "manage", sender: nil)
    }
}
