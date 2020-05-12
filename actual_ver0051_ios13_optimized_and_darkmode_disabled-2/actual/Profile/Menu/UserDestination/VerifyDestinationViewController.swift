//
//  VerifyDestinationViewController.swift
//  actual
//
//  Created by Sukkwon On on 2019-08-12.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class VerifyDestinationViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var coordination:CLLocationCoordinate2D?
    var initial:String?
    var address:String?

    
    @objc func done(sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "UserDestinations", in: context)
        let newListing = NSManagedObject(entity: entity!, insertInto: context)
        
        newListing.setValue(initial, forKey: "initial")
        newListing.setValue(address, forKey: "address")
        newListing.setValue(coordination?.latitude, forKey: "latitude")
        newListing.setValue(coordination?.longitude, forKey: "longitude")

        do {
            // make sure to save the addition
            try context.save()
        } catch {
            print("Failed saving")
        }
        
        print(coordination!.latitude)

        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let locationCoordination = coordination {
            let region = MKCoordinateRegion(center: locationCoordination, latitudinalMeters: 500, longitudinalMeters: 500)
            mapView.setRegion(region, animated: false)
            let anno = MKPointAnnotation()
            anno.coordinate = locationCoordination
            mapView.addAnnotation(anno)
            
            let doneBtn : UIBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done))
            self.navigationItem.rightBarButtonItem = doneBtn
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor(rgb: 0x8389BA)
            //            UIColor(rgb: 0x659CC1)
        }
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
