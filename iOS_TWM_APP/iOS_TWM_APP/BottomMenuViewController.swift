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
        
        self.view.frame = CGRectMake(0, screenSize.height * 0.8 , screenSize.width, screenSize.height * 0.85)
        
        configBottomMenuView()
        
        customizeLabels()

        timer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(repeatGetMockData), userInfo: nil, repeats: true)
        tappedRefreshButton()
        
        let userToken = UserDefaults.standard.string(forKey: "userToken")
        
        guard let userToken = userToken else{return}
        
        
        self.getMockData(userToken)
                
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        timer?.invalidate()
        timer = nil
    }

    
    var timer: Timer?

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        passDeviceName?(deviceNameLabel.text ?? "")
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
    
    let screenSize: CGRect = UIScreen.main.bounds

    let searchBar = UISearchBar()
    
    var completeSearchButton = UIButton(type: .system)

    var window: UIWindow?
    
    
    
   
    
    var passDeviceName: ((String) -> Void)?

    
    func configBottomMenuView() {
        
        view.addSubview(bottomMenuView)
        
        [recentUpdateLabel, timeLabel, dateLabel, deviceNameLabel, stepCountTextLabel,
         stepCountValueLabel, frequencyLabel, frequencyValueLabel, searchBar, completeSearchButton].forEach {
            bottomMenuView.addSubview($0)
        }
        
        self.bottomMenuView.addSubview(searchButtonContainerView)
        
        self.bottomMenuView.addSubview(locateButtonContainerView)
        
        self.bottomMenuView.addSubview(refreshButtonContainerView)
        
        searchButtonContainerView.isHidden = true
        
        locateButtonContainerView.isHidden = true
        
        refreshButtonContainerView.isHidden = true
        
        searchBar.isHidden = true
        
        completeSearchButton.isHidden = true
        
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
        
        searchButton.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)

        refreshButton.addTarget(self, action: #selector(tappedRefreshButton), for: .touchUpInside)

        //completeSearchButton.addTarget(self, action: #selector(didTapCompleteSearchButton), for: .touchUpInside)
        //test
//        locateButton.addTarget(self, action: #selector(testPush), for: .touchUpInside)
        
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
            
            make.top.equalTo(recentUpdateLabel.snp.bottom).offset(screenSize.width * 0.15)
            
            make.left.equalTo(bottomMenuView.snp.left).offset(30)
            
            make.height.equalTo(screenSize.width * 0.15)
            
            make.width.equalTo(screenSize.width * 0.15)
            
        }
        
        locateButtonContainerView.snp.makeConstraints { make in
            
            make.top.equalTo(recentUpdateLabel.snp.bottom).offset(screenSize.width * 0.15)
            
            make.centerX.equalTo(deviceNameLabel.snp.centerX)
            
            make.height.equalTo(screenSize.width * 0.15)
            
            make.width.equalTo(screenSize.width * 0.15)
            
        }
        
        searchButtonContainerView.snp.makeConstraints { make in
            
            make.top.equalTo(recentUpdateLabel.snp.bottom).offset(screenSize.width * 0.15)
            make.centerX.equalTo(bottomMenuView.snp.centerX).offset(140)
            make.height.equalTo(screenSize.width * 0.15)
            make.width.equalTo(screenSize.width * 0.15)
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
        
        let calendar = Calendar.current
        
        let date = Date()
        
        let hour = calendar.component(.hour, from: date)
        
        let minutes = calendar.component(.minute, from: date)
        
        recentUpdateLabel.text = "最近更新"
//        timeLabel.text = "\(hour):\(minutes)"
//        dateLabel.text = "\(Calendar.current)"
        deviceNameLabel.text = "DeviceName"
        stepCountTextLabel.text = "今日步數"
        stepCountValueLabel.text = "0"
        frequencyLabel.text = "頻率"
//        frequencyValueLabel.text = "一般"
        
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
    
    @objc func repeatGetMockData() {
        
        let userToken = UserDefaults.standard.string(forKey: "userToken")
        
        
        guard let userToken = userToken else {
            
            print("userToken not found")
            
            return}
            
        getMockData(userToken)
    }
    
    @objc func locateButtonTapped() {
        NotificationCenter.default.post(name: NSNotification.Name("LocateButtonTappedNotification"), object: nil)
    }
    
    
    @objc func didTapSearchButton() {
        
        searchBar.isHidden = false
        completeSearchButton.isHidden = false
        completeSearchButton.isEnabled = true
        
        self.view.frame = CGRectMake(0, screenSize.height * 0.60, screenSize.width, screenSize.height * 0.4)
        
        self.deviceNameLabel.snp.updateConstraints { make in
            make.centerY.equalTo(bottomMenuView.snp.top).offset(105)
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(bottomMenuView).offset(25)
            make.width.equalTo(bottomMenuView).multipliedBy(0.77)
            make.height.equalTo(40)
            make.leading.equalTo(bottomMenuView).offset(20)
        }
        
        completeSearchButton.snp.makeConstraints { make in
            make.width.equalTo(40)
            make.height.equalTo(30)
            make.trailing.equalTo(bottomMenuView.snp.trailing).offset(-15)
            make.centerY.equalTo(searchBar)
        }
        
        searchBar.text = ""
        searchBar.backgroundColor = .white
        searchBar.searchBarStyle = .minimal
        searchBar.layer.cornerRadius = 10
        searchBar.searchTextField.textColor = .black
        
        completeSearchButton.setTitle("完成", for: .normal)
        completeSearchButton.setTitleColor(.systemBlue, for: .normal)
        
        
        
        self.view.layoutIfNeeded()
        
    }
    
    
    
    @objc func didTapCompleteSearchButton() {

        SportsVenueViewController().passKeyWords?(searchBar.text ?? "")
        

    }
    

    @objc func didTappedBottomView() {
        
        searchBar.isHidden = true
        completeSearchButton.isHidden = true
        
        self.deviceNameLabel.snp.updateConstraints { make in
            make.centerY.equalTo(bottomMenuView.snp.top).offset(25)
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            if self.isExpanded == false {
                
                self.view.frame = CGRectMake(0, self.screenSize.height * 0.7, self.screenSize.width, self.screenSize.height * 0.35)
                
                self.searchButtonContainerView.isHidden = false
                
                self.locateButtonContainerView.isHidden = false
                
                self.refreshButtonContainerView.isHidden = false
                
                self.searchButtonContainerView.transform = .identity
                self.locateButtonContainerView.transform = .identity
                self.refreshButtonContainerView.transform = .identity
                
                self.isExpanded = true
            } else {
                
                self.view.frame = CGRectMake(0, self.screenSize.height * 0.8, self.screenSize.width, self.screenSize.height * 0.25)
                
                self.searchButtonContainerView.transform = CGAffineTransform(translationX: 0, y: 60)
                self.locateButtonContainerView.transform = CGAffineTransform(translationX: 0, y: 60)
                self.refreshButtonContainerView.transform = CGAffineTransform(translationX: 0, y: 60)
                
                
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
        
        print("get token: \(userToken)")
            
        self.getMockData(userToken)
            
        
    }
    
    func firstUpdateTextFromMockdata() {
        
        
        
    }
    
    @objc func getMockData(_ token: String) {
        
        let calendar = Calendar.current
        
        let date = Date()
        
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
                     
                     self.dateLabel.text = formatter.string(from: date)
                     self.timeLabel.text = String(format: "%02d:%02d", hour, minutes)
                     self.deviceNameLabel.text = decodeData.deviceName
                     self.stepCountValueLabel.text = String(decodeData.step ?? 0)
                     
                     self.frequencyValueLabel.text = decodeData.frequency
                    
                     self.passDeviceName?(decodeData.deviceName ?? "")

                     
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

    
}
