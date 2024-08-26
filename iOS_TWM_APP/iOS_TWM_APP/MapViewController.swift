//
//  MapViewController.swift
//  iOS_TWM_APP
//
//  Created by Rowan Su on 2024/8/23.
//

import UIKit
import MapKit
import CoreLocation
import SnapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var mapView: MKMapView!
    var showGymsButton: UIButton!
    let locationManager = CLLocationManager()
    let gymAPI = TaipeiGymAPI()
    let bottomMenu = BottomMenuViewController()
    var userLocation: [Double] = []
    var receivedGymDataArray: [Value] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = MKMapView(frame: view.bounds)
        mapView.showsUserLocation = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        
        view.addSubview(mapView)
        view.addSubview(bottomMenu.view)
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleLocateButtonTappedNotification(_:)), name: NSNotification.Name("LocateButtonTappedNotification"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
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
        locationManager.stopUpdatingLocation()
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        gymAPI.getLocationDetails(latitude: latitude, longitude: longitude)
        gymAPI.onGymDataReceived = { [weak self] gymDataArray in
            self?.receivedGymDataArray = gymDataArray
            let count = min(gymDataArray.count, 6)
            for i in 0..<count {
                let latLng = gymDataArray[i].latLng.components(separatedBy: ",")
                if let latitude = Double(latLng[0]), let longitude = Double(latLng[1]) {
                    let pinLocation = CLLocation(latitude: latitude, longitude: longitude)
                    self?.addAnnotationAtCoordinate(coordinate: pinLocation.coordinate)
                }
            }
        }
    }
    
    func getUserLocation() -> [Double] {
        return userLocation
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            let userLocationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "userLocation")
            userLocationView.image = UIImage(named: "personal_pin")
            userLocationView.snp.makeConstraints { make in
                make.width.height.equalTo(40)
            }
            
            return userLocationView
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "customPin")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customPin")
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            annotationView?.annotation = annotation
        }


        annotationView?.image = UIImage(named: "pin")
        annotationView?.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }

        return annotationView
    }
}
