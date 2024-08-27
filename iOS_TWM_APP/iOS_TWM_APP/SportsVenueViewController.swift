//
//  SportsVenueViewController.swift
//  iOS_TWM_APP
//
//  Created by Rowan Su on 2024/8/23.
//

import UIKit
import Kingfisher
import CoreLocation

class SportsVenueViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    var receivedGymDataArray: [Value] = []
    var tableView: UITableView!
    let numberOfCellsPerPage = 4
    let gymAPI = TaipeiGymAPI()
    let locationManager = CLLocationManager()
    
    var searchKeywords = String()
    var passKeyWords: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        view.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 1.00)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.backgroundColor = .white
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.statusBarFrame)
            statusBar.backgroundColor = .white
            view.addSubview(statusBar)
            
            
            
            
        }
        
       
        if searchKeywords != "" {
            
            receivedGymDataArray.removeAll{ !($0.name.contains(searchKeywords)) }
            
        }
        
        
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(Cell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        tableView.separatorStyle = .none
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
        tableView.backgroundColor = .clear
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        locationManager.delegate = self
    }
    
    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        

        
        
        if let location = locations.last {
            print("最新的位置: \(location.coordinate.latitude), \(location.coordinate.longitude)")
            
            gymAPI.getLocationDetails(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            
             
                gymAPI.onGymDataReceived = { [weak self] gymDataArray in
                    self?.receivedGymDataArray = gymDataArray
                   
                    if self?.searchKeywords != "" {
                                    
                        self?.receivedGymDataArray.removeAll{ !($0.name.contains(self?.searchKeywords ?? "")) }
                                    
                                }

                    
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                        self?.tableView.refreshControl?.endRefreshing()
                        self?.locationManager.stopUpdatingLocation()
                    }
                }
                
            
                
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("無法獲取位置: \(error.localizedDescription)")
        tableView.refreshControl?.endRefreshing()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return receivedGymDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Cell
        
        if indexPath.row < receivedGymDataArray.count {
            let gymData = receivedGymDataArray[indexPath.row]
            cell.setTitle(gymData.name)
            cell.setLocation(gymData.address)
            cell.setFacilities("場館設施: " + gymData.gymFuncList)
            cell.setImage(gymData.photo1)
        } else {
            cell.setTitle("無數據")
            cell.setLocation("")
            cell.setFacilities("")
        }
        
        return cell
    }
    
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        return screenHeight / CGFloat(numberOfCellsPerPage)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailSportPage = DetailSportsPageViewController()
        detailSportPage.selectGymID = receivedGymDataArray[indexPath.row].gymID
        detailSportPage.gymFuncList = receivedGymDataArray[indexPath.row].gymFuncList

        self.navigationController?.pushViewController(detailSportPage, animated: true)
        
    }
}


