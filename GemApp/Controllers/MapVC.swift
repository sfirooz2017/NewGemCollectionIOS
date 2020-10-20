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
    
    @IBOutlet weak var tblPlaces: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    private let locationManager = CLLocationManager()
    private var currentCoordinate: CLLocationCoordinate2D?
    
    var resultsArray:[Dictionary<String, AnyObject>] = Array()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        
        
       // locationManager(locationManager, didChangeAuthorization: CLLocationManager.authorizationStatus())
        
        //locationManager.requestWhenInUseAuthorization()
        //configureLocationServices()

        
        searchPlaceFromGoogle(longitude: "", latitude: "String")
        
       // tblPlaces.estimatedRowHeight = 100.0
      //  tblPlaces.rowHeight = UITableView.automaticDimension
        tblPlaces.dataSource = self
        tblPlaces.delegate = self
        tblPlaces.reloadData()

        // Do any additional setup after loading the view.
    }
    
    
    
    
    //MARK:- UITableViewDataSource and UItableViewDelegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    if let cell = tableView.dequeueReusableCell(withIdentifier: "placecell", for: indexPath) as? mapTableViewCell{
        
        let place = self.resultsArray[indexPath.row]
        
        cell.updateUi(name: place["name"] as! String, address: place["formatted_address"] as! String)
          return cell
        
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let place = self.resultsArray[indexPath.row]
        if let locationGeometry = place["geometry"] as? Dictionary<String, AnyObject> {
            if let location = locationGeometry["location"] as? Dictionary<String, AnyObject> {
                if let latitude = location["lat"] as? Double {
                    if let longitude = location["lng"] as? Double {
                        let l = CLLocation(latitude: latitude, longitude: longitude)
                        let p = MKPlacemark(coordinate: l.coordinate)
                        addAnnotation(name: place["name"] as! String, longitude: longitude, latitude: latitude)

                        let mapItem = MKMapItem(placemark: p)
                        mapItem.name = place["name"] as? String
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                        
                        MKMapItem.openMaps(with: [mapItem], launchOptions: launchOptions)
                        /*
                        let location = CLLocation(latitude: locationInfo.latitude, longitude: locationInfo.longitude)
                        
                        let placemark = MKPlacemark(coordinate: location.coordinate, addressDictionary: nil)
                        let mapItem = MKMapItem(placemark: placemark)
                        mapItem.name = locationInfo.name
                        
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                        
                        MKMapItem.openMaps(with: [mapItem], launchOptions: launchOptions)
                    */
                        //UIApplication.shared.open(URL(string: "https://www.google.com/maps/@\(latitude),\(longitude),16z")!, options: [:])
                    }
                }
            }
        }
    }
/*
    private func configureLocationServices()
    {
        locationManager.delegate = self
        let status = CLLocationManager.authorizationStatus()

        print("shan \(status)")
        if status == .notDetermined
        {
            locationManager.requestAlwaysAuthorization()
        }
        else if status == .authorizedAlways || status == .authorizedWhenInUse
        {
            beginLocationUpdates(locationManager: locationManager)
        }
        
    }
 */
    private func beginLocationUpdates(locationManager: CLLocationManager)
    {
        print("shan: REACHED")
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    private func zoomToLatestLocation(with coordinate: CLLocationCoordinate2D)
    {
        let zoomRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(zoomRegion, animated: true)
    }

    func addAnnotation(name: String, longitude: Double, latitude: Double)
    {
        let tempAnnotation = MKPointAnnotation()
        tempAnnotation.title = name
        tempAnnotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        mapView.addAnnotation(tempAnnotation)
    }
    
    
    func searchPlaceFromGoogle(longitude : String, latitude : String )
    {
        var strGoogleApi = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=rock+shop&type=store&location=40.7516341,-73.6991966&radius=1000&key=AIzaSyBMpZHmT0fNvIpFafdv9vX7YutC-pYoCeQ"
        
        //"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=40.7516341,-73.6991966&radius=15000&name=rock&key=AIzaSyBMpZHmT0fNvIpFafdv9vX7YutC-pYoCeQ"
        
        //"https://www.maps.googleapis.com/maps/api/place/textsearch/json?query=dunkin&key=AIzaSyCeLTyRdml-US03Ct8I6TKuiMAZSHBsX34"
        
        //rock+shop/@40.7516341,-73.6991966,9z/data=!3m1!4b1"
        
        //"https://www.google.com/maps/search/rock+shop/@(longitude),(latitude),10z/data=!3m1!4b1"
        strGoogleApi = strGoogleApi.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        var urlRequest = URLRequest(url: URL(string : strGoogleApi)!)
        urlRequest.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error == nil{
                let jsonDict = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                if let dict = jsonDict as? Dictionary<String, AnyObject>{
                    if let results = dict["results"] as? [Dictionary<String, AnyObject>]
                    {
                        self.resultsArray.removeAll()
                        for dct in results{
                            self.resultsArray.append(dct)
                        }
                        self.tblPlaces.reloadData()
                    }
                }
                print (jsonDict)
            }
            }
        task.resume()
        }
    }
extension MapVC: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("did get latest location")
        
       guard let latestLocation = locations.first else {return}
        
        if currentCoordinate == nil{
            zoomToLatestLocation(with: latestLocation.coordinate)
            //addAnnotations
        }
        currentCoordinate = latestLocation.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("status changed")
        if status == .notDetermined
        {
            locationManager.requestAlwaysAuthorization()
        }
       else if status == .authorizedWhenInUse || status == .authorizedAlways
        {
            beginLocationUpdates(locationManager: manager)
        }
    }
}
extension MapVC: MKMapViewDelegate
{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
        
        if annotationView == nil{
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
        }
            annotationView?.canShowCallout = true
            return annotationView
        
        
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("hi")
    }
}


