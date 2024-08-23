//
//  SportsVenue.swift
//  iOS_TWM_APP
//
//  Created by Rowan Su on 2024/8/23.
//

import UIKit

class SportsVenue: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tableView: UITableView!
    let numberOfCellsPerPage = 4
    

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
                    make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16) // 距离安全区域顶部 16
                    make.leading.equalToSuperview().offset(16) // 距离左边缘 16
                    make.trailing.equalToSuperview().offset(-16) // 距离右边缘 16
                    make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16) // 距离底边缘 16
                }
        tableView.backgroundColor = .clear
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Cell
        cell.setTitle("Title")
        cell.setLocation("Location")
        cell.setFacilities("Facilities")
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        return screenHeight / CGFloat(numberOfCellsPerPage)
    }
}

