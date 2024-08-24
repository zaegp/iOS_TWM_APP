//
//  SportsVenueViewController.swift
//  iOS_TWM_APP
//
//  Created by Rowan Su on 2024/8/23.
//

import UIKit
import Kingfisher

class SportsVenueViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var receivedGymDataArray: [Value] = []
    var tableView: UITableView!
    let numberOfCellsPerPage = 4
    let gymAPI = TaipeiGymAPI()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 1.00)
        
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
        
//        let taipeiGymAPI = TaipeiGymAPI()
//                taipeiGymAPI.onGymDataReceived = { [weak self] gymDataArray in
//                    self?.receivedGymDataArray = gymDataArray
//                    print("Received Gym Data: \(gymDataArray)")
//                }
//                self.present(taipeiGymAPI, animated: true, completion: nil)
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Cell
        print(receivedGymDataArray)
        cell.setTitle(receivedGymDataArray[indexPath.row].name)
        cell.setLocation(receivedGymDataArray[indexPath.row].address)
        cell.setFacilities("場館設施: " + receivedGymDataArray[indexPath.row].gymFuncList)
        cell.setImage(receivedGymDataArray[indexPath.row].photo1)
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
        self.navigationController?.pushViewController(detailSportPage, animated: true)
        
    }
}

