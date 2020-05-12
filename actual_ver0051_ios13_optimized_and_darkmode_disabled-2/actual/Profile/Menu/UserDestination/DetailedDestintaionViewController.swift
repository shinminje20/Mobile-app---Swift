//
//  DetailedDestintaionViewController.swift
//  actual
//
//  Created by Sukkwon On on 2019-08-13.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class DetailedDestintaionViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    var ud : userDestination?
    
    
    @IBOutlet weak var addressTitleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let ud = ud {
            let longTitleLabel = UILabel()
            longTitleLabel.text = ud.name
            longTitleLabel.font = UIFont(name:"FiraSans-Bold",size:20)
            longTitleLabel.textColor = UIColor(rgb: 0x8389BA)
            longTitleLabel.sizeToFit()
            
            self.navigationItem.titleView = longTitleLabel
            
            addressTitleLabel.text = "Address"
            addressTitleLabel.font = UIFont(name:"FiraSans-Bold", size: 20)
            addressLabel.text = ud.address
            addressLabel.font = UIFont(name:"FiraSans", size: 10)
            
            let destinationCoordination:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: ud.latitude, longitude: ud.longitude)
            let region = MKCoordinateRegion(center: destinationCoordination, latitudinalMeters: 500, longitudinalMeters: 500)
            mapView.setRegion(region, animated: false)
            let anno = MKPointAnnotation()
            anno.coordinate = destinationCoordination
            mapView.addAnnotation(anno)
            
            let doneBtn : UIBarButtonItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteDestination))
            self.navigationItem.rightBarButtonItem = doneBtn
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor(rgb: 0x8389BA)
        }

        // Do any additional setup after loading the view.
    }
    
    @objc func deleteDestination(sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        // Delete from CoreData
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserDestinations")
        request.returnsObjectsAsFaults = false
        do {
            let resultListings = try context.fetch(request)
            for listing in resultListings as! [NSManagedObject]{
                
                let initial = listing.value(forKey: "initial") as! String
                let address = listing.value(forKey: "address") as! String
                let latitude = listing.value(forKey: "latitude") as! Double
                let longitude = listing.value(forKey: "longitude") as! Double
                
                if (initial == ud?.name &&
                    address == ud?.address &&
                    latitude == ud!.latitude &&
                    longitude == ud!.longitude) {
                    
                    context.delete(listing)
                    
                    do {
                        // make sure to save the deletion
                        try context.save()
                    } catch {
                        print("Save Error")
                    }
                    dismiss(animated: true, completion: nil)
                    return
                }
            }
        } catch {
            let alertController = UIAlertController(title: "Oops", message:
                "Failed to delete the destination.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            }))
            self.present(alertController, animated: true, completion: nil)
            return
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

}
