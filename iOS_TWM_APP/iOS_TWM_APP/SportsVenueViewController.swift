//  SportsVenueViewController.swift
//  iOS_TWM_APP
//
//  Created by Rowan Su on 2024/8/23.
//

import UIKit
import Kingfisher
import CoreLocation

class SportsVenueViewController: UIViewController {
    
    var receivedGymDataArray: [Value] = []
    private var tableView: UITableView!
    private let gymAPI = TaipeiGymAPI()
    private let locationManager = CLLocationManager()
    var searchKeywords = String()
    var passKeyWords: ((String) -> Void)?
    var backgroundImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        setupLocationManager()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in
            self.updateTextForOrientation()
        }
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        
        view.addSubview(backgroundImageView)
        view.backgroundColor = .white
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        backgroundImageView.image = UIImage(named: "sports-background")
        backgroundImageView.alpha = 0.8
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.backgroundColor = .white.withAlphaComponent(0.8)
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.statusBarFrame)
            statusBar.backgroundColor = .white.withAlphaComponent(0.8)
            view.addSubview(statusBar)
        }
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(Cell.self, forCellReuseIdentifier: "cell")
        tableView.layer.cornerRadius = 25
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 210
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            //make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.bottom.equalToSuperview().offset(-30)
        }
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    private func setupLocationManager() {
        locationManager.delegate = self
    }
    
    // MARK: - Orientation Handling
    private func updateTextForOrientation() {
        let isPortrait = UIDevice.current.orientation.isPortrait
        
        for cell in tableView.visibleCells as? [Cell] ?? [] {
            if let indexPath = tableView.indexPath(for: cell) {
                let gymData = receivedGymDataArray[indexPath.row]
                configureCell(cell, with: gymData)
            }
        }
    }

    // MARK: - Refresh Control
    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        locationManager.startUpdatingLocation()
    }

    // MARK: - Cell Configuration
    private func configureCell(_ cell: Cell, with gymData: Value) {
        cell.setTitle(gymData.name)
        cell.setLocation(gymData.address)
        cell.setFacilities("場館設施: " + gymData.gymFuncList)
        cell.setImage(gymData.photo1)
    }
}

// MARK: - UITableViewDataSource
extension SportsVenueViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return receivedGymDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Cell
        let gymData = receivedGymDataArray[indexPath.row]
        configureCell(cell, with: gymData)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
   
}

// MARK: - UITableViewDelegate
extension SportsVenueViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailSportPage = DetailSportsPageViewController()
        let selectedGymData = receivedGymDataArray[indexPath.row]
        detailSportPage.selectGymID = selectedGymData.gymID
        detailSportPage.gymFuncList = selectedGymData.gymFuncList
        navigationController?.pushViewController(detailSportPage, animated: true)
    }
}

// MARK: - CLLocationManagerDelegate
extension SportsVenueViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        gymAPI.getLocationDetails(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        gymAPI.onGymDataReceived = { [weak self] gymDataArray in
            guard let self = self else { return }
            self.receivedGymDataArray = self.filterGymData(gymDataArray)
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.refreshControl?.endRefreshing()
                self.locationManager.stopUpdatingLocation()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("無法獲取位置: \(error.localizedDescription)")
        tableView.refreshControl?.endRefreshing()
    }
    
    // MARK: - Data Filtering
    private func filterGymData(_ gymDataArray: [Value]) -> [Value] {
        guard !searchKeywords.isEmpty else { return gymDataArray }
        return gymDataArray.filter { $0.name.contains(searchKeywords) }
    }
}
