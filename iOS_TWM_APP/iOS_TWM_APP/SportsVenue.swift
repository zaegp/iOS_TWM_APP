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
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(Cell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        tableView.backgroundColor = .black
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

