//
//  MapTableViewCell.swift
//  actual
//
//  Created by Sukkwon On on 2019-03-19.
//  Copyright © 2019 Sukkwon On. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import GooglePlaces

class MapTableViewCell: UITableViewCell, MKMapViewDelegate, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    
    // An array to hold the list of likely places.
      var likelyPlaces: [GMSPlace] = []

      // The currently selected place.
      var selectedPlace: GMSPlace?

      // A default location to use when location permission is not granted.
      let defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)

      // Update the map once the user has made their selection.
      @IBAction func unwindToMain(segue: UIStoryboardSegue) {
        // Clear the map.
        mapView.clear()

        // Add a marker to the map.
        if selectedPlace != nil {
          let marker = GMSMarker(position: (self.selectedPlace?.coordinate)!)
          marker.title = selectedPlace?.name
          marker.snippet = selectedPlace?.formattedAddress
          marker.map = mapView
        }

        listLikelyPlaces()
      }

        override func awakeFromNib() {
            super.awakeFromNib()

        // Initialize the location manager.
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self

        placesClient = GMSPlacesClient.shared()

        // Create a map.
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: zoomLevel)
            mapView = GMSMapView.map(withFrame: self.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true

        // Add the map to the view, hide it until we&#39;ve got a location update.
        self.addSubview(mapView)
        mapView.isHidden = true

        listLikelyPlaces()
      }

      // Populate the array with the list of likely places.
      func listLikelyPlaces() {
        // Clean up from previous sessions.
        likelyPlaces.removeAll()

        placesClient.currentPlace(callback: { (placeLikelihoods, error) -&gt; Void in
          if let error = error {
            // TODO: Handle the error.
            print(&quot;Current Place error: \(error.localizedDescription)&quot;)
            return
          }

          // Get likely places and add to the list.
          if let likelihoodList = placeLikelihoods {
            for likelihood in likelihoodList.likelihoods {
              let place = likelihood.place
              self.likelyPlaces.append(place)
            }
          }
        })
      }

      // Prepare the segue.
      override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == &quot;segueToSelect&quot; {
          if let nextViewController = segue.destination as? PlacesViewController {
            nextViewController.likelyPlaces = likelyPlaces
          }
        }
      }
    }

    // Delegates to handle events for the location manager.
    extension MapViewController: CLLocationManagerDelegate {

      // Handle incoming location events.
      func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print(&quot;Location: \(location)&quot;)

        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)

        if mapView.isHidden {
          mapView.isHidden = false
          mapView.camera = camera
        } else {
          mapView.animate(to: camera)
        }

        listLikelyPlaces()
      }

      // Handle authorization for the location manager.
      func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
          print(&quot;Location access was restricted.&quot;)
        case .denied:
          print(&quot;User denied access to location.&quot;)
          // Display the map using the default location.
          mapView.isHidden = false
        case .notDetermined:
          print(&quot;Location status not determined.&quot;)
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
          print(&quot;Location status is OK.&quot;)
        @unknown default:
          fatalError()
        }
      }

      // Handle location manager errors.
      func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print(&quot;Error: \(error)&quot;)
      }
//    @IBOutlet weak var mapView: MKMapView!
//
//    var address: String!
//    var latitude: Double = 0.0
//    var longitude: Double = 0.0
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//
//        mapView.showsUserLocation = true
//        mapView.delegate = self
//
//        // No user interaction
//        self.mapView.isZoomEnabled = false
//        self.mapView.isScrollEnabled = false
//
//        mapView.mapType = MKMapType.standard
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        // Don't want to show a custom image if the annotation is the user's location.
//
////        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
////        annotationView.glyphImage = UIImage(named: "icon_mapMarker")
////        return annotationView
//
//        guard !(annotation is MKUserLocation) else {
//            return nil
//        }
//
//        // Better to make this class property
//        let annotationIdentifier = "AnnotationIdentifier"
//
//        var annotationView: MKAnnotationView?
//        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
//            annotationView = dequeuedAnnotationView
//            annotationView?.annotation = annotation
//        }
//        else {
//            let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
//            av.rightCalloutAccessoryView = UIButton(type: .roundedRect)
//            annotationView = av
//        }
//
//        if let annotationView = annotationView {
//            annotationView.canShowCallout = true
//            annotationView.image = UIImage(named: "icon_mapMarker")
//        }
//
//        return annotationView
//    }
//
//}
//
//extension MKMapView {
//    /// when we call this function, we have already added the annotations to the map, and just want all of them to be displayed.
//    func fitAll() {
//        var zoomRect            = MKMapRect.null;
//        for annotation in annotations {
//            let annotationPoint = MKMapPoint(annotation.coordinate)
//            let pointRect       = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.01, height: 0.01);
//            zoomRect            = zoomRect.union(pointRect);
//        }
//        setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), animated: true)
//    }
//
//    /// we call this function and give it the annotations we want added to the map. we display the annotations if necessary
//    func fitAll(in annotations: [MKAnnotation], andShow show: Bool) {
//        var zoomRect:MKMapRect  = MKMapRect.null
//
//        for annotation in annotations {
//            let aPoint          = MKMapPoint(annotation.coordinate)
//            let rect            = MKMapRect(x: aPoint.x, y: aPoint.y, width: 0.1, height: 0.1)
//
//            if zoomRect.isNull {
//                zoomRect = rect
//            } else {
//                zoomRect = zoomRect.union(rect)
//            }
//        }
//        if(show) {
//            addAnnotations(annotations)
//        }
//        setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100), animated: true)
//    }
//
}
