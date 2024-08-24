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
    
    let bottomMenu = BottomMenuViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = MKMapView(frame: view.bounds)
        view.addSubview(mapView)

        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        let initialLocation = CLLocation(latitude: 25.038405, longitude:     121.53235)
        centerMapOnLocation(location: initialLocation)

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

//        addAnnotationAtCoordinate(coordinate: initialLocation.coordinate)
        
        mapView.showsUserLocation = true
        
        // 大頭針
//        let pin = MKPointAnnotation()
//        pin.coordinate = CLLocation(latitude: 25.038405, longitude:     121.53235).coordinate
//        mapView.addAnnotation(pin)
        
        self.view.addSubview(bottomMenu.view)
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
        print("User's location: Latitude \(latitude), Longitude \(longitude)")
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
