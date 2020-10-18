//
//  MapsControllerViewController.swift
//  GemApp
//
//  Created by MacBook Pro on 10/18/20.
//  Copyright © 2020 Shannon Firooz. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import MapKit
import CoreLocation


class MapsControllerViewController: UIViewController {
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?

    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var preciseLocationZoomLevel: Float = 15.0
    var approximateLocationZoomLevel: Float = 10.0
  
  
    
    
     override func viewDidLoad() {
        super.viewDidLoad()
        let locationManager = CLLocationManager()

    // Ask for Authorisation from the User.
        self.locationManager?.requestAlwaysAuthorization()
    
        // Initialize the location manager.
        //locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
      //  locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self as! CLLocationManagerDelegate
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        placesClient = GMSPlacesClient.shared()
        
        // An array to hold the list of likely places.
       // var likelyPlaces: [GMSPlace] = []
        
        // The currently selected place.
     //   var selectedPlace: GMSPlace?
        
    // For use in foreground
        self.locationManager?.requestWhenInUseAuthorization()
        
        // A default location to use when location permission is not granted.
        let defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)
        
        // Create a map.
       // let zoomLevel = locationManager.accuracyAuthorization == .fullAccuracy ? preciseLocationZoomLevel : approximateLocationZoomLevel
        //let zoomLevel = mapView.camera.zoom
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: 6.0)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        
        // Add the map to the view, hide it until we've got a location update.
        view.addSubview(mapView)
       // mapView.isHidden = true
         locationManager.startUpdatingLocation()
        
        
        /*
    
    if CLLocationManager.locationServicesEnabled() {
        locationManager.delegate = self as! CLLocationManagerDelegate
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    locationManager.startUpdatingLocation()
    }
    }
 
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
 */
    }
}
    
    extension MapsControllerViewController: CLLocationManagerDelegate {
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        let zoomLevel = mapView.camera.zoom
        //let zoomLevel = locationManager.accuracyAuthorization == .fullAccuracy ? preciseLocationZoomLevel : approximateLocationZoomLevel
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: 6.0)
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
        
      //  listLikelyPlaces()
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Check accuracy authorization
        /*
        let accuracy = manager.accuracyAuthorization
        switch accuracy {
        case .fullAccuracy:
            print("Location accuracy is precise.")
        case .reducedAccuracy:
            print("Location accuracy is not precise.")
        @unknown default:
            fatalError()
        }
        */
        // Handle authorization status
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        @unknown default:
            fatalError()
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager?.stopUpdatingLocation()
        print("Error: \(error)")
    }
}
 



