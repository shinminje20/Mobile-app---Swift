//
//  ImageViewController.swift
//  actual
//
//  Created by Minjae Shin on 2019-08-16.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import MapKit
import Firebase
import BSImagePicker
import BSImageView


class ImageViewController: UIViewController {
    
    var db: Firestore!
    
    var property:Property?
    
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    @IBOutlet weak var imageView5: UIImageView!
    @IBOutlet weak var imageView6: UIImageView!
    @IBOutlet weak var publishBtn: UIButton!
    
    @IBOutlet weak var progressBar: UIProgressView!
    var imageData = [Data]()
    var imageCount = 0
    
    var stationCount = 0
    
    var aroundProperty:Around = Around(placeName: "", displayedTime: "", time: 901) // minimum is 900
    
    let stationData: [Station] = [Station(displayName: "22nd Street", latitude: 49.2, longitude: -122.949167),
                                  Station(displayName: "29th Avenue", latitude: 49.2442, longitude: -123.046),
                                  Station(displayName: "Aberdeen", latitude: 49.183889, longitude: -123.136389),
                                  Station(displayName: "Braid", latitude: 49.23322, longitude: -122.88283),
                                  Station(displayName: "Brentwood Town Centre", latitude: 49.26633, longitude: -123.00163),
                                  Station(displayName: "Broadway - City Hall", latitude: 49.262778, longitude: -123.114444),
                                  Station(displayName: "Burquitlam", latitude: 49.261389, longitude: -122.889722),
                                  Station(displayName: "Burrard", latitude: 49.2853, longitude: -123.1196),
                                  Station(displayName: "Columbia", latitude: 49.20476, longitude: -122.906161),
                                  Station(displayName: "Commercial - Broadway", latitude: 49.2625, longitude: -123.068889),
                                  Station(displayName: "Coquitlam Central", latitude: 49.273889, longitude: -122.8),
                                  Station(displayName: "Edmonds", latitude: 49.212054, longitude: -122.959226),
                                  Station(displayName: "Gateway", latitude: 49.198945, longitude: -122.850559),
                                  Station(displayName: "Gilmore", latitude: 49.26489, longitude: -123.01351),
                                  Station(displayName: "Granville", latitude: 49.28275, longitude: -123.116639),
                                  Station(displayName: "Holdom", latitude: 49.26469, longitude: -122.98222),
                                  Station(displayName: "Inlet Centre", latitude: 49.277222, longitude: -122.827778),
                                  Station(displayName: "Joyce - Collingwood", latitude: 49.23835, longitude: -123.031704),
                                  Station(displayName: "King Edward", latitude: 49.249167, longitude: -123.115833),
                                  Station(displayName: "King George", latitude: 49.1827, longitude: -122.8446),
                                  Station(displayName: "Lafarge Lake - Douglas", latitude: 49.285556, longitude: -122.791667),
                                  Station(displayName: "Lake City Way", latitude: 49.25458, longitude: -122.93903),
                                  Station(displayName: "Lansdowne", latitude: 49.174722, longitude: -123.136389),
                                  Station(displayName: "Langara - 49th Avenue", latitude: 49.226389, longitude: -123.116111),
                                  Station(displayName: "Lincoln", latitude: 49.280425, longitude: -122.793915),
                                  Station(displayName: "Lougheed Town Centre", latitude: 49.24846, longitude: -122.89702),
                                  Station(displayName: "Main Street - Science World", latitude: 49.273114, longitude: -123.100348),
                                  Station(displayName: "Marine Drive", latitude: 49.209722, longitude: -123.116944),
                                  Station(displayName: "Metrotown", latitude: 49.225463, longitude: -123.003182),
                                  Station(displayName: "Moody Centre", latitude: 49.27806, longitude: -122.84579),
                                  Station(displayName: "Nanaimo", latitude: 49.2483, longitude: -123.0559),
                                  Station(displayName: "New Westminster", latitude: 49.201354, longitude: -122.912716),
                                  Station(displayName: "Oakridge - 41st Avenue", latitude: 49.233056, longitude: -123.116667),
                                  Station(displayName: "Olympic Village", latitude: 49.266389, longitude: -123.115833),
                                  Station(displayName: "Patterson", latitude: 49.22967, longitude: -123.012376),
                                  Station(displayName: "Production Way - University", latitude: 49.25337, longitude: -122.91815),
                                  Station(displayName: "Renfrew", latitude: 49.258889, longitude: -123.045278),
                                  Station(displayName: "Richmond - Brighouse", latitude: 49.168056, longitude: -123.136389),
                                  Station(displayName: "Royal Oak", latitude: 49.220004, longitude: -122.988381),
                                  Station(displayName: "Rupert", latitude: 49.260833, longitude: -123.032778),
                                  Station(displayName: "Sapperton", latitude: 49.22443, longitude: -122.88964),
                                  Station(displayName: "Scott Road", latitude: 49.20442, longitude: -122.874157),
                                  Station(displayName: "Sperling - Burnaby Lake", latitude: 49.25914, longitude: -122.96381),
                                  Station(displayName: "Stadium-Chinatown", latitude: 49.279371, longitude: -123.109323),
                                  Station(displayName: "Surrey Central", latitude: 49.189473, longitude: -122.847871),
                                  Station(displayName: "Vancouver City Centre", latitude: 49.282467, longitude: -123.118628),
                                  Station(displayName: "VCC - Clark", latitude: 49.265753, longitude: -123.078825),
                                  Station(displayName: "Waterfront", latitude: 49.285929, longitude: -123.111277),
                                  Station(displayName: "Yaletown - Roundhouse", latitude: 49.27455, longitude: -123.1219)]
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    let imageNewWidth:CGFloat = 800
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ImageViewController.addImageTapped(tapGestureRecognizer:)))
        imageView1.image = UIImage(named: "984")
        imageView1.addGestureRecognizer(tapGestureRecognizer)
        imageView1.isUserInteractionEnabled = true
        
        let user = Auth.auth().currentUser
        if let user = user {
            property!.uid = user.uid
            property!.hostEmail = user.email!
            property!.author = user.displayName!
        }
        
        progressBar.setProgress(1, animated: true)
        progressBar.trackTintColor = UIColor(rgb: 0xdedede)
        progressBar.tintColor = UIColor(rgb: 0x8389BA)
        progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 3.5)
        self.view.addSubview(progressBar)
        
        // [FIREBASE START setup]
        db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        if let property = property {
            print(property.description)
            print(property.type)
            print(property.numBed)
            print(property.numBath)
            print(property.airCon)
            print(property.size)
            print(property.moveInDate)
            print(property.address.fullAddress)
            print(property.cats)
            print(property.dogs)
            print(property.price)
            print(property.cableTV)
        }
        
        publishBtn.backgroundColor = UIColor(rgb: 0x8389BA)
        publishBtn.setTitle("P U B L I S H",for: .normal)
        publishBtn.tintColor = .white
        publishBtn.titleLabel?.font = UIFont(name:"FiraSans-Bold", size: 18)
        
        publishBtn.addTarget(self, action: #selector(publish), for: .touchUpInside)
        
        let closeImage  = UIImage(named: "icon_close")!
        let closeButton = UIBarButtonItem(image: closeImage, style: .plain, target: self, action: #selector(toChoose))
        closeButton.tintColor = UIColor(rgb: 0x8389BA)
        navigationItem.rightBarButtonItem = closeButton
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.color = UIColor(rgb: 0x8389BA)
        self.view.addSubview(activityIndicator)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Resize image so firebase storage doesn't complain that we're taking up too much bandwidth
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {

        // old version
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        
        // new version
//        let newHeight = newWidth
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        
        
        image.draw(in: CGRect(x: 0, y: 0,width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func resizeDisplaying(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        // old version
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        
        // new version
        //        let newHeight = newWidth
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newWidth))
        
        
        image.draw(in: CGRect(x: 0, y: 0,width: newWidth, height: newWidth))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func imageUpdate(assets: [PHAsset]) {
        self.imageData = []
        if assets.count == 1 {
            imageView2.image = UIImage(named: "984")
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ImageViewController.addImageTapped(tapGestureRecognizer:)))
            imageView1.isUserInteractionEnabled = false
            imageView2.addGestureRecognizer(tapGestureRecognizer)
            imageView2.isUserInteractionEnabled = true
            
            imageView1.layer.cornerRadius = 11
            //9/20 추가
            imageView1.clipsToBounds = true
            imageView1.layer.borderColor = UIColor(rgb: 0x8389BA).cgColor
            imageView1.layer.borderWidth = 2
            
            //9/21 변경, UI가 이렇게 하는게 훨씬 나은거 같아서 ...;; 걍 각각따로 resize 하게 했음
            imageView1.image = resizeDisplaying(image: getAssetThumbnail(asset: assets[0]), newWidth: imageNewWidth)
            let uploadImage1:UIImage! = resizeImage(image: getAssetThumbnail(asset: assets[0]), newWidth: imageNewWidth)
            imageData.append((uploadImage1?.pngData())!)
            imageCount = 1
            
//            imageView1.image = resizeImage(image: getAssetThumbnail(asset: assets[0]), newWidth: imageNewWidth)
//            imageData.append((imageView1.image?.pngData())!)

        }
        else if assets.count == 2 {
            imageView3.image = UIImage(named: "984")
            imageView2.isUserInteractionEnabled = false
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ImageViewController.addImageTapped(tapGestureRecognizer:)))
            imageView3.addGestureRecognizer(tapGestureRecognizer)
            imageView3.isUserInteractionEnabled = true
            
            imageView1.layer.cornerRadius = 11
            imageView2.layer.cornerRadius = 11
            //9/20 추가
            imageView1.clipsToBounds = true
            imageView2.clipsToBounds = true
            
            imageView1.layer.borderColor = UIColor(rgb: 0x8389BA).cgColor
            imageView2.layer.borderColor = UIColor(rgb: 0x8389BA).cgColor
            
            imageView1.layer.borderWidth = 2
            imageView2.layer.borderWidth = 2
            
//            imageView1.image = resizeImage(image: getAssetThumbnail(asset: assets[0]), newWidth: imageNewWidth)
//            imageView2.image = resizeImage(image: getAssetThumbnail(asset: assets[1]), newWidth: imageNewWidth)
            
            //9/21 변경, UI가 이렇게 하는게 훨씬 나은거 같아서 ...;; 걍 각각따로 resize 하게 했음
            imageView1.image = resizeDisplaying(image: getAssetThumbnail(asset: assets[0]), newWidth: imageNewWidth)
            imageView2.image = resizeDisplaying(image: getAssetThumbnail(asset: assets[1]), newWidth: imageNewWidth)
            let uploadImage1:UIImage! = resizeImage(image: getAssetThumbnail(asset: assets[0]), newWidth: imageNewWidth)
            let uploadImage2:UIImage! = resizeImage(image: getAssetThumbnail(asset: assets[1]), newWidth: imageNewWidth)

            imageData.append((uploadImage1?.pngData())!)
            imageData.append((uploadImage2?.pngData())!)
            imageCount = 2
        }
        else if assets.count == 3 {
            imageView4.image = UIImage(named: "984")
            imageView3.isUserInteractionEnabled = false
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ImageViewController.addImageTapped(tapGestureRecognizer:)))
            imageView4.addGestureRecognizer(tapGestureRecognizer)
            imageView4.isUserInteractionEnabled = true
            
            imageView1.layer.cornerRadius = 11
            imageView2.layer.cornerRadius = 11
            imageView3.layer.cornerRadius = 11
            //9/20 추가
            imageView1.clipsToBounds = true
            imageView2.clipsToBounds = true
            imageView3.clipsToBounds = true
            
            
            imageView1.layer.borderColor = UIColor(rgb: 0x8389BA).cgColor
            imageView2.layer.borderColor = UIColor(rgb: 0x8389BA).cgColor
            imageView3.layer.borderColor = UIColor(rgb: 0x8389BA).cgColor
            
            imageView1.layer.borderWidth = 2
            imageView2.layer.borderWidth = 2
            imageView3.layer.borderWidth = 2
            
            imageView1.image = resizeImage(image: getAssetThumbnail(asset: assets[0]), newWidth: imageNewWidth)
            imageView2.image = resizeImage(image: getAssetThumbnail(asset: assets[1]), newWidth: imageNewWidth)
            imageView3.image = self.resizeImage(image: getAssetThumbnail(asset: assets[2]), newWidth: imageNewWidth)
            
            //9/21 변경, UI가 이렇게 하는게 훨씬 나은거 같아서 ...;; 걍 각각따로 resize 하게 했음
            imageView1.image = resizeDisplaying(image: getAssetThumbnail(asset: assets[0]), newWidth: imageNewWidth)
            imageView2.image = resizeDisplaying(image: getAssetThumbnail(asset: assets[1]), newWidth: imageNewWidth)
            imageView3.image = resizeDisplaying(image: getAssetThumbnail(asset: assets[2]), newWidth: imageNewWidth)
            
            let uploadImage1:UIImage! = resizeImage(image: getAssetThumbnail(asset: assets[0]), newWidth: imageNewWidth)
            let uploadImage2:UIImage! = resizeImage(image: getAssetThumbnail(asset: assets[1]), newWidth: imageNewWidth)
            let uploadImage3:UIImage! = resizeImage(image: getAssetThumbnail(asset: assets[2]), newWidth: imageNewWidth)
            
            imageData.append((uploadImage1?.pngData())!)
            imageData.append((uploadImage2?.pngData())!)
            imageData.append((uploadImage3?.pngData())!)
            imageCount = 3
        }
        else if assets.count == 4 {
            imageView5.image = UIImage(named: "984")
            imageView4.isUserInteractionEnabled = false
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ImageViewController.addImageTapped(tapGestureRecognizer:)))
            imageView5.addGestureRecognizer(tapGestureRecognizer)
            imageView5.isUserInteractionEnabled = true
            
            imageView1.layer.cornerRadius = 11
            imageView2.layer.cornerRadius = 11
            imageView3.layer.cornerRadius = 11
            imageView4.layer.cornerRadius = 11
            //9/20 추가
            imageView1.clipsToBounds = true
            imageView2.clipsToBounds = true
            imageView3.clipsToBounds = true
            imageView4.clipsToBounds = true
            
            imageView1.layer.borderColor = UIColor(rgb: 0x8389BA).cgColor
            imageView2.layer.borderColor = UIColor(rgb: 0x8389BA).cgColor
            imageView3.layer.borderColor = UIColor(rgb: 0x8389BA).cgColor
            imageView4.layer.borderColor = UIColor(rgb: 0x8389BA).cgColor
            
            imageView1.layer.borderWidth = 2
            imageView2.layer.borderWidth = 2
            imageView3.layer.borderWidth = 2
            imageView4.layer.borderWidth = 2
            
