//
//  BottomMenuViewController.swift
//  iOS_TWM_APP
//
//  Created by 謝霆 on 2024/8/23.
//

import UIKit

import SnapKit

import Alamofire

class BottomMenuViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        self.view.frame = CGRectMake(0, 720, 393, 132)
        
        configBottomMenuView()
        
        customizeLabels()

        
        
        let userToken = UserDefaults.standard.string(forKey: "userToken")
        
        guard let userToken = userToken else{return}
        
        
        self.getMockData(userToken)
        
                
    }
    
    
    let bottomMenuView = UIView()
    
    var isExpanded: Bool? = false
    
    let recentUpdateLabel = UILabel()
    
    let timeLabel = UILabel()
    
    let dateLabel = UILabel()
    
    let deviceNameLabel = UILabel()
    
    let stepCountLabel = UILabel()
    
    let frequencyLabel = UILabel()
    
    let frequencyValueLabel = UILabel()
    
    let stepCountTextLabel = UILabel()
    
    let stepCountValueLabel = UILabel()
    
    let refreshButton = UIButton()
    
    let refreshButtonContainerView = UIView()
    
    let locateButton = UIButton()
    
    let locateButtonContainerView = UIView()
    
    let searchButton = UIButton()
    
    let searchButtonContainerView = UIView()
    

    let searchTextField = UITextField()
    
    var closeSearchTextFieldButton = UIButton(type: .close)


    let date = Date()
    
    let calendar = Calendar.current

    
    func configBottomMenuView() {
        
        view.addSubview(bottomMenuView)
        
        [recentUpdateLabel, timeLabel, dateLabel, deviceNameLabel, stepCountTextLabel,
         stepCountValueLabel, frequencyLabel, frequencyValueLabel, searchTextField, closeSearchTextFieldButton].forEach {
            bottomMenuView.addSubview($0)
        }
        
        self.bottomMenuView.addSubview(searchButtonContainerView)
        
        self.bottomMenuView.addSubview(locateButtonContainerView)
        
        self.bottomMenuView.addSubview(refreshButtonContainerView)
        
        searchButtonContainerView.isHidden = true
        
        locateButtonContainerView.isHidden = true
        
        refreshButtonContainerView.isHidden = true
        
        searchTextField.isHidden = true
        
        closeSearchTextFieldButton.isHidden = true
        
        refreshButtonContainerView.addSubview(refreshButton)
        
        locateButtonContainerView.addSubview(locateButton)
        
        searchButtonContainerView.addSubview(searchButton)
        
        refreshButton.setImage(UIImage(named: "icons8-refresh-60"), for: .normal)
        
        locateButton.setImage(UIImage(named: "icons8-location-50"), for: .normal)
        
        searchButton.setImage(UIImage(named: "icons8-search-52"), for: .normal)
        
        
        
        bottomMenuView.snp.makeConstraints { make in
            
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            
            make.bottom.equalTo(view)
            
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            
        }
        
        bottomMenuView.layer.cornerRadius = 15
        
        bottomMenuView.backgroundColor = .systemGray5
        
        searchButtonContainerView.backgroundColor = .white
        
        searchButtonContainerView.layer.cornerRadius = 8
        
        searchButtonContainerView.layer.borderColor = UIColor.darkGray.cgColor
        
        locateButtonContainerView.backgroundColor = .white
        
        locateButtonContainerView.layer.cornerRadius = 8
        
        locateButtonContainerView.layer.borderColor = UIColor.darkGray.cgColor
        
        refreshButtonContainerView.backgroundColor = .white
        
        refreshButtonContainerView.layer.cornerRadius = 8
        
        refreshButtonContainerView.layer.borderColor = UIColor.darkGray.cgColor
        
        locateButton.addTarget(self, action: #selector(locateButtonTapped), for: .touchUpInside)
        
        let tapBottomMenuGesture = UITapGestureRecognizer(target: self, action: #selector(didTappedBottomView))
        
        bottomMenuView.addGestureRecognizer(tapBottomMenuGesture)
        
        closeSearchTextFieldButton.addTarget(self, action: #selector(didTapCloseSearchTextFieldButton), for: .touchUpInside)
        

        searchButton.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)

        refreshButton.addTarget(self, action: #selector(tappedRefreshButton), for: .touchUpInside)

        
        //test
        searchButton.addTarget(self, action: #selector(testPush), for: .touchUpInside)
        
        setBottomViewConstraint()
        
    }
    
    func setBottomViewConstraint() {
        
        let commonYAnchor = deviceNameLabel.snp.bottom
        
        
        recentUpdateLabel.snp.makeConstraints { make in
            make.top.equalTo(commonYAnchor).offset(8)
            make.left.equalTo(bottomMenuView.snp.left).offset(40)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(recentUpdateLabel.snp.bottom).offset(8)
            make.left.equalTo(dateLabel.snp.right).offset(4)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(recentUpdateLabel.snp.bottom).offset(18)
            make.left.equalTo(bottomMenuView.snp.left).offset(12)
        }
        
        deviceNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(bottomMenuView.snp.top).offset(25)
            make.centerX.equalTo(bottomMenuView.snp.centerX)
        }
        
        stepCountTextLabel.snp.makeConstraints { make in
            make.top.equalTo(deviceNameLabel.snp.bottom).offset(18)
            make.centerX.equalTo(deviceNameLabel.snp.centerX)
        }
        
        stepCountValueLabel.snp.makeConstraints { make in
            make.centerX.equalTo(stepCountTextLabel.snp.centerX)
            make.top.equalTo(stepCountTextLabel.snp.bottom).offset(8)
        }
        
        frequencyLabel.snp.makeConstraints { make in
            make.top.equalTo(commonYAnchor).offset(8) // Aligning Y with recentUpdateLabel
            make.right.equalTo(bottomMenuView.snp.centerX).offset(155)
        }
        
        frequencyValueLabel.snp.makeConstraints { make in
            make.top.equalTo(frequencyLabel.snp.bottom).offset(8)
            make.centerX.equalTo(bottomMenuView.snp.centerX).offset(140)
        }
        
        stepCountTextLabel.snp.makeConstraints { make in
            make.top.equalTo(commonYAnchor).offset(8) // Aligning Y with recentUpdateLabel
            make.centerX.equalTo(deviceNameLabel.snp.centerX)
        }
        
        refreshButtonContainerView.snp.makeConstraints { make in
            
            make.top.equalTo(recentUpdateLabel.snp.bottom).offset(60)
            
            make.left.equalTo(bottomMenuView.snp.left).offset(30)
            
            make.height.equalTo(60)
            
            make.width.equalTo(60)
            
        }
        
        locateButtonContainerView.snp.makeConstraints { make in
            
            make.top.equalTo(recentUpdateLabel.snp.bottom).offset(60)
            
            make.centerX.equalTo(deviceNameLabel.snp.centerX)
            
            make.height.equalTo(60)
            
            make.width.equalTo(60)
            
        }
        
        searchButtonContainerView.snp.makeConstraints { make in
            
            make.top.equalTo(recentUpdateLabel.snp.bottom).offset(60)
            make.centerX.equalTo(bottomMenuView.snp.centerX).offset(140)
            make.height.equalTo(60)
            make.width.equalTo(60)
        }
        
        searchButton.snp.makeConstraints { make in
            
            make.centerX.equalTo(searchButtonContainerView.snp.centerX)
            
            make.centerY.equalTo(searchButtonContainerView.snp.centerY)
            
        }
        
        refreshButton.snp.makeConstraints { make in
            
            make.centerX.equalTo(refreshButtonContainerView.snp.centerX)
            
            make.centerY.equalTo(refreshButtonContainerView.snp.centerY)
            
        }
        
        locateButton.snp.makeConstraints { make in
            
            make.centerX.equalTo(locateButtonContainerView.snp.centerX)
            
            make.centerY.equalTo(locateButtonContainerView.snp.centerY)
            
        }
        
    }
    
    
    func customizeLabels() {
        let hour = calendar.component(.hour, from: date)
        
        let minutes = calendar.component(.minute, from: date)
        
        recentUpdateLabel.text = "最近更新"
//        timeLabel.text = "\(hour):\(minutes)"
//        dateLabel.text = "\(Calendar.current)"
        deviceNameLabel.text = "DeviceName"
        stepCountTextLabel.text = "今日步數"
        stepCountValueLabel.text = "0"
        frequencyLabel.text = "頻率"
        frequencyValueLabel.text = "一般"
        
        recentUpdateLabel.textColor = .systemGray
        
        stepCountTextLabel.textColor = .systemGray
        
        frequencyLabel.textColor = .systemGray
        
        // Customize fonts, colors, and alignment as needed
        recentUpdateLabel.font = .systemFont(ofSize: 14)
        stepCountTextLabel.font = .systemFont(ofSize: 14)
        frequencyLabel.font = .systemFont(ofSize: 14)
        timeLabel.font = .systemFont(ofSize: 24)
        stepCountValueLabel.font = .systemFont(ofSize: 24)
        frequencyValueLabel.font = .systemFont(ofSize: 24)
        deviceNameLabel.font = .systemFont(ofSize: 24)
        dateLabel.font = .systemFont(ofSize: 12)
        
    }
    
    @objc func locateButtonTapped() {
        NotificationCenter.default.post(name: NSNotification.Name("LocateButtonTappedNotification"), object: nil)
    }
    
    
    @objc func didTapSearchButton() {
        
        searchTextField.isHidden = false
        closeSearchTextFieldButton.isHidden = false
        
        self.view.frame = CGRectMake(0, 560, 393, 292)
        
        self.deviceNameLabel.snp.updateConstraints { make in
            make.centerY.equalTo(bottomMenuView.snp.top).offset(105)
        }
        
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(bottomMenuView).offset(25)
            make.width.equalTo(bottomMenuView).multipliedBy(0.8)
            make.height.equalTo(40)
            make.leading.equalTo(bottomMenuView).offset(20)
        }
        
        closeSearchTextFieldButton.snp.makeConstraints { make in
            make.width.equalTo(15)
            make.height.equalTo(15)
            make.leading.equalTo(searchTextField.snp.trailing).offset(20)
            make.centerY.equalTo(searchTextField)
        }
        
        searchTextField.backgroundColor = .white
        searchTextField.layer.cornerRadius = 10
        searchTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: searchTextField.frame.height))
        searchTextField.leftViewMode = .always
        searchTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: searchTextField.frame.height))
        searchTextField.rightViewMode = .always
        
        self.view.layoutIfNeeded()
        
    }
    
    @objc func didTapCloseSearchTextFieldButton() {
        
        searchTextField.isHidden = true
        closeSearchTextFieldButton.isHidden = true
        
        self.view.frame = CGRectMake(0, 640, 393, 212)
        
        self.deviceNameLabel.snp.updateConstraints { make in
            make.centerY.equalTo(bottomMenuView.snp.top).offset(25)
        }
    }
    

    @objc func didTappedBottomView() {
        
        searchTextField.isHidden = true
        closeSearchTextFieldButton.isHidden = true
        
        self.deviceNameLabel.snp.updateConstraints { make in
            make.centerY.equalTo(bottomMenuView.snp.top).offset(25)
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            if self.isExpanded == false {
                
                self.view.frame = CGRectMake(0, 640, 393, 212)
                
                self.searchButtonContainerView.isHidden = false
                
                self.locateButtonContainerView.isHidden = false
                
                self.refreshButtonContainerView.isHidden = false
                
                self.isExpanded = true
            } else {
                
                self.view.frame = CGRectMake(0, 720, 393, 132)
                
                self.searchButtonContainerView.isHidden = true
                
                self.locateButtonContainerView.isHidden = true
                
                self.refreshButtonContainerView.isHidden = true
                
                self.isExpanded = false
                
            }
            self.view.layoutIfNeeded()  // Apply the constraint changes
        })
        
        
    }


    @objc func tappedRefreshButton () {
        
        let userToken = UserDefaults.standard.string(forKey: "userToken")
        
        
        guard let userToken = userToken else {
            
            print("userToken not found")
            
            return}
            
        self.getMockData(userToken)
            
        
        
    }
    
    @objc func getMockData(_ token: String) {
        let headers: HTTPHeaders = [
             "Authorization": "Bearer \(token)",
             "accept": "application/json"
         ]
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)

         AF.request("https://fastapi-production-a532.up.railway.app/Info/",
                    method: .get, headers: headers).responseData { response in
             switch response.result {
             case .success(let data):
                 do {
                     let decoder = JSONDecoder()
                     let decodeData = try decoder.decode(MockData.self, from: data)
                     print("MockData Response: \(decodeData)")
                     
                     let formatter = DateFormatter()
                     formatter.dateFormat = "MM/dd"
                     
                     self.dateLabel.text = formatter.string(from: self.date)
                     self.timeLabel.text = String(format: "%02d:%02d", hour, minutes)
                     self.deviceNameLabel.text = decodeData.deviceName
                     self.stepCountValueLabel.text = String(decodeData.step)
                     
//                     self.group.leave()
                     
                 } catch let decodingError {
                     print("Decoding Error: \(decodingError)")
                 }
             case .failure(let error):
                 print("Error: \(error)")
             }
         }
     }
    
    @objc func testPush() {
        self.navigationController?.pushViewController(SportsVenueViewController(), animated: true)
    }

    
        
//        @objc func didTappedBottomView() {
//            
//            UIView.animate(withDuration: 0.3, animations: {
//                if self.isExpanded == false {
//                    
//                    self.view.frame = CGRectMake(0, 640, 393, 212)
//                    
//                        self.searchButtonContainerView.isHidden = false
//                        
//                        self.locateButtonContainerView.isHidden = false
//                        
//                        self.refreshButtonContainerView.isHidden = false
//                    
//                    self.isExpanded = true
//                } else {
//                    
//                    self.view.frame = CGRectMake(0, 720, 393, 132)
//                    
//                    self.searchButtonContainerView.isHidden = true
//
//                    self.locateButtonContainerView.isHidden = true
//
//                    self.refreshButtonContainerView.isHidden = true
//                    
//                    self.isExpanded = false
//                    
//                }
//                self.view.layoutIfNeeded()  // Apply the constraint changes
//            })
//            
//           
//        }
}
