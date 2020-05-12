//
//  DescriptionViewController.swift
//  actual
//
//  Created by Minjae Shin on 2019-08-16.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit
import MapKit
class DescriptionViewController: UIViewController, UITextViewDelegate, CLLocationManagerDelegate {
    
    var property:Property?
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var wordCountLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var nextBtn: UIButton!
    //    var nextBtn:UIButton!
//    var descriptionText:UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        let navigationBarHeight = screenHeight * 88/812 //self.navigationController?.navigationBar.frame.height ?? 0
        let tapBarHeight = self.tabBarController?.tabBar.frame.height ?? 0
        let realScreenHeight = screenHeight - navigationBarHeight - tapBarHeight
        
        progressBar.setProgress(0.8, animated: true)
        progressBar.trackTintColor = UIColor(rgb: 0xdedede)
        progressBar.tintColor = UIColor(rgb: 0x8389BA)
        progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 3.5)
        self.view.addSubview(progressBar)
        
        if let property = property {
            print("\(property.cats)")
        }
        
//        descriptionText.frame = CGRect(x: screenWidth * 32/375, y: navigationBarHeight + realScreenHeight * 125/724, width: screenWidth * 311/375, height: realScreenHeight * 411/724)
        descriptionText.layer.borderColor = UIColor(rgb: 0x8389BA).cgColor
        descriptionText.layer.borderWidth = 1.5
        descriptionText.layer.cornerRadius = 10.0
        
        descriptionLabel.text = "Add additional information"
        self.descriptionText.delegate = self
        descriptionText.text = ""
        wordCountLabel.text = "\(0)/500"
        
        let longTitleLabel = UILabel()
        longTitleLabel.text = "D E S C R I P T I O N"
        longTitleLabel.font = UIFont(name:"FiraSans-Bold",size:20)
        longTitleLabel.textColor = UIColor(rgb: 0x8389BA)
        longTitleLabel.textAlignment = .center
        longTitleLabel.sizeToFit()
        
        self.navigationItem.titleView = longTitleLabel
        
//        let nextBtn : UIBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(toNext))
//        
//        self.navigationItem.rightBarButtonItem = nextBtn
//        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(rgb: 0x8389BA)
//        
        self.hideKeyboardWhenTappedAround()
        //추가
        let closeImage  = UIImage(named: "icon_close")!
        let closeButton = UIBarButtonItem(image: closeImage, style: .plain, target: self, action: #selector(toChoose))
        closeButton.tintColor = UIColor(rgb: 0x8389BA)
        navigationItem.rightBarButtonItem = closeButton
        

        
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
        
//        self.view.addSubview(descriptionText)
        
//        self.view.addSubview(nextBtn)
        //여기까지 추가
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare()")
        super.prepare(for: segue, sender: sender)
        //setting back button in navigation bar
        let backItem = UIBarButtonItem()
        backItem.title = ""
        backItem.tintColor = UIColor(rgb: 0x8389BA)
        navigationItem.backBarButtonItem = backItem
        
        
        //sending data to next segue
        if segue.identifier == "image"{
            if segue.destination is ImageViewController
            {
                property?.description = descriptionText.text
                
                let vc = segue.destination as? ImageViewController
                vc!.property = property
                
            }
        }
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        wordCountLabel.text = "\((0) + textView.text.count)/500"
//        if textView.text.count != 0 {
//            nextBtn.isEnabled = true
//        } else {
//            nextBtn.isEnabled = false
//        }
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars <= 500
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @objc func toNext(sender: UIButton) {
        performSegue(withIdentifier: "image", sender: nil)
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
//        navigationController?.popViewController(animated: true)
//        dismiss(animated: true, completion: nil)
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
}
