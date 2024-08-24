//
//  MapViewController.swift
//  iOS_TWM_APP
//
//  Created by Rowan Su on 2024/8/23.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    let bottomMenu = BottomMenuViewController()
    var userLocation: [Double] = []
    let gymAPI = TaipeiGymAPI()
    var receivedGymDataArray: [Value] = []
    var showGymsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = MKMapView(frame: view.bounds)
        view.addSubview(mapView)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        //        let initialLocation = CLLocation(latitude: 25.038405, longitude:     121.53235)
        //        centerMapOnLocation(location: initialLocation)
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        
        mapView.showsUserLocation = true
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleLocateButtonTappedNotification(_:)), name: NSNotification.Name("LocateButtonTappedNotification"), object: nil)
        
        self.view.addSubview(bottomMenu.view)
    }
    
    
    @objc func handleLocateButtonTappedNotification(_ notification: Notification) {
        let sportsVenueVC = SportsVenueViewController()
        sportsVenueVC.receivedGymDataArray = receivedGymDataArray
        if sportsVenueVC.receivedGymDataArray.count != 0 {
            navigationController?.pushViewController(sportsVenueVC, animated: true)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("LocateButtonTappedNotification"), object: nil)
    }
    
    // 用戶位置授權
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
        case .denied, .restricted:
            print("位置訪問被拒絕或受限。")
        case .notDetermined:
            print("位置訪問狀態尚未確定。")
        @unknown default:
            break
        }
    }
    
    func centerMapOnLocation(location: CLLocation, regionRadius: CLLocationDistance = 2000) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // 大頭針
    func addAnnotationAtCoordinate(coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
    
    

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        centerMapOnLocation(location: location)
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        gymAPI.getLocationDetails(latitude: latitude, longitude: longitude)
        gymAPI.onGymDataReceived = { [weak self] gymDataArray in
            self?.receivedGymDataArray = gymDataArray
            for i in 0...5 {
                let latitude = gymDataArray[i].latLng.components(separatedBy: ",")[0]
                let longitude =  gymDataArray[i].latLng.components(separatedBy: ",")[1]
                let pinLocation = CLLocation(latitude: Double(latitude)!, longitude: Double(longitude)!)
                self?.addAnnotationAtCoordinate(coordinate: pinLocation.coordinate)
            }
        }
        
    }
    
    func getUserLocation() -> [Double] {
        return userLocation
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