//            imageView1.image = resizeImage(image: getAssetThumbnail(asset: assets[0]), newWidth: imageNewWidth)
//            imageView2.image = resizeImage(image: getAssetThumbnail(asset: assets[1]), newWidth: imageNewWidth)
//            imageView3.image = resizeImage(image: getAssetThumbnail(asset: assets[2]), newWidth: imageNewWidth)
//            imageView4.image = resizeImage(image: getAssetThumbnail(asset: assets[3]), newWidth: imageNewWidth)
            
            //9/21 변경, UI가 이렇게 하는게 훨씬 나은거 같아서 ...;; 걍 각각따로 resize 하게 했음
            imageView1.image = resizeDisplaying(image: getAssetThumbnail(asset: assets[0]), newWidth: imageNewWidth)
            imageView2.image = resizeDisplaying(image: getAssetThumbnail(asset: assets[1]), newWidth: imageNewWidth)
            imageView3.image = resizeDisplaying(image: getAssetThumbnail(asset: assets[2]), newWidth: imageNewWidth)
            imageView4.image = resizeDisplaying(image: getAssetThumbnail(asset: assets[3]), newWidth: imageNewWidth)
            
            let uploadImage1:UIImage! = resizeImage(image: getAssetThumbnail(asset: assets[0]), newWidth: imageNewWidth)
            let uploadImage2:UIImage! = resizeImage(image: getAssetThumbnail(asset: assets[1]), newWidth: imageNewWidth)
            let uploadImage3:UIImage! = resizeImage(image: getAssetThumbnail(asset: assets[2]), newWidth: imageNewWidth)
            let uploadImage4:UIImage! = resizeImage(image: getAssetThumbnail(asset: assets[3]), newWidth: imageNewWidth)
            
            imageData.append((uploadImage1?.pngData())!)
            imageData.append((uploadImage2?.pngData())!)
            imageData.append((uploadImage3?.pngData())!)
            imageData.append((uploadImage4?.pngData())!)
            imageCount = 4
        }
        else if assets.count == 5 {
            imageView6.image = UIImage(named: "984")
            imageView5.isUserInteractionEnabled = false
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ImageViewController.addImageTapped(tapGestureRecognizer:)))
            imageView6.addGestureRecognizer(tapGestureRecognizer)
            imageView6.isUserInteractionEnabled = true
            
            imageView1.layer.cornerRadius = 11
            imageView2.layer.cornerRadius = 11
            imageView3.layer.cornerRadius = 11
            imageView4.layer.cornerRadius = 11
            imageView5.layer.cornerRadius = 11
            //9/20 추가
            imageView1.clipsToBounds = true
            imageView2.clipsToBounds = true
            imageView3.clipsToBounds = true
            imageView4.clipsToBounds = true
            imageView5.clipsToBounds = true
            
            
            imageView1.layer.borderColor = UIColor(rgb: 0x8389BA).cgColor
            imageView2.layer.borderColor = UIColor(rgb: 0x8389BA).cgColor
            imageView3.layer.borderColor = UIColor(rgb: 0x8389BA).cgColor
            imageView4.layer.borderColor = UIColor(rgb: 0x8389BA).cgColor
            imageView5.layer.borderColor = UIColor(rgb: 0x8389BA).cgColor
            
            imageView1.layer.borderWidth = 2
            imageView2.layer.borderWidth = 2
            imageView3.layer.borderWidth = 2
            imageView4.layer.borderWidth = 2
            imageView5.layer.borderWidth = 2
            
