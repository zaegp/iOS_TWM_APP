//
//  SportsVenue.swift
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
        
        view.backgroundColor = .lightGray
        
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
//                    // 在這裡你可以更新 UI 或者執行其他操作
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
        cell.setFacilities(receivedGymDataArray[indexPath.row].gymFuncList)
        cell.setImage(receivedGymDataArray[indexPath.row].photo1)
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        return screenHeight / CGFloat(numberOfCellsPerPage)
    }
}

