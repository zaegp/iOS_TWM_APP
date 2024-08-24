import UIKit

class DetailSportsPageViewController: UIViewController {
    
    let detailGymAPI = LoginDataRequest()
    var selectGymID: Int?
    var gymDetails: GymDetailData?
    
    // 創建 tableView
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DetailGymPageCell.self, forCellReuseIdentifier: "DetailGymCell")
        tableView.estimatedRowHeight = 100
        tableView.isHidden = true // 初始時隱藏
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension DetailSportsPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gymDetails == nil ? 0 : 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailGymCell", for: indexPath) as! DetailGymPageCell
        cell.backgroundColor = .blue
     
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
