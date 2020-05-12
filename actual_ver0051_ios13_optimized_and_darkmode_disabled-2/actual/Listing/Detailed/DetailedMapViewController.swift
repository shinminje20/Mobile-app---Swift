//
//  DetailedMapViewController.swift
//  actual
//
//  Created by Sukkwon On on 2019-06-23.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit
import MapKit

class DetailedMapViewController: UIViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!
    var coordination:CLLocationCoordinate2D?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let locationCoordination = coordination {
            let region = MKCoordinateRegion(center: locationCoordination, latitudinalMeters: 500, longitudinalMeters: 500)
            mapView.setRegion(region, animated: false)
            let anno = MKPointAnnotation()
            anno.coordinate = locationCoordination
            mapView.addAnnotation(anno)
            
            segmentControl.tintColor = UIColor(rgb: 0x8389BA)
//            UIColor(rgb: 0x659CC1)
        }
    }
    
    @IBAction func indexChanged(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        default:
            break
        }
        
        
    }

}
