//
//  MapCompareTableViewCell.swift
//  actual
//
//  Created by Sukkwon On on 2019-08-21.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit
import MapKit

class MapCompareTableViewCell: UITableViewCell, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var carLabel: UILabel!
    @IBOutlet weak var p1Label: UILabel!
    @IBOutlet weak var p2Label: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var colorCount = 0;

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        mapView.showsUserLocation = false
        mapView.delegate = self
        
        // No user interaction
        self.mapView.isZoomEnabled = false
        self.mapView.isScrollEnabled = false
        
        mapView.mapType = MKMapType.standard
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = colorCount%2==0 ? UIColor(rgb: 0x7EB2E0) : UIColor(rgb: 0xE59C6F)
        renderer.lineWidth = 4.0
        colorCount += 1
        
        return renderer
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Don't want to show a custom image if the annotation is the user's location.
        
        //        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
        //        annotationView.glyphImage = UIImage(named: "icon_mapMarker")
        //        return annotationView
        
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        // Better to make this class property
        let annotationIdentifier = "AnnotationIdentifier"
        
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            av.rightCalloutAccessoryView = UIButton(type: .roundedRect)
            annotationView = av
        }
        
        if let annotationView = annotationView {
            // Configure your annotation view here
            if annotation.title == "Home 1" {
                annotationView.canShowCallout = true
                annotationView.image = UIImage(named: "compare_anno_1")
            }
            else if annotation.title == "Home 2" {
                annotationView.canShowCallout = true
                annotationView.image = UIImage(named: "compare_anno_2")
            }
            else if annotation.subtitle == "Destination" {
                let annotationMarkerView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
                annotationMarkerView.glyphImage = UIImage(named: "icon_mapMarker")
                return annotationMarkerView
            }
            else {
                annotationView.canShowCallout = true
                annotationView.image = UIImage(named: "icon_mapMarker")
            }
        }
        
        return annotationView
    }
    
}
