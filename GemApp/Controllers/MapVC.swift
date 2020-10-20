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
    var selectedPin:MKPlacemark? = nil
    var mapItemName:String!
    
    var resultsArray:[Dictionary<String, AnyObject>] = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.showAnnotations(mapView.annotations, animated: true)
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
        locationManager.requestLocation()
        //locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        
        
        //  locationManager(locationManager, didChangeAuthorization: CLLocationManager.authorizationStatus())
        
        //locationManager.requestWhenInUseAuthorization()
        //configureLocationServices()
        
        tblPlaces.dataSource = self
        tblPlaces.delegate = self
        tblPlaces.reloadData()
        
        searchPlaceFromGoogle(longitude: "", latitude: "String")
        
        // tblPlaces.estimatedRowHeight = 100.0
        //  tblPlaces.rowHeight = UITableView.automaticDimension
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    //MARK:- UITableViewDataSource and UItableViewDelegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "placecell", for: indexPath) as? mapTableViewCell{
            
              let place = self.resultsArray[indexPath.row]
            
          //  print("shan\(indexPath.row)")
          //  print("shan\(resultsArray[indexPath.row]["name"])")
            /*
            let x = resultsArray.filter{ $0["name"] === place["name"]
                
            }
            print(x[0]["name"])
          */
            
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
                        //                        addAnnotation(name: place["name"] as! String, longitude: longitude, latitude: latitude)
                        
                        
                        let mapItem = MKMapItem(placemark: p)
                        mapItem.name = place["name"] as? String
                        
                        let viewRegion = MKCoordinateRegion(center: l.coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
                        mapView.setRegion(viewRegion, animated: true)
                        
                        /*
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                        
                        MKMapItem.openMaps(with: [mapItem], launchOptions: launchOptions)
                         */
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
        DispatchQueue.main.async {
            
            
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if error == nil{
                    
                    let jsonDict = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    if let dict = jsonDict as? Dictionary<String, AnyObject>{
                        if let results = dict["results"] as? [Dictionary<String, AnyObject>]
                        {
                            self.resultsArray.removeAll()
                            var x = 0;
                            for dct in results{
                                var dct = dct
                                dct["key"] = x as AnyObject
                                x = x + 1
                                self.resultsArray.append(dct)
                                if let locationGeometry = dct["geometry"] as? Dictionary<String, AnyObject> {
                                    if let location = locationGeometry["location"] as? Dictionary<String, AnyObject> {
                                        self.addAnnotation(name: dct["name"] as! String, longitude: location["lng"] as! Double, latitude: location["lat"] as! Double)
                                        
                                    }
                                }
                            }
                            DispatchQueue.main.sync {
                                
                                
                                self.tblPlaces.reloadData()
                            }
                        }
                    }
                }
            }
            
            task.resume()
        }
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
            locationManager.requestLocation()
            // beginLocationUpdates(locationManager: manager)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
extension MapVC: MKMapViewDelegate
{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
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
       // annotationView?.tintColor = .black
        
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "directions"), for: .normal)
        button.addTarget(self, action: #selector(MapVC.getDirections), for: .touchUpInside)
        annotationView?.leftCalloutAccessoryView = button
      
 
        return annotationView
        /*
         
         if annotationView == nil{
         annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
         }
         
         return annotationView
         */
        
        
    }
    @objc func getDirections()
    {
        if let selectedPin = selectedPin{
            let mapItem = MKMapItem(placemark: selectedPin)
            mapItem.name = mapItemName
            
            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            
            MKMapItem.openMaps(with: [mapItem], launchOptions: launchOptions)
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("hi")
        let index = resultsArray.filter{ $0["name"] as! String == mapItemName 
            
        }
        let indexP = IndexPath(row: index[0]["key"] as! Int, section: 0)
        print(indexP)
        tblPlaces.scrollToRow(at: indexP, at: UITableView.ScrollPosition.top, animated: true)
        // selectedPin = MKPlacemark(coordinate: view.annotation.coordinate)
        
        //     selectedPin = view.annotation
        
        //  let region = MKCoordinateRegion(view.annotation!.coordinate)
        
        //Make(view.annotation!.coordinate, MKCoordinateSpanMake(0, 0.05))
        
        //   mapView.setRegion(region, animated: true)
    }
}



