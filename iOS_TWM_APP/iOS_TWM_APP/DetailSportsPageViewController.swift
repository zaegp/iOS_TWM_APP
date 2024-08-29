import UIKit

class DetailSportsPageViewController: UIViewController {
    

    
    let detailGymAPI = LoginDataRequest()
    var selectGymID: Int?
    var gymDetails: GymDetailData?
    var gymFuncList: String?
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DetailGymPageCell.self, forCellReuseIdentifier: "DetailGymCell")
        tableView.estimatedRowHeight = 100
        tableView.isHidden = true
        tableView.backgroundColor = .white
        tableView.layer.cornerRadius = 10
        tableView.layer.masksToBounds = true
        tableView.separatorStyle = .none

        return tableView
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
      
        view.isHidden = true

        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
    }
    
    private func setupUI() {
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
        headerView.backgroundColor = .white

        let headerLabel = UILabel()
        headerLabel.text = gymDetails?.name
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
        return gymDetails == nil ? 0 : 10
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

//extension DetailSportsPageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return gymDetails?.gymFuncData?.count ?? 0
//       }
//       
//       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! DetailGymPageCell
//           
//           let url = URL(string: (gymDetails?.gymFuncData?[0].photo1)!)
//           cell.imageView?.kf.setImage(with: url)
//           return cell
//       }
//}
