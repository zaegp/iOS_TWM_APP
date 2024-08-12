//
//  CatalogViewController.swift
//  STYLiSH
//
//  Created by 謝霆 on 2024/7/22.
//

import Foundation
import UIKit
import Kingfisher
import MJRefresh
import UIScrollView_InfiniteScroll

class CatalogViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ProductListManagerDelegate{
    
    
    @IBOutlet weak var catalogCollectionView: UICollectionView!
    
    @IBOutlet weak var buttonStackView: UIStackView!
    
    @IBOutlet weak var underLineView: UIView!
    
    @IBOutlet weak var underLineViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var underLineViewCenterXConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var underLineViewTopConstraint: NSLayoutConstraint!
    
    @IBAction func touchWomenTab(_ sender: Any) {
        
        nextPage = 0
        
        productListManager.loadApiData(category: "women")
        
        pageAt = "women"
        
    }
    
    
    @IBAction func touchMenTab(_ sender: UIButton) {
        
        productListManager.loadApiData(category: "men")
        
        pageAt = "men"
        
    }
    
    
    @IBAction func touchAccessoryTab(_ sender: UIButton) {
        
        productListManager.loadApiData(category: "accessories")
        
        pageAt = "accessories"
        
    }
    
    var productListManager = ProductListManager()
        
    var product: [ProductListProduct] = []
    
    var isLoadingMore = false
    
    var isHomePage = false
    
    var nextPage = 0
    
    var pageAt: String = "women"
    
    let screenWidth = UIScreen.main.bounds.width
    
    var width: CGFloat?
    
    var isPaging = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        catalogCollectionView.delegate = self
        
        catalogCollectionView.dataSource = self
        
        productListManager.delegate = self
        
        productListManager.loadApiData()
        
        mjRefreshConfigure()
        
        let buttons = buttonStackView.subviews
        
        for (index,button) in buttons.enumerated() {
            
            if let uibutton = button as? UIButton {
                
                uibutton.tag = index
                
                uibutton.addTarget(self, action: #selector(changePage), for: .touchUpInside)
            }
            
        }
        
        catalogCollectionView.addInfiniteScroll { [weak self] (collectionView) -> Void in
            
            self?.fetchmoreProducts()
            
        }
        
        catalogCollectionView.setShouldShowInfiniteScrollHandler { _ -> Bool in
            
            if !self.isLoadingMore && self.nextPage < 2 {
                
                self.isPaging = true
                
            }
            
            return !self.isLoadingMore
            
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        width = view.bounds.width
        
    }
    
    func fetchmoreProducts() {
        
        guard !isLoadingMore else {
            
            return
            
        }
        
        nextPage += 1
        
        self.productListManager.isPaging = true
        
        productListManager.loadApiData(page: nextPage)
           
    }
    
    func mjRefreshConfigure() {
        
        MJRefreshConfig.default.languageCode = "en"
                
        catalogCollectionView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
                        
            self.catalogCollectionView.mj_header!.beginRefreshing()
            
            self.catalogCollectionView.mj_header!.beginRefreshing(completionBlock: { [self] in
                
                self.catalogCollectionView.reloadData()
                
                self.productListManager.loadApiData(category: self.pageAt)
                
                self.nextPage = 0
                
            })
             
            self.catalogCollectionView.mj_header!.endRefreshing()
            
            self.catalogCollectionView.mj_header!.endRefreshing(completionBlock: {
                
            })
        })
    }
    
    //MARK: Fetch API
    
    func manager(_ manager: ProductListManager, didGet product: [ProductListProduct]) {
        
        DispatchQueue.main.async {
            
            if self.productListManager.isPaging == true {
                
                self.product.append(contentsOf: product)
                
                self.productListManager.isPaging = false
                
            } else {
                
                self.product = product
                
            }
            
            self.catalogCollectionView.reloadData()
            
            self.catalogCollectionView.finishInfiniteScroll()
                        
        }
        
    }
    
    func manager(_ manager: ProductListManager, didFailWith error: any Error) {
        
        DispatchQueue.main.async {
            
            print("failed to fetch data")
            
            self.catalogCollectionView.finishInfiniteScroll()
            
            self.isLoadingMore = false
            
        }
    }
    
    
    @objc func changePage(sender: UIButton){

        underLineViewWidthConstraint.isActive = false
        underLineViewCenterXConstraint.isActive = false
        underLineViewTopConstraint.isActive = false
        
        underLineViewWidthConstraint = underLineView.widthAnchor.constraint(equalTo: sender.widthAnchor)
        underLineViewCenterXConstraint = underLineView.centerXAnchor.constraint(equalTo: sender.centerXAnchor)
        underLineViewTopConstraint = underLineView.topAnchor.constraint(equalTo: sender.bottomAnchor)
        
        underLineViewWidthConstraint.isActive = true
        underLineViewCenterXConstraint.isActive = true
        underLineViewTopConstraint.isActive = true
        
        UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {
            
            self.view.layoutIfNeeded()
            
        }.startAnimation()
        
        
    }
    
    
    func setButtonConstraint(button: UIButton){
      
        underLineViewWidthConstraint.isActive = false
        underLineViewCenterXConstraint.isActive = false
        underLineViewTopConstraint.isActive = false
        
        underLineViewWidthConstraint = underLineView.widthAnchor.constraint(equalTo: button.widthAnchor)
        underLineViewCenterXConstraint = underLineView.centerXAnchor.constraint(equalTo: button.centerXAnchor)
        underLineViewTopConstraint = underLineView.topAnchor.constraint(equalTo: button.bottomAnchor)
        
        underLineViewWidthConstraint.isActive = true
        underLineViewCenterXConstraint.isActive = true
        underLineViewTopConstraint.isActive = true
        
        UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {
            
            self.view.layoutIfNeeded()
            
        }.startAnimation()
        
    }
    
    //MARK: numberOfItemsInSection(should be edited to insert API)
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return product.count
        
    }
    
    //MARK: sizeForItemAt
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        return CGSize(width: screenWidth * 0.43, height: screenWidth * 0.74)
        
    }
    
    
    //MARK: cellForItemAt
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatalogCell", for: indexPath) as? CatalogCollectionViewCell else {return UICollectionViewCell()}
        
        let productItem = product[indexPath.item]
        
        cell.catalogPriceLabel.text = String(productItem.price)
        
        cell.catalogTitleLabel.text = productItem.title
        
        let mainImageurl = URL(string: product[indexPath.item].mainImage)
        
        cell.catalogImage.kf.setImage(with: mainImageurl)
        
        return cell
    }
    
    //MARK: insetForSectionAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: screenWidth / 15, left: screenWidth / 25, bottom: 0, right: screenWidth / 25)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return screenWidth / 10
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedProduct = product[indexPath.row]
        
        guard let detailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {return}
        
        detailViewController.selectedProduct = selectedProduct
        
        
        if let navigationController = self.navigationController {
            
            navigationController.pushViewController(detailViewController, animated: true)
            
        } else {
            
            print("NavigationController is nil")
            
        }
    }
   
}

