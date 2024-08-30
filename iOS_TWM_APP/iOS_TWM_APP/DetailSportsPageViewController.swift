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
        tableView.estimatedRowHeight = 100
        tableView.isHidden = true
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
        view.addSubview(statusBar)
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
    
    private func setupCollectionView(forCell cell: UITableViewCell) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 20
        layout.itemSize = CGSize(width: 100, height: 200)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.clipsToBounds = false
        collectionView.isPagingEnabled = false
        collectionView.isScrollEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DetailGymImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        cell.contentView.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(0)
        }
    }
    
    private func fetchData() {
        
        guard let gymID = selectGymID else { return }
        detailGymAPI.getDetailGymPageData(gymID) { [weak self] data in
            guard let self = self else { return }
            self.gymDetails = data

            for i in 0..<(self.gymDetails?.gymFuncData?.count ?? 0) {
                if self.gymDetails?.gymFuncData?[i].photo1 != "https://iplay.sa.gov.tw" {
                    imageCacheArray.append(self.gymDetails?.gymFuncData?[i].photo1 ?? "")
                    print("===============")
                    print(imageCacheArray)
                    print("===============")

                }
                if self.gymDetails?.gymFuncData?[i].photo2 != "https://iplay.sa.gov.tw" {
                    imageCacheArray.append(self.gymDetails?.gymFuncData?[i].photo2 ?? "")
                }
            }
            
            DispatchQueue.main.async {
                self.tableView.isHidden = false
                self.tableView.reloadData()
                self.containerView.isHidden = false
            }
        }
    }
    
    @objc func expandCollectionView() {
        let shouldExpand = collectionView.frame.height == 0
        let newHeight: CGFloat = shouldExpand ? 150 : 0
        UIView.animate(withDuration: 0.3) {
            self.collectionView.snp.updateConstraints { make in
                make.height.equalTo(newHeight)
            }
            self.view.layoutIfNeeded()
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
        headerLabel.font = UIFont.systemFont(ofSize: 25)
        
        headerView.addSubview(headerLabel)
        
        headerLabel.snp.makeConstraints { make in
            make.left.equalTo(headerView.snp.left).inset(20)
            make.centerY.equalTo(headerView.snp.centerY)
        }
        
        return headerView
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gymDetails == nil ? 0 : 11
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailGymCell", for: indexPath) as! DetailGymPageCell
        switch indexPath.row {
        case 0:
            cell.titleButton.setTitle("場地公告", for: .normal)
            cell.titleButton.setTitleColor(.blue, for: .normal)
            cell.detailLabel.isHidden = false
            cell.detailLabel.text = gymDetails?.introduction
        case 1:
            cell.titleButton.setTitle("\(gymDetails?.addr ?? "無")", for: .normal)
            cell.detailLabel.isHidden = true
            
        case 2:
            cell.titleButton.setTitle("交通資訊", for: .normal)
            cell.titleButton.setTitleColor(.blue, for: .normal)
            cell.detailLabel.isHidden = false
            cell.detailLabel.text = gymDetails?.publicTransport ?? "無"
        case 3:
            cell.titleButton.setTitle("\(gymDetails?.operationTel ?? "無")", for: .normal)
            cell.detailLabel.isHidden = true
        case 4:
            cell.titleButton.setTitle("\(gymDetails?.webURL ?? "無")", for: .normal)
            cell.detailLabel.isHidden = true
        case 5:
            cell.titleButton.setTitle("場館設施", for: .normal)
            cell.titleButton.setTitleColor(.blue, for: .normal)
            cell.detailLabel.isHidden = false
            cell.detailLabel.text = gymFuncList ?? "無"
        case 6:
            cell.titleButton.setTitle("一般及無障礙停車場", for: .normal)
            cell.titleButton.setTitleColor(.blue, for: .normal)
            cell.detailLabel.isHidden = false
            cell.detailLabel.text = gymDetails?.parkType ?? "無"
        case 7:
            cell.titleButton.setTitle("無障礙設施", for: .normal)
            cell.titleButton.setTitleColor(.blue, for: .normal)
            cell.detailLabel.isHidden = false
            cell.detailLabel.text =
            "無障礙電梯: \(gymDetails?.passEasyEle ?? 0)間\n無障礙設施: \(gymDetails?.passEasyFuncOthers ?? "0")\n無障礙停車位: \(gymDetails?.passEasyParking ?? 0)個\n無障礙淋浴間: \(gymDetails?.passEasyShower ?? 0)\n無障礙廁所: \(gymDetails?.passEasyToilet ?? 0)\n無障礙通道: \(gymDetails?.passEasyWay ?? 0)個\n無障礙觀眾席: \(gymDetails?.wheelchairAuditorium ?? 0)"
        case 8:
            cell.titleButton.setTitle("性別友善設施", for: .normal)
            cell.titleButton.setTitleColor(.blue, for: .normal)
            cell.detailLabel.isHidden = false
            cell.detailLabel.text =
            "性別友善廁所: 0間 \n親子廁所: 0間 \n哺乳室: 0間 \n性別友善淋浴間: 0間\n親子淋浴間: 0間"
        case 9:
            cell.titleButton.setTitle("實際照片", for: .normal)
            cell.titleButton.setTitleColor(.blue, for: .normal)
            cell.titleButton.addTarget(self, action: #selector(expandCollectionView), for: .touchUpInside)
            
        case 10:
            cell.titleButton.isHidden = true
            cell.detailLabel.isHidden = true
            cell.borderView.isHidden = true
            cell.viewImage.isHidden = true
            setupCollectionView(forCell: cell)
            
        default:
            print("default error")
            
        }
        
        cell.viewImage.image = UIImage(named: cell.iconArray[indexPath.row])
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    
}

extension DetailSportsPageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageCacheArray.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! DetailGymImageCell
        let url = URL(string: (imageCacheArray[indexPath.row] ?? ""))
        cell.imageView.kf.setImage(with: url)
        return cell
    }
}
