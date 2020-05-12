//
//  AddressUploadViewController.swift
//  actual
//
//  Created by Minjae Shin on 2019-08-15.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AddressUploadViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate, CLLocationManagerDelegate, UIScrollViewDelegate {
    
//    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var addressMap: MKMapView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var nextBtn: UIButton!
    
    var testAddress : String = ""
    let property:Property = Property()
//    var nextBtn : UIBarButtonItem!
//    var progressBar:UIProgressView!
    //추가
//    var nextBtn:UIButton!
    //여기까지 추가
    
    
    var addressLatitude:Double!
    var addressLongitude:Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //추가
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        let navigationBarHeight = screenHeight * 88/812 //self.navigationController?.navigationBar.frame.height ?? 0
        let tapBarHeight = self.tabBarController?.tabBar.frame.height ?? 0
        let realScreenHeight = screenHeight - navigationBarHeight - tapBarHeight

//        let nextBtnFrame = CGRect(x: screenWidth * 297/375, y: navigationBarHeight + realScreenHeight * 600/724, width: screenWidth * 40/375, height: screenWidth * 40/375)
//        nextBtn = UIButton(frame: nextBtnFrame)
//        nextBtn.setImage(UIImage(named: "872"), for: .normal)
//        nextBtn.addTarget(self, action: #selector(toNext), for: .touchUpInside)
//        nextBtn.backgroundColor = UIColor(rgb: 0x8389BA)
//        nextBtn.layer.cornerRadius = 0.5 * nextBtn.bounds.size.width
//        nextBtn.clipsToBounds = true
        nextBtn.isEnabled = false
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
        
        progressBar.setProgress(0.2, animated: true)
        progressBar.trackTintColor = UIColor(rgb: 0xdedede)
        progressBar.tintColor = UIColor(rgb: 0x8389BA)
        progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 3.5)
        self.view.addSubview(progressBar)
        
//        var ProgressFrame = progress.
//        var pSetX = ProgressFrame.origin.x
//        var pSetY = CGFloat(navBarHeight!)
//        var pSetWidth = self.view.frame.width
//        var pSetHight = ProgressFrame.height
        let closeImage  = UIImage(named: "icon_close")!
        let closeButton = UIBarButtonItem(image: closeImage, style: .plain, target: self, action: #selector(toChoose))
        closeButton.tintColor = UIColor(rgb: 0x8389BA)
        navigationItem.rightBarButtonItem = closeButton
        
//
//        nextBtn = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(toNext))
//        self.navigationItem.rightBarButtonItem = nextBtn
//        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(rgb: 0x8389BA)
//        nextBtn.isEnabled = false
        
        self.addressTextField.delegate = self
        
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        navigationController?.navigationBar.shadowImage = UIImage()
        
//        addressLabel.text = "Address"
//        addressLabel.font = UIFont(name:"FiraSans-Bold", size: 18)
        addressTextField.placeholder = "Ex) 9393 Tower Rd, Burnaby, BC"
        addressTextField.returnKeyType = UIReturnKeyType.done
        let borderColor = UIColor(rgb: 0x8389BA)
        addressTextField.layer.backgroundColor = UIColor.white.cgColor
        addressTextField.layer.borderColor = borderColor.cgColor
        addressTextField.layer.borderWidth = 1
//        addressTextField.layer.masksToBounds = true
        addressTextField.layer.cornerRadius = addressTextField.frame.height / 3
        addressTextField.clipsToBounds = true
        addressTextField.layer.shadowOpacity = 1
        addressTextField.layer.shadowRadius = 3
        addressTextField.layer.shadowOffset = CGSize.zero // Use any CGSize
        addressTextField.layer.shadowColor = UIColor.gray.cgColor
        
        addressTextField.background = UIImage(named: "311")
        
        let longTitleLabel = UILabel()
        longTitleLabel.text = "A D D R E S S"
        longTitleLabel.font = UIFont(name:"FiraSans-Bold",size:20)
        longTitleLabel.textColor = UIColor(rgb: 0x8389BA)
        longTitleLabel.textAlignment = .center
        longTitleLabel.sizeToFit()

        self.navigationItem.titleView = longTitleLabel
        self.hideKeyboardWhenTappedAround()
        
//        var closeImage  = UIImage(named: "icon_close")!
//        closeImage = closeImage.withRenderingMode(.alwaysOriginal)
//        let closeButton = UIBarButtonItem(image: closeImage,  style: .plain, target: self, action: #selector(toList))
//        navigationItem.leftBarButtonItem = closeButton
//        self.view.addSubview(nextBtn)
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        //setting back button in navigation bar
        let backItem = UIBarButtonItem()
        backItem.title = ""
        backItem.tintColor = UIColor(rgb: 0x8389BA)
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == "specification"{
            var coordinate:CLLocationCoordinate2D?
            coordinate = CLLocationCoordinate2D(latitude: addressLatitude, longitude: addressLongitude)
            if segue.destination is UploadViewController
            {
                property.address.latitude = addressLatitude
                property.address.longitude = addressLongitude
                
                let vc = segue.destination as? UploadViewController
                vc!.property = property
            }
        }
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //if user re-searching, then delete previous annotation
        for annotation in self.addressMap.annotations {
            self.addressMap.removeAnnotation(annotation)
        }
        
        performAction()
        
        self.view.endEditing(true)
        return false
    }
    