//            imageView1.image = resizeImage(image: getAssetThumbnail(asset: assets[0]), newWidth: imageNewWidth)
//            imageView2.image = resizeImage(image: getAssetThumbnail(asset: assets[1]), newWidth: imageNewWidth)
//            imageView3.image = resizeImage(image: getAssetThumbnail(asset: assets[2]), newWidth: imageNewWidth)
//            imageView4.image = resizeImage(image: getAssetThumbnail(asset: assets[3]), newWidth: imageNewWidth)
//            imageView5.image = resizeImage(image: getAssetThumbnail(asset: assets[4]), newWidth: imageNewWidth)
//
//            imageData.append((self.imageView1.image?.pngData())!)
//            imageData.append((self.imageView2.image?.pngData())!)
//            imageData.append((self.imageView3.image?.pngData())!)
//            imageData.append((self.imageView4.image?.pngData())!)
//            imageData.append((self.imageView5.image?.pngData())!)
            
            //9/21 변경, UI가 이렇게 하는게 훨씬 나은거 같아서 ...;; 걍 각각따로 resize 하게 했음
            imageView1.image = resizeDisplaying(image: getAssetThumbnail(asset: assets[0]), newWidth: imageNewWidth)
            imageView2.image = resizeDisplaying(image: getAssetThumbnail(asset: assets[1]), newWidth: imageNewWidth)
            imageView3.image = resizeDisplaying(image: getAssetThumbnail(asset: assets[2]), newWidth: imageNewWidth)
            imageView4.image = resizeDisplaying(image: getAssetThumbnail(asset: assets[3]), newWidth: imageNewWidth)
            imageView5.image = resizeDisplaying(image: getAssetThumbnail(asset: assets[4]), newWidth: imageNewWidth)
            
            let uploadImage1:UIImage! = resizeImage(image: getAssetThumbnail(asset: assets[0]), newWidth: imageNewWidth)
            let uploadImage2:UIImage! = resizeImage(image: getAssetThumbnail(asset: assets[1]), newWidth: imageNewWidth)
            let uploadImage3:UIImage! = resizeImage(image: getAssetThumbnail(asset: assets[2]), newWidth: imageNewWidth)
            let uploadImage4:UIImage! = resizeImage(image: getAssetThumbnail(asset: assets[3]), newWidth: imageNewWidth)
            let uploadImage5:UIImage! = resizeImage(image: getAssetThumbnail(asset: assets[4]), newWidth: imageNewWidth)
            
            imageData.append((uploadImage1?.pngData())!)
            imageData.append((uploadImage2?.pngData())!)
            imageData.append((uploadImage3?.pngData())!)
            imageData.append((uploadImage4?.pngData())!)
            imageData.append((uploadImage5?.pngData())!)
            
            imageCount = 5
        }
        else if assets.count == 6 {
            imageView1.layer.cornerRadius = 11
            imageView2.layer.cornerRadius = 11
            imageView3.layer.cornerRadius = 11
            imageView4.layer.cornerRadius = 11
            imageView5.layer.cornerRadius = 11
            imageView6.layer.cornerRadius = 11
            //9/20 추가
            imageView1.clipsToBounds = true
            imageView2.clipsToBounds = true
            imageView3.clipsToBounds = true
            imageView4.clipsToBounds = true
            imageView5.clipsToBounds = true
            imageView6.clipsToBounds = true
            
            imageView1.layer.borderColor = UIColor(rgb: 0x8389BA).cgColor
            imageView2.layer.borderColor = UIColor(rgb: 0x8389BA).cgColor
            imageView3.layer.borderColor = UIColor(rgb: 0x8389BA).cgColor
            imageView4.layer.borderColor = UIColor(rgb: 0x8389BA).cgColor
            imageView5.layer.borderColor = UIColor(rgb: 0x8389BA).cgColor
            imageView6.layer.borderColor = UIColor(rgb: 0x8389BA).cgColor
            
            imageView1.layer.borderWidth = 2
            imageView2.layer.borderWidth = 2
            imageView3.layer.borderWidth = 2
            imageView4.layer.borderWidth = 2
            imageView5.layer.borderWidth = 2
            imageView6.layer.borderWidth = 2
            
//            imageView1.image = resizeImage(image: getAssetThumbnail(asset: assets[0]), newWidth: imageNewWidth)
//            imageView2.image = resizeImage(image: getAssetThumbnail(asset: assets[1]), newWidth: imageNewWidth)
//            imageView3.image = resizeImage(image: getAssetThumbnail(asset: assets[2]), newWidth: imageNewWidth)
//            imageView4.image = self.resizeImage(image: self.getAssetThumbnail(asset: assets[3]), newWidth: imageNewWidth)
//            imageView5.image = self.resizeImage(image: getAssetThumbnail(asset: assets[4]), newWidth: imageNewWidth)
//            imageView6.image = self.resizeImage(image: getAssetThumbnail(asset: assets[5]), newWidth: imageNewWidth)
//            imageData.append((self.imageView1.image?.pngData())!)
//            imageData.append((self.imageView2.image?.pngData())!)
//            imageData.append((self.imageView3.image?.pngData())!)
//            imageData.append((self.imageView4.image?.pngData())!)
//            imageData.append((self.imageView5.image?.pngData())!)
//            imageData.append((self.imageView6.image?.pngData())!)
            
            //9/21 변경, UI가 이렇게 하는게 훨씬 나은거 같아서 ...;; 걍 각각따로 resize 하게 했음
            imageView1.image = resizeDisplaying(image: getAssetThumbnail(asset: assets[0]), newWidth: imageNewWidth)
            imageView2.image = resizeDisplaying(image: getAssetThumbnail(asset: assets[1]), newWidth: imageNewWidth)
            imageView3.image = resizeDisplaying(image: getAssetThumbnail(asset: assets[2]), newWidth: imageNewWidth)
            imageView4.image = resizeDisplaying(image: getAssetThumbnail(asset: assets[3]), newWidth: imageNewWidth)
            imageView5.image = resizeDisplaying(image: getAssetThumbnail(asset: assets[4]), newWidth: imageNewWidth)
            imageView6.image = resizeDisplaying(image: getAssetThumbnail(asset: assets[5]), newWidth: imageNewWidth)
            
            let uploadImage1:UIImage! = resizeImage(image: getAssetThumbnail(asset: assets[0]), newWidth: imageNewWidth)
            let uploadImage2:UIImage! = resizeImage(image: getAssetThumbnail(asset: assets[1]), newWidth: imageNewWidth)
            let uploadImage3:UIImage! = resizeImage(image: getAssetThumbnail(asset: assets[2]), newWidth: imageNewWidth)
            let uploadImage4:UIImage! = resizeImage(image: getAssetThumbnail(asset: assets[3]), newWidth: imageNewWidth)
            let uploadImage5:UIImage! = resizeImage(image: getAssetThumbnail(asset: assets[4]), newWidth: imageNewWidth)
            let uploadImage6:UIImage! = resizeImage(image: getAssetThumbnail(asset: assets[5]), newWidth: imageNewWidth)
            
            imageData.append((uploadImage1?.pngData())!)
            imageData.append((uploadImage2?.pngData())!)
            imageData.append((uploadImage3?.pngData())!)
            imageData.append((uploadImage4?.pngData())!)
            imageData.append((uploadImage5?.pngData())!)
            imageData.append((uploadImage6?.pngData())!)
            print("donedonedone")
            imageCount = 6
        }
    }
    
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        
        option.isSynchronous = true
        
        let scale = 380.0 / Double(asset.pixelWidth)
        let newHeight = Double(asset.pixelHeight) * scale
        
        print("height: \(newHeight)")
        manager.requestImage(for: asset, targetSize: CGSize(width: 380, height: newHeight), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
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
    
//    @IBAction func addImages(_ sender: UIButton) {
//        let vc = BSImagePickerViewController()
//        vc.selectionFillColor = UIColor(rgb: 0x8389BA)
//        vc.selectionShadowColor = .lightGray
//        vc.maxNumberOfSelections = 6
//        bs_presentImagePickerController(vc, animated: true,
//                                        select: { (asset: PHAsset) -> Void in
//                                            // User selected an asset.
//                                            // Do something with it, start upload perhaps?
//        }, deselect: { (asset: PHAsset) -> Void in
//            // User deselected an assets.
//            // Do something, cancel upload?
//        }, cancel: { (assets: [PHAsset]) -> Void in
//            // User cancelled. And this where the assets currently selected.
//        }, finish: { (assets: [PHAsset]) -> Void in
//            self.imageUpdate(assets: assets)
//            // User finished with these assets
//        }, completion: nil)
////        present(self.picker, animated: true, completion: nil)
//    }
    
    @objc func publish(sender: UIButton) {
        if imageView1.image == nil {
            let alertController = UIAlertController(title: "Oops", message:
                "We need at least 1 picture to complete uploading.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            }))
            self.present(alertController, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "Upload", message: "Are you sure you want to publish your property?", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                print("Publish ready")
                
                if let property = self.property {
                    print("Publish ready1")
                    
                    let group = DispatchGroup()
                    self.activityIndicator.startAnimating()
                    group.enter()
                    
                    //                    let queue = DispatchQueue(label: "work")
                    DispatchQueue.global().sync {
                        for (index, element) in self.stationData.enumerated() {
                            let sourceLocation = CLLocationCoordinate2D(latitude: property.address.latitude, longitude: property.address.longitude)
                            let destinationLocation = CLLocationCoordinate2D(latitude: element.latitude, longitude: element.longitude)
                            
                            let sourcePlaceMark = MKPlacemark(coordinate: sourceLocation)
                            let destinationPlaceMark = MKPlacemark(coordinate: destinationLocation)
                            
                            let directionRequest = MKDirections.Request()
                            directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
                            directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
                            directionRequest.transportType = .walking
                            
                            let directions = MKDirections(request: directionRequest)
                            directions.calculate{ (response, error) in
                                guard let directionResponse = response else {
                                    if let error = error {
                                        print("we have error getting directions==\(error.localizedDescription)")
                                    }
                                    return
                                }
                                
                                let route = directionResponse.routes[0]
                                if route.expectedTravelTime <= 900 && self.aroundProperty.time > route.expectedTravelTime{
                                    print("===========================================================")
                                    print(element.displayName, "walk")
                                    print(self.stringFromTimeInterval(interval: route.expectedTravelTime))
                                    print("===========================================================")
                                    self.aroundProperty.placeName = element.displayName
                                    self.aroundProperty.displayedTime = self.stringFromTimeInterval(interval: route.expectedTravelTime) as String
                                    self.aroundProperty.time = route.expectedTravelTime
                                }
                                if self.stationCount == self.stationData.count-1 {
                                    group.leave()
                                }
                                self.stationCount += 1
                            }
                        }
                        
                    }
                    group.notify(queue: DispatchQueue.main) {
                        self.activityIndicator.stopAnimating()
                        // ---------------------------------------------------------------------
                        // Calculating Current Date
                        // ---------------------------------------------------------------------
                        let date = Date()
                        let formatter = DateFormatter()
                        formatter.dateFormat = "dd/MM/yyyy"
                        let currentDate = formatter.string(from: date)
                        
                        let timeStamp = Int(Date().timeIntervalSince1970)
                        print(timeStamp)
                        
                        let data = [
                            //"key" : "",
                            //"propertyImageID" : "",
                            "author" : property.author,
                            "description": property.description,
                            "address" : ["province" : property.address.province,
                                         "city" : property.address.city,
                                         "address" : property.address.address,
                                         "postalCode" : property.address.postalCode,
                                         "latitude" : property.address.latitude,
                                         "longitude" : property.address.longitude
                            ],
                            "price" : property.price,
                            "size" : property.size,
                            "numBed" : property.numBed,
                            "numBath" : (property.numBed == 0) ? 1 : property.numBath, // if numBed == Studio, then numBath automatically 1
                            "cats" : property.cats,
                            "dogs" : property.dogs,
                            "smoking" : property.smoking,
                            "drug" : property.drug,
                            "party" : property.party,
                            "manonly" : property.manonly,
                            "womanonly" : property.womanonly,
                            "both" : property.both,
                            
                            
                            "furnished" : property.furnished,
                            "airCon" : property.airCon,
                            "balcony" : property.balcony,
                            "closet" : property.closet,
                            "dishWash" : property.dishWash,
                            "fridge" : property.fridge,
                            "heater" : property.heater,
//                            "kitchen" : property.kitchen,
                            "laundry" : property.laundry,
                            "parking" : property.parking,
                            "tub" : property.tub,
                            "cableTV" : property.cableTV,
                            "internet" : property.internet,
                            "bed" : property.bed,
                            "tubPublic" : property.tubPublic,
                            "toiletPublic" : property.toiletPublic,
                            "stove" : property.stove,
                            "microwave" : property.microwave,
                            "dryerPublic" : property.dryerPublic,
                            "deskChair" : property.deskChair,
                            "hanger" : property.hanger,
                        
                            
                            "requiredTerm" : property.requiredTerm,
                            "moveInDate" : property.moveInDate,
                            "constructionDate" : property.constructionDate,
                            "hostPhone" : property.hostPhone,
                            "hostEmail" : property.hostEmail,
                            "dateCreated" : currentDate,
                            "timeStamp" : timeStamp,
                            "new" : property.new,
                            "verified": property.verified,
                            "condition" : property.condition,
                            "type" : property.type,
                            "uid" : property.uid,
                            "transportation": ["station" : self.aroundProperty.placeName,
                                               "displayedTime" : self.aroundProperty.displayedTime,
                                               "time" : self.aroundProperty.time]
                            ] as [String : Any]
                        print("Publish ready3")
                        
                        print(data)
                        
                        print("\(property.address.province)")
                        print("\(property.address.city)")
                        var ref: DocumentReference? = nil
                        
                        var imageDataTemp: [String: [[String:String]]] = [
                            "images": []
                        ]
                        
                        ref = self.db.collection("NorthAmerica").document("Canada").collection("BC").addDocument(data: data) { err in
                            if let err = err {
                                print("Error adding document: \(err)")
                            } else {
                                print("Document added with ID: \(ref!.documentID)")
                                let documentID:String = ref!.documentID
                                
                                let storageRef = Storage.storage().reference()
                                
                                let imageGroup = DispatchGroup()
                                self.activityIndicator.startAnimating()
                                imageGroup.enter()
                                
                                for (index, element) in self.imageData.enumerated() {
                                    let imageName = "\(index)"
                                    let riversRef = storageRef.child(documentID + "/" + imageName)
                                    riversRef.putData(element, metadata: nil) { (metadata, error) in
                                        if let err = error {
                                            print("Error - Uploading images. \(err)")
                                        }
                                        
                                        riversRef.downloadURL { (url, error) in
                                            guard let downloadURL = url else {
                                                print("Error - Getting images url")
                                                // Uh-oh, an error occurred!
                                                return
                                            }
                                            print("=======")
                                            print(downloadURL.absoluteString)
                                            print("=======")
                                            let image: [String: String] = [
                                                "url": downloadURL.absoluteString,
                                                "index" : "\(index)"
                                            ]
                                            imageDataTemp["images"]?.append(image)
                                            if imageDataTemp["images"]!.count == self.imageCount {
                                                //                                                print("hhhhhhhhh")
                                                imageGroup.leave()
                                            }
                                        }
                                    }
                                }
                                
                                imageGroup.notify(queue: DispatchQueue.main) {
                                    //                                    print("zzzzzzzz")
                                    self.activityIndicator.stopAnimating()
                                    self.db.collection("NorthAmerica").document("Canada").collection("BC").document(documentID).updateData(imageDataTemp)
                                    let alertController = UIAlertController(title: "Congratulations!", message:
                                        "Your post is now available!", preferredStyle: .alert)
                                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                                        self.dismiss(animated: true, completion: nil)
                                    }))
                                    self.present(alertController, animated: true, completion: nil)
                                }
                            }
                        }
                        
//                        let alertController = UIAlertController(title: "Congratulations!", message:
//                            "Your post is now available!", preferredStyle: .alert)
//                        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
//                            self.dismiss(animated: true, completion: nil)
//                        }))
//                        self.present(alertController, animated: true, completion: nil)
                        
                        //광역변수 초기화
                        PRICE = ""
                        BUILDINGTYPES = [false, false]
                        AMENITIES = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
                        RULES = [false, false, false, false, false, false, false, false]
                        NUMBED = ""
                        NUMBATH = ""
                        SIZEROOM = ""
                        RENTTYPE = ""
                    }
                }
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                return
            }))
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func addImageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        //        let tappedImage = tapGestureRecognizer.view as! UIImageView
        print("imageview clicked ")
        //            present(self.picker, animated: true, completion: nil)
        
        let vc = BSImagePickerViewController()
        vc.selectionFillColor = UIColor(rgb: 0x8389BA)
        vc.selectionShadowColor = .lightGray
        vc.maxNumberOfSelections = 6
        bs_presentImagePickerController(vc, animated: true,
                                        select: { (asset: PHAsset) -> Void in
                                            // User selected an asset.
                                            // Do something with it, start upload perhaps?
        }, deselect: { (asset: PHAsset) -> Void in
            // User deselected an assets.
            // Do something, cancel upload?
        }, cancel: { (assets: [PHAsset]) -> Void in
            // User cancelled. And this where the assets currently selected.
        }, finish: { (assets: [PHAsset]) -> Void in
            self.imageUpdate(assets: assets)
            // User finished with these assets
        }, completion: nil)
        // Your action
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
