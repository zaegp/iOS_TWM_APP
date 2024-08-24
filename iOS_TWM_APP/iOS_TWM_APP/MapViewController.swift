//
//  MapVC.swift
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
        
        //        addAnnotationAtCoordinate(coordinate: initialLocation.coordinate)
        
        mapView.showsUserLocation = true
        
        showGymsButton = UIButton(type: .system)
        showGymsButton.setTitle("Show Gyms", for: .normal)
        showGymsButton.addTarget(self, action: #selector(showGymsButtonTapped), for: .touchUpInside)
        
        // Add the button to the view
        view.addSubview(showGymsButton)
        showGymsButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            showGymsButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            showGymsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showGymsButton.widthAnchor.constraint(equalToConstant: 120),
            showGymsButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        view.bringSubviewToFront(showGymsButton)
        
        // 大頭針
        //        let pin = MKPointAnnotation()
        //        pin.coordinate = CLLocation(latitude: 25.038405, longitude:     121.53235).coordinate
        //        mapView.addAnnotation(pin)
    }
    
    @objc func showGymsButtonTapped() {
        let sportsVenueVC = SportsVenueViewController()
        sportsVenueVC.receivedGymDataArray = receivedGymDataArray
        if sportsVenueVC.receivedGymDataArray != nil {
            navigationController?.pushViewController(sportsVenueVC, animated: true)
        }
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
    
    //    func addAnnotationAtCoordinate(coordinate: CLLocationCoordinate2D) {
    //        let annotation = MKPointAnnotation()
    //        annotation.title = "My Location"
    //        annotation.coordinate = coordinate
    //        mapView.addAnnotation(annotation)
    //    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        centerMapOnLocation(location: location)
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        gymAPI.getLocationDetails(latitude: latitude, longitude: longitude)
        gymAPI.onGymDataReceived = { [weak self] gymDataArray in
            self?.receivedGymDataArray = gymDataArray
            //            print("Received Gym Data: \(gymDataArray)")
        }
        
    }
    
    func getUserLocation() -> [Double] {
        return userLocation
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