//    @IBAction func triggerTouchAction(gestureReconizer: UITapGestureRecognizer) {
//        //Add alert to show it works
//    }
    
    func performAction() {
        if ((self.addressTextField.text?.isEmpty ?? true) ||
            (self.addressTextField.text?.isEmpty ?? true)){
            let alertController = UIAlertController(title: "Oops", message:
                "Please fill all required entries", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            }))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(addressTextField.text!) { (placemarks, error) in
            guard let placemarks = placemarks, let location = placemarks.first?.location
                else {
                    // handle no location found from the address given by user
                    print("AddressUploadViewController.swift - error : This address is cannot be converted to coordinates value.")
                    let alertController = UIAlertController(title: "Oops", message:"Your address information is not correct.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in}))
                    self.present(alertController, animated: true, completion: nil)
                    return
            }
            
            self.addressLatitude = location.coordinate.latitude
            self.addressLongitude = location.coordinate.longitude
            
            //convert coordinate to address
            self.getAddressFromLatLon(Latitude: self.addressLatitude, Longitude: self.addressLongitude)
            
            let coordination:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: self.addressLatitude, longitude: self.addressLongitude)
            
            let region = MKCoordinateRegion(center: coordination, latitudinalMeters: 500, longitudinalMeters: 500)
            self.addressMap.setRegion(region, animated: false)
            let anno = MKPointAnnotation()
            anno.coordinate = coordination
            self.addressMap.addAnnotation(anno)
            self.addressMap.reloadInputViews()
            self.addressMap.fitAll()
            
            self.nextBtn.isEnabled = true
        }
        
    }
    
    
    @objc func toNext(sender: UIButton) {
        
        if (self.addressTextField.text?.isEmpty ?? true){
            let alertController = UIAlertController(title: "Oops", message:
                "Please fill all required entries", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            }))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        print(testAddress)
        testAddress = ""
        performSegue(withIdentifier: "specification", sender: nil)
    }
    
    func getAddressFromLatLon(Latitude: Double, Longitude: Double) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = Latitude
        center.longitude = Longitude
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    
//                    var fullAddressString : String = ""
                    if pm.subThoroughfare != nil {
//                        fullAddressString = fullAddressString + pm.subThoroughfare! + " "
                        self.property.address.address = ""
                        self.property.address.address = self.property.address.address + pm.subThoroughfare!
                    }
                    if pm.thoroughfare != nil {
//                        fullAddressString = fullAddressString + pm.thoroughfare! + ", "
                        self.property.address.address = self.property.address.address + pm.thoroughfare!
                    }
                    if pm.locality != nil {
//                        fullAddressString = fullAddressString + pm.locality! + ", "
                        self.property.address.city = ""
                        self.property.address.city = self.property.address.city + pm.locality!
                    }
                    if pm.administrativeArea != nil {
//                        fullAddressString = fullAddressString + pm.administrativeArea! + ", "
                        self.property.address.province = ""
                        self.property.address.province = self.property.address.province + pm.administrativeArea!
                    }
                    if pm.postalCode != nil {
//                        fullAddressString = fullAddressString + pm.postalCode!
                        self.property.address.postalCode = ""
                        self.property.address.postalCode = self.property.address.postalCode + pm.postalCode!
                    }
//                    self.testAddress = self.testAddress + fullAddressString
//                    self.property.address.fullAddress = self.testAddress
                    
                }
        })
    }
    
//    @objc func toList(sender: UIButton) {
//        dismiss(animated: true, completion: nil)
//
//        //광역변수 초기화
//        PRICE = ""
//        BUILDINGTYPES = [false, false]
//        AMENITIES = [false, false, false, false, false, false, false, false, false, false, false, false]
//        RULES = [false, false, false, false]
//        NUMBED = ""
//        NUMBATH = ""
//        SIZEROOM = ""
//        RENTTYPE = ""
//    }
    
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
        dismiss(animated: true, completion: nil)
    }
}
