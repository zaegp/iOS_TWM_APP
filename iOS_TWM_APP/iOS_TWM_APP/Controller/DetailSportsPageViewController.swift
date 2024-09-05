import UIKit
import SnapKit
import Kingfisher

class DetailSportsPageViewController: UIViewController {
    
    var collectionView: UICollectionView!
    let detailGymAPI = LoginDataRequest()
    var selectGymID: Int?
    var gymDetails: GymDetailData?
    var gymFuncList: String?
    var imageCacheArray: [String] = []
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DetailGymPageCell.self, forCellReuseIdentifier: "DetailGymCell")
        tableView.register(DetailGymPageCell.self, forCellReuseIdentifier: "DetailGymImageCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.backgroundColor = .white
        tableView.layer.cornerRadius = 10
        tableView.layer.masksToBounds = true
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    lazy var containerView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "sports-background")
        view.alpha = 0.4
        view.isHidden = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
        let statusBar = UIView(frame: UIApplication.shared.statusBarFrame)
        statusBar.backgroundColor = .white.withAlphaComponent(0.8)
        if isPush == true {
            view.addSubview(statusBar)
        } else {
            statusBar.removeFromSuperview()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(containerView)
        view.addSubview(tableView)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(18)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(18)
            make.left.right.equalTo(containerView).inset(18)
        }
    }
    
    
    private func fetchData() {
        
        guard let gymID = selectGymID else { return }
        detailGymAPI.getDetailGymPageData(gymID) { [weak self] data in
            guard let self = self else { return }
            self.gymDetails = data
            
            var urlsToPrefetch: [URL] = []
            
            for i in 0..<(self.gymDetails?.gymFuncData?.count ?? 0) {
                if let photo1 = self.gymDetails?.gymFuncData?[i].photo1,
                   photo1 != "https://iplay.sa.gov.tw" {
                    imageCacheArray.append(photo1)
                    if let url = URL(string: photo1) {
                        urlsToPrefetch.append(url)
                    }
                }
                if let photo2 = self.gymDetails?.gymFuncData?[i].photo2,
                   photo2 != "https://iplay.sa.gov.tw" {
                    imageCacheArray.append(photo2)
                    if let url = URL(string: photo2) {
                        urlsToPrefetch.append(url)
                    }
                }
            }
            
            let prefetcher = ImagePrefetcher(urls: urlsToPrefetch) {
                skippedResources, failedResources, completedResources in
                print("Prefetched \(completedResources.count) images.")
            }
            prefetcher.start()
            
            DispatchQueue.main.async {
                self.tableView.isHidden = false
                self.tableView.reloadData()
                self.containerView.isHidden = false
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension DetailSportsPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .white.withAlphaComponent(0.9)
        
        let headerLabel = UILabel()
        headerLabel.text = gymDetails?.name
        headerLabel.textColor = .black
        headerLabel.textAlignment = .left
        headerLabel.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
        headerLabel.numberOfLines = 0 
        headerLabel.lineBreakMode = .byWordWrapping
        
        headerView.addSubview(headerLabel)
        
        headerLabel.snp.makeConstraints { make in
            make.left.equalTo(headerView.snp.left).inset(20)
            make.right.equalTo(headerView.snp.right).inset(20)
            make.top.equalTo(headerView.snp.top).inset(10)
            make.bottom.equalTo(headerView.snp.bottom).inset(10)
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 9:
            return 150
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gymDetails == nil ? 0 : 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailGymCell", for: indexPath) as! DetailGymPageCell
        cell.selectionStyle = .none
        cell.imageCacheArray = self.imageCacheArray
        switch indexPath.row {
        case 0:
            cell.titleButton.setTitle("場地公告", for: .normal)
            cell.detailLabel.text = gymDetails?.introduction
            
        case 1:
            cell.titleButton.setTitle("\(gymDetails?.addr ?? "無")", for: .normal)
        case 2:
            cell.titleButton.setTitle("交通資訊", for: .normal)
            cell.detailLabel.text = gymDetails?.publicTransport ?? "無"
        case 3:
            cell.titleButton.setTitle("\(gymDetails?.operationTel ?? "無")", for: .normal)
            cell.titleButton.addTarget(self, action: #selector(callPhoneNumber), for: .touchUpInside)
            cell.titleButton.setTitleColor(.blue, for: .normal)
            
        case 4:
            cell.titleButton.setTitle("\(gymDetails?.webURL ?? "無")", for: .normal)
            cell.titleButton.addTarget(self, action: #selector(openWebPage), for: .touchUpInside)
            cell.titleButton.setTitleColor(.blue, for: .normal)
        case 5:
            cell.titleButton.setTitle("場館設施", for: .normal)
            cell.detailLabel.text = gymFuncList ?? "無"
        case 6:
            cell.titleButton.setTitle("一般及無障礙停車場", for: .normal)
            cell.detailLabel.text = gymDetails?.parkType ?? "無"
        case 7:
            cell.titleButton.setTitle("無障礙設施", for: .normal)
            cell.detailLabel.text = """
            無障礙電梯: \(gymDetails?.passEasyEle ?? 0)間
            無障礙設施: \(gymDetails?.passEasyFuncOthers ?? "0")
            無障礙停車位: \(gymDetails?.passEasyParking ?? 0)個
            無障礙淋浴間: \(gymDetails?.passEasyShower ?? 0)
            無障礙廁所: \(gymDetails?.passEasyToilet ?? 0)
            無障礙通道: \(gymDetails?.passEasyWay ?? 0)個
            無障礙觀眾席: \(gymDetails?.wheelchairAuditorium ?? 0)
            """
        case 8:
            cell.titleButton.setTitle("性別友善設施", for: .normal)
            cell.detailLabel.text = """
            性別友善廁所: 0間
            親子廁所: 0間
            哺乳室: 0間
            性別友善淋浴間: 0間
            親子淋浴間: 0間
            """
        case 9:
            cell.titleButton.setTitle("實際照片", for: .normal)
            cell.detailLabel.isHidden = true
            cell.collectionView.isHidden = false
            
        default:
            print("error")
        }
        
        cell.viewImage.image = UIImage(named: cell.iconArray[indexPath.row])
        return cell
    }
    
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource



extension DetailSportsPageViewController {
    
    @objc private func openWebPage() {
        guard let urlString = gymDetails?.webURL, let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    @objc private func callPhoneNumber() {
        guard let number = gymDetails?.operationTel, let url = URL(string: "tel://\(number)") else {
            print("Invalid phone number")
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("Unable to open dialer")
        }
    }
}
