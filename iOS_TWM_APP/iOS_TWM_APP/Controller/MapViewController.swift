import UIKit
import MapKit
import CoreLocation
import SnapKit
import Kingfisher

class GymAnnotation: MKPointAnnotation {
    var gymID: Int?
}

var isPush = false

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var mapView: MKMapView!
    var showGymsButton: UIButton!
    var previousVisibleRegion: MKMapRect?
    var regionChangeWorkItem: DispatchWorkItem?
    var locationManager = CLLocationManager()
    let gymAPI = TaipeiGymAPI()
    let bottomMenu = BottomMenuViewController()
    let dataRequestAPI = LoginDataRequest()
    var userLocation: [Double] = []
    var receivedGymDataArray: [Value] = []
    
    let containerView = UIView()
    let pinImageView = UIImageView()
    let deviceNameLabel = UILabel()
    
    var deviceName = String()
    
    let loadingIndicator = UIActivityIndicatorView(style: .large)
    var observer: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView()
        setupLoadingIndicator()
        setupBottomMenu()
        setupLocationManager()
        setupNotificationObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        gymAPI.onGymDataReceived = nil
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup Methods
    private func setupMapView() {
        mapView = MKMapView(frame: view.bounds)
        mapView.showsUserLocation = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        view.accessibilityIdentifier = "MapView"
        view.addSubview(mapView)
    }
    
    private func setupLoadingIndicator() {
        loadingIndicator.center = view.center
        view.addSubview(loadingIndicator)
    }
    
    private func setupBottomMenu() {
        view.addSubview(bottomMenu.view)
        bottomMenu.completeSearchButton.addTarget(self, action: #selector(didTapCompleteSearchButton), for: .touchUpInside)
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        dataRequestAPI.delegate = self
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleLocateButtonTappedNotification(_:)), name: NSNotification.Name("LocateButtonTappedNotification"), object: nil)
        
        observer = NotificationCenter.default.addObserver(forName: Notification.Name("didUpdateMockData"), object: nil, queue: .main) { [weak self] _ in
            self?.handleMockDataUpdate()
        }
    }
    
    // MARK: - Handle Actions
    private func handleMockDataUpdate() {
        guard let data = UserDefaults.standard.data(forKey: "MockData"),
              let mockData = try? JSONDecoder().decode(MockData.self, from: data) else { return }
        
        deviceNameLabel.text = mockData.deviceName
        deviceNameLabel.textColor = getColor(for: mockData.frequency ?? "普通")
    }
    
    private func getColor(for frequency: String) -> UIColor {
        switch frequency {
        case "低功耗":
            return .blue
        case "緊急":
            return .red
        default:
            return .black
        }
    }
    
    @objc func didTapCompleteSearchButton() {
        
        let sportsVenueViewController = SportsVenueViewController()
        
        sportsVenueViewController.searchKeywords = bottomMenu.searchBar.text ?? ""
        
        if bottomMenu.searchBar.text != "" {
            let searchBarArray = gymAPI.gymDataArray
            sportsVenueViewController.receivedGymDataArray = searchBarArray ?? []
            
            sportsVenueViewController.receivedGymDataArray.removeAll{ !($0.name.contains(bottomMenu.searchBar.text ?? "")) }
            self.navigationController?.pushViewController(sportsVenueViewController, animated: true)
            
        } else {
            sportsVenueViewController.receivedGymDataArray = gymAPI.gymDataArray ?? []
            self.navigationController?.pushViewController(sportsVenueViewController, animated: true)
        }
    }
    
    @objc func handleLocateButtonTappedNotification(_ notification: Notification) {
        let centerCoordinate = mapView.centerCoordinate
        
        loadingIndicator.startAnimating()
        
        gymAPI.getLocationDetails(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude)
        gymAPI.onGymDataReceived = { [weak self] gymDataArray in
            self?.loadingIndicator.stopAnimating()
            
            guard let self = self else { return }
            
            let userLocation = CLLocation(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude)
            
            let sortedGymDataArray = gymDataArray.sorted { gym1, gym2 in
                let latLng1 = gym1.latLng.components(separatedBy: ",")
                let latLng2 = gym2.latLng.components(separatedBy: ",")
                let location1 = CLLocation(latitude: Double(latLng1[0])!, longitude: Double(latLng1[1])!)
                let location2 = CLLocation(latitude: Double(latLng2[0])!, longitude: Double(latLng2[1])!)
                return userLocation.distance(from: location1) < userLocation.distance(from: location2)
            }
            
            self.receivedGymDataArray = sortedGymDataArray
            
            let sportsVenueVC = SportsVenueViewController()
            sportsVenueVC.receivedGymDataArray = sortedGymDataArray
            
            if !sortedGymDataArray.isEmpty {
                self.navigationController?.pushViewController(sportsVenueVC, animated: true)
            }
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
        case .denied, .restricted:
            showLocationAccessAlert()
        case .notDetermined:
            print("位置訪問狀態尚未確定。")
        @unknown default:
            break
        }
    }
    
    func showLocationAccessAlert() {
        let alert = UIAlertController(title: "位置權限被拒絕", message: "應用需要訪問您的位置來顯示附近的健身房。請在設置中啓用位置權限。", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "設置", style: .default) { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings)
            }
        })
        present(alert, animated: true)
    }
    
    func centerMapOnLocation(location: CLLocation, regionRadius: CLLocationDistance = 2000) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func addAnnotationAtCoordinate(coordinate: CLLocationCoordinate2D, title: String, gymID: Int, imageURL: URL?) {
        let annotation = GymAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        annotation.gymID = gymID
        
        mapView.addAnnotation(annotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        centerMapOnLocation(location: location)
        locationManager.stopUpdatingLocation()
        
        let visibleRegion = mapView.visibleMapRect
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        loadingIndicator.startAnimating()
        
        gymAPI.getLocationDetails(latitude: latitude, longitude: longitude)
        gymAPI.onGymDataReceived = { [weak self] gymDataArray in
            self?.loadingIndicator.stopAnimating()
            
            self?.receivedGymDataArray = gymDataArray.filter { gym in
                let latLng = gym.latLng.components(separatedBy: ",")
                if let latitude = Double(latLng[0]), let longitude = Double(latLng[1]) {
                    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    let mapPoint = MKMapPoint(coordinate)
                    return visibleRegion.contains(mapPoint)
                }
                return false
            }
            
            for gym in self?.receivedGymDataArray ?? [] {
                let latLng = gym.latLng.components(separatedBy: ",")
                if let latitude = Double(latLng[0]), let longitude = Double(latLng[1]) {
                    let pinLocation = CLLocation(latitude: latitude, longitude: longitude)
                    self?.addAnnotationAtCoordinate(coordinate: pinLocation.coordinate, title: gym.name, gymID: gym.gymID, imageURL: URL(string: gym.photo1))
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let newVisibleRegion = mapView.visibleMapRect
        
        if let previousRegion = previousVisibleRegion {
            let overlap = previousRegion.intersection(newVisibleRegion)
            let overlapPercentage = (overlap.size.width * overlap.size.height) / (newVisibleRegion.size.width * newVisibleRegion.size.height)
            
            if overlapPercentage > 0.7 {
                return
            }
        }
        
        let workItem = DispatchWorkItem { [weak self] in
            self?.updateAnnotationsForVisibleRegion(newVisibleRegion)
            self?.previousVisibleRegion = newVisibleRegion
        }
        
        regionChangeWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        
        updateAnnotationsForVisibleRegion(newVisibleRegion)
        
        previousVisibleRegion = newVisibleRegion
    }
    
    func updateAnnotationsForVisibleRegion(_ visibleRegion: MKMapRect) {
        let centerCoordinate = mapView.centerCoordinate
        
        loadingIndicator.startAnimating()
        
        gymAPI.getLocationDetails(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude)
        
        gymAPI.onGymDataReceived = { [weak self] gymDataArray in
            self?.loadingIndicator.stopAnimating()
            
            guard let self = self else { return }
            let filteredGyms = gymDataArray.filter { gym in
                let latLng = gym.latLng.components(separatedBy: ",")
                if let latitude = Double(latLng[0]), let longitude = Double(latLng[1]) {
                    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    let mapPoint = MKMapPoint(coordinate)
                    return visibleRegion.contains(mapPoint)
                }
                return false
            }
            
            self.receivedGymDataArray = filteredGyms
            var newAnnotations: [MKAnnotation] = []
            print(filteredGyms)
            for gym in filteredGyms {
                let latLng = gym.latLng.components(separatedBy: ",")
                if let latitude = Double(latLng[0]), let longitude = Double(latLng[1]) {
                    let pinLocation = CLLocation(latitude: latitude, longitude: longitude)
                    self.addAnnotationAtCoordinate(coordinate: pinLocation.coordinate, title: gym.name, gymID: gym.gymID, imageURL: URL(string: gym.photo1))
                }
            }
            
            let currentAnnotations = self.mapView.annotations.filter { !($0 is MKUserLocation) }
            
            let annotationsToAdd = newAnnotations.filter { newAnnotation in
                !currentAnnotations.contains { $0.coordinate.latitude == newAnnotation.coordinate.latitude &&
                    $0.coordinate.longitude == newAnnotation.coordinate.longitude }
            }
            self.mapView.addAnnotations(annotationsToAdd)
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
            
            containerView.addSubview(pinImageView)
            containerView.addSubview(deviceNameLabel)
            userLocationView.addSubview(containerView)
            
            pinImageView.snp.makeConstraints { make in
                make.top.leading.trailing.width.equalTo(containerView)
                make.height.equalTo(60)
            }
            
            deviceNameLabel.snp.makeConstraints { make in
                make.width.equalTo(containerView)
                make.top.equalTo(pinImageView.snp.bottom)
                make.bottom.equalTo(containerView)
            }
            
            containerView.snp.makeConstraints { make in
                make.width.equalTo(50)
                make.height.equalTo(90)
                make.center.equalTo(userLocationView)
            }
            
            bottomMenu.passDeviceName = { [weak self] data in
                self?.deviceNameLabel.text = data
                print("1--------------", data)
            }
            
            pinImageView.image = UIImage(named: "pointer-pin")
            deviceNameLabel.font = UIFont.systemFont(ofSize: 12)
            deviceNameLabel.textColor = .black
            deviceNameLabel.textAlignment = .center
            
            return userLocationView
            
            
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "customPin")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customPin")
            annotationView?.canShowCallout = true
            
            if annotation is GymAnnotation {
                let accessoryButton = UIButton(type: .detailDisclosure)
                annotationView?.rightCalloutAccessoryView = accessoryButton
            }
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = UIImage(named: "location-pin")
        annotationView?.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }
        
        
        
        return annotationView
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation as? GymAnnotation {
            print("Annotation Title: \(annotation.title ?? "Unknown")")
            print("Gym ID: \(annotation.gymID ?? 0)")
            
            let detailSportPage = DetailSportsPageViewController()
            detailSportPage.selectGymID = annotation.gymID
            
            if let gymID = annotation.gymID,
               let selectedGymData = receivedGymDataArray.first(where: { $0.gymID == gymID }) {
                detailSportPage.gymFuncList = selectedGymData.gymFuncList
            }
            isPush = false
            detailSportPage.modalPresentationStyle = .formSheet
            present(detailSportPage, animated: true, completion: nil)
        } else {
            print("Annotation or annotation view not found")
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        guard newHeading.headingAccuracy >= 0 else {
            return
        }
        
        let headingDegrees = newHeading.trueHeading > 0 ? newHeading.trueHeading : newHeading.magneticHeading
        let headingRadians = CGFloat(headingDegrees * .pi / 180)
        
        if let userLocationView = mapView.view(for: mapView.userLocation) {
            
            userLocationView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            
            UIView.animate(withDuration: 0.3) {
                userLocationView.layer.setAffineTransform(CGAffineTransform(rotationAngle: headingRadians))
            }
        }
    }
    
    func getMockData() -> String? {
        
        return UserDefaults.standard.string(forKey: "MockData")
    }
    
}


extension MapViewController: LoginDataRequestDelegate {
    
    func didGetMockData(deviceName: String) {
        print("1---", deviceName)
        deviceNameLabel.text = deviceName
        print("1---", deviceNameLabel.text)
    }
    
}
