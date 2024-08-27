import UIKit

class DetailSportsPageViewController: UIViewController {
    
//    let iconArray = ["detail-icon-announcement", "detail-icon-location", "detail-icon-bus", "detail-icon-telephone", "detail-icon-website", "detail-icon-buildings", "detail-icon-parking", "detail-icon-wheelchair", "detail-icon-gender", "detail-icon-photo"]
    
    let detailGymAPI = LoginDataRequest()
    var selectGymID: Int?
    var gymDetails: GymDetailData?
    
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
            
            // 在主線程中更新 UI
            DispatchQueue.main.async {
                self.tableView.isHidden = false // 顯示 tableView
                self.tableView.reloadData() // 刷新 tableView
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
            make.centerY.equalTo(headerView.snp.centerY) // 确保文本垂直居中
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
            cell.titleLabel.text = "場地公告"
        case 1:
            cell.titleLabel.text = gymDetails?.addr
        case 2:
            cell.titleLabel.text = gymDetails?.publicTransport
        case 3:
            cell.titleLabel.text = gymDetails?.operationTel
        case 4:
            cell.titleLabel.text = gymDetails?.webURL
        case 5:
            cell.titleLabel.text = gymDetails?.introduction
        case 6:
            cell.titleLabel.text = gymDetails?.parkType
        case 7:
            cell.titleLabel.text = gymDetails?.passEasyFuncOthers
        case 8:
            cell.titleLabel.text = "性別友善設施"
        case 9:
            cell.titleLabel.text = "實際照片"
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
