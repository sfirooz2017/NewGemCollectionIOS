//
//  MapVC.swift
//  GemApp
//
//  Created by MacBook Pro on 10/19/20.
//  Copyright © 2020 Shannon Firooz. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var tblPlaces: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    var selectedPin:MKPlacemark? = nil
    var mapItemName:String!
    var resultsArray:[Dictionary<String, AnyObject>] = Array()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        sideMenus()
        customizeNavBar()
        
        mapView.delegate = self
        tblPlaces.dataSource = self
        tblPlaces.delegate = self
        
      //  mapView.showAnnotations(mapView.annotations, animated: true)
        configureLocationServices()
      
   
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return resultsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "placecell", for: indexPath) as? mapTableViewCell
        {
            let place = self.resultsArray[indexPath.row]
            cell.updateUi(name: place["name"] as! String, address: place["formatted_address"] as! String)
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: true)
        
        let place = self.resultsArray[indexPath.row]
        if let locationGeometry = place["geometry"] as? Dictionary<String, AnyObject>
        {
            if let location = locationGeometry["location"] as? Dictionary<String, AnyObject>
            {
                
                if let latitude = location["lat"] as? Double
                {
                    if let longitude = location["lng"] as? Double
                    {
                        let l = CLLocation(latitude: latitude, longitude: longitude)
                        let p = MKPlacemark(coordinate: l.coordinate)
                       
                        let mapItem = MKMapItem(placemark: p)
                        mapItem.name = place["name"] as? String
                        zoomToLatestLocation(coordinate: l.coordinate, latRange: 200, longRange: 200)
                     
                    }
                }
            }
        }
    }
    
    private func configureLocationServices()
    {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
        let status = CLLocationManager.authorizationStatus()

        if status == .notDetermined
        {
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
        }
        else if status == .authorizedWhenInUse || status == .authorizedAlways
        {
            locationManager.requestLocation()
            // beginLocationUpdates(locationManager: manager)
        }
        else
        {
            sendAlert(title: "Cannot access", message: "Please turn on Location Services to view nearby stores")
        }
        
    }
    
    private func zoomToLatestLocation(coordinate: CLLocationCoordinate2D, latRange: Double, longRange: Double)
    {
        let zoomRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: longRange, longitudinalMeters: latRange)
        mapView.setRegion(zoomRegion, animated: true)
    }
    
    func addAnnotation(name: String, longitude: Double, latitude: Double)
    {
        let tempAnnotation = MKPointAnnotation()
        tempAnnotation.title = name
        tempAnnotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        mapView.addAnnotation(tempAnnotation)
    }
    
    func loadMapData(latitude: Double, longitude: Double)
    {
        DispatchQueue.main.async
            {
            DataService.globalData.searchPlaceFromGoogle(latitude: latitude, longitude: longitude) { (success, results) in
                if success == true
                {
                
                self.resultsArray.removeAll()
                var x = 0;
                    for dct in results!
                {
                    var dct = dct
                    dct["key"] = x as AnyObject
                    x = x + 1
                    self.resultsArray.append(dct)
                    if let locationGeometry = dct["geometry"] as? Dictionary<String, AnyObject>
                    {
                        if let location = locationGeometry["location"] as? Dictionary<String, AnyObject>
                        {
                            self.addAnnotation(name: dct["name"] as! String, longitude: location["lng"] as! Double, latitude: location["lat"] as! Double)
                        }
                    }
                }
                DispatchQueue.main.sync
                {
                    self.tblPlaces.reloadData()
                 
                }
            }
                else
                {
                    print("couldnt load")
                }
        }
        }
    }
}
extension MapVC: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {

        guard let latestLocation = locations.first else {return}
        
        if currentLocation == nil
        {
            zoomToLatestLocation(coordinate: latestLocation.coordinate, latRange: 10000, longRange: 10000)
        }
        loadMapData(latitude: latestLocation.coordinate.latitude, longitude: latestLocation.coordinate.longitude)
        currentLocation = latestLocation
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        print("status changed")
        configureLocationServices()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print(error)
    }
    func sideMenus()
    {
        if revealViewController() != nil
        {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            view.addGestureRecognizer((self.revealViewController()!.panGestureRecognizer()))
            view.addGestureRecognizer((self.revealViewController()!.tapGestureRecognizer()))
        }
    }
    func customizeNavBar()
    {
        navigationController?.navigationBar.tintColor = UIColor.white
    }
}
extension MapVC: MKMapViewDelegate
{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if annotation is MKUserLocation
        {
            //this way a blue dot shows when on user location
            return nil
        }
        
        let identifier = "AnnotationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil
        {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        }
        else
        {
            annotationView?.annotation = annotation
        }
        
        selectedPin = MKPlacemark(coordinate: annotation.coordinate)
        mapItemName = annotation.title as? String

        annotationView?.image = UIImage(named: "small_dia")
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "directions"), for: .normal)
        button.addTarget(self, action: #selector(MapVC.getDirections), for: .touchUpInside)
        annotationView?.leftCalloutAccessoryView = button
    
        return annotationView

    }
    @objc func getDirections()
    {
        if let selectedPin = selectedPin
        {
            let mapItem = MKMapItem(placemark: selectedPin)
            mapItem.name = mapItemName
            
            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            
            MKMapItem.openMaps(with: [mapItem], launchOptions: launchOptions)
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        if tblPlaces.numberOfRows(inSection: 0) != 0
        {
        let index = resultsArray.filter{ $0["name"] as? String == view.annotation?.title}
        
        let indexP = IndexPath(row: index[0]["key"] as! Int, section: 0)
        tblPlaces.scrollToRow(at: indexP, at: UITableView.ScrollPosition.top, animated: true)
        self.tblPlaces.delegate?.tableView!(self.self.tblPlaces, didSelectRowAt: indexP)
        }
   
    }
}





