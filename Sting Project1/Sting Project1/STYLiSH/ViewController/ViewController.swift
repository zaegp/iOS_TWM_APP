//
//  ViewController.swift
//  STYLiSH
//
//  Created by 謝霆 on 2024/7/17.
//

import UIKit
import Kingfisher
import MJRefresh
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MarketManagerDelegate {
    
    lazy var marketManager = MarketManager()
    
    var marketingHots: [MarketingHot] = []

    var cartItems: [CartEntity] = []
    
    @IBOutlet weak var tableView: UITableView!
    

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        tableView.delegate = self
        
        marketManager.delegate = self
        
        tableView.separatorStyle = .none
        
        marketManager.getMarketingHots()
        
        mjRefreshConfigure()
        
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        
        let fetchRequest:NSFetchRequest = CartEntity.fetchRequest()
        
        var context: NSManagedObjectContext?
                
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {return}
        
        do {
            
            cartItems = try context.fetch(fetchRequest)
            
            cartItems = try context.fetch(CartEntity.fetchRequest())
            
            if let tabItems = tabBarController?.tabBar.items {
                
                let tabItem = tabItems[2]
                
                tabItem.badgeColor = .brown
                
                tabItem.badgeValue = String(cartItems.count)
            }
        }catch{
            
            fatalError("Failed to fetch data: \(error)")
            
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @objc func refresh() {
            marketManager.getMarketingHots()
        }
    
    func mjRefreshConfigure() {
        
            MJRefreshConfig.default.languageCode = "en"

        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
           
           
            self.tableView.mj_header?.beginRefreshing()
            
            self.tableView.mj_header?.beginRefreshing(completionBlock: {
                self.tableView.reloadData()
            })
          
            self.tableView.mj_header?.endRefreshing()
            
            self.tableView.mj_header?.endRefreshing(completionBlock: {
               
            })
        })
    }
    
    func manager(_ manager: MarketManager, didGet marketingHots: [MarketingHot]) {
        DispatchQueue.main.async {
            
            self.marketingHots = marketingHots
            
            self.tableView.reloadData()
            
        }
    }
    
    func manager(_ manager: MarketManager, didFailWith error: any Error) {
        
        DispatchQueue.main.async {
            
            print("failed to fetch data")
            
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        marketingHots.count
        
    }
    
    func tableView(_ TableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        marketingHots[section].products.count
        
    }
    
    func tableView(_ TableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SingleImageCell", for: indexPath) as? SingleImageCell
            
            let hotProducts = marketingHots[indexPath.section]
            
            let singleImageURL = URL(string:"\(hotProducts.products[indexPath.row].mainImage)")
            
            cell?.singleImageText1.text = hotProducts.products[indexPath.row].title
            
            cell?.singleImageText2.text = hotProducts.products[indexPath.row].description
            
            cell?.singleImage1.kf.setImage(with: singleImageURL)
            
            return cell ?? UITableViewCell()
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MultiImageCell", for: indexPath) as? MultiImageCell
            
            let hotProducts = marketingHots[indexPath.section]
            
            let multiImageURL1 = URL(string:"\(hotProducts.products[indexPath.row].images[0])")
            
            let multiImageURL2 = URL(string:"\(hotProducts.products[indexPath.row].images[1])")
            
            let multiImageURL3 = URL(string:"\(hotProducts.products[indexPath.row].images[2])")
            
            let multiImageURL4 = URL(string:"\(hotProducts.products[indexPath.row].images[3])")
            
            cell?.multiImageText1.text = hotProducts.products[indexPath.row].title
            
            cell?.multiImageText2.text = hotProducts.products[indexPath.row].description
            
            cell?.multiImage1.kf.setImage(with: multiImageURL1)
            
            cell?.multiImage2.kf.setImage(with: multiImageURL2)
            
            cell?.multiImage3.kf.setImage(with: multiImageURL3)
            
            cell?.multiImage4.kf.setImage(with: multiImageURL4)
            
            return cell ?? UITableViewCell()
            
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        
        headerView.backgroundColor = .white
        
        let headerLabel = UILabel()
        
        headerLabel.frame = CGRect(x: 16, y: 8, width: tableView.frame.width - 32, height: 20)
        
        headerLabel.textColor = .black
        
        if section == 0 {
            
            headerLabel.text = marketingHots[section].title
            
        } else if section == 1 {
           
            headerLabel.text = marketingHots[section].title
        }
        
        headerView.addSubview(headerLabel)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let spacingHeight: CGFloat = 50
        
        
        let spacingView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: spacingHeight))
        
        spacingView.backgroundColor = .clear
         
        cell.addSubview(spacingView)
        
        cell.sendSubviewToBack(spacingView)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedProduct = marketingHots[indexPath.section].products[indexPath.row]
        
        let detailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController

        detailViewController?.selectedProduct = selectedProduct
        
        if let navigationController = self.navigationController {
            
            guard let detailViewController = detailViewController else {return}
            
            navigationController.pushViewController(detailViewController, animated: true)
            
           } else {
               
               print("NavigationController is nil")
           }
    }
    
}
    
    
    
    
    



