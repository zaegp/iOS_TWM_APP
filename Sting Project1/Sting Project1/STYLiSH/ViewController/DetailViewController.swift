//
//  DetailViewController.swift
//  STYLiSH
//
//  Created by 謝霆 on 2024/7/24.
//

import Foundation
import UIKit
import Kingfisher
import CoreData


class DetailViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var backgroundView: UIView!
    
    let footerView = UIView()
    
    let board = UIStoryboard(name: "Main", bundle: nil)
    
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    let cartButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleDismissAddToCartPage), name: Notification.Name("DidDismissAddToCartPage"), object: nil)
        
        setupFooterView()
        
        tableViewControl()
        
        setTableViewConstraints()
        
        setAddToCartTableView()
        
        view.bringSubviewToFront(backButton)
        
    }

    deinit {
        
           NotificationCenter.default.removeObserver(self, name: Notification.Name("DidDismissAddToCartPage"), object: nil)
        
       }
    
    @objc func handleDismissAddToCartPage() {
        
        UIView.animate(withDuration: 0.6, animations: {
            
            self.backgroundView.isHidden = true // 顯示灰色遮罩
            
            self.cartButton.backgroundColor = UIColor(hex: "443F42" )
            
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)

        self.hidesBottomBarWhenPushed = true
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)

        self.hidesBottomBarWhenPushed = false

    }
    
    override var prefersStatusBarHidden: Bool {
        
            return false
        
        }
    
    var selectedProduct: Product?
    
    func setAddToCartTableView() {    
        
        let addToCartViewController = storyboard?.instantiateViewController(withIdentifier: "AddToCartViewController")as? AddToCartViewController
        
        let addToCartView = addToCartViewController?.view
        
        addToCartView?.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: 615)
        
        if let addToCartView = addToCartView {
            
            self.view.addSubview(addToCartView)
            
        }
        
        addToCartViewController?.selectedProduct = selectedProduct
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissAddToCartView))
        
        backgroundView.addGestureRecognizer(tapGesture)
        
    }
    
    func setTableViewConstraints() {
        
        NSLayoutConstraint.activate([
            
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                
                tableView.topAnchor.constraint(equalTo: view.topAnchor),
                
                tableView.bottomAnchor.constraint(equalTo: footerView.topAnchor)
                
            ])
        
        }
    
    func tableViewControl() {
        
        self.tableView.rowHeight = UITableView.automaticDimension;
        
        tableView.contentInset = .zero
        
        tableView.contentInsetAdjustmentBehavior = .never
        
        self.navigationController?.navigationBar.isHidden = true
        
        self.navigationItem.setHidesBackButton(true, animated: true)

        tableView.separatorStyle = .none
        
    }


    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 4
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 3 {
            
            return 6
            
        } else {
            
            return 1
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTitleCell", for: indexPath) as? DetailTitleCell
            
            cell?.frame = CGRect(x: 0, y: 603, width: 393, height: 59)
            
            cell?.titleLabel.text = selectedProduct?.title
            
            cell?.titlePrice.text = String("NT $\(selectedProduct?.price)")
            
            cell?.titleId.text = String("\(selectedProduct?.id)")
            
            return cell ?? UITableViewCell()
            
        } else if indexPath.section == 1 {
 
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailStoryCell", for: indexPath) as? DetailStoryCell
            
            cell?.storyLabel.text = selectedProduct?.story
            
            return cell ?? UITableViewCell()
            
        } else if indexPath.section == 2{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailColorCell", for: indexPath) as? DetailColorCell
            
            cell?.colorView1.layer.borderWidth = 1.0
            
            cell?.colorView1.layer.borderColor = UIColor.darkGray.cgColor
            
            cell?.colorView2.layer.borderWidth = 1.0
            
            cell?.colorView2.layer.borderColor = UIColor.darkGray.cgColor
                        
            let color1 = selectedProduct?.colors[0].code
            
            let color2 = selectedProduct?.colors[1].code
            
            guard let color1 = color1, let color2 = color2 else {return UITableViewCell()}
            
            cell?.colorView1.backgroundColor = UIColor(hex: color1)
            
            cell?.colorView2.backgroundColor = UIColor(hex: color2)
            
            return cell ?? UITableViewCell()
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailDescriptionCell", for: indexPath) as? DetailDescriptionCell
            
            guard let selectedProduct = selectedProduct else {return UITableViewCell() }
            
            if indexPath.row == 0 && selectedProduct.sizes.count > 1 {
                cell?.detailTitle.text = "尺寸"
                cell?.detailText.text = "\(selectedProduct.sizes[0]) - \(selectedProduct.sizes[selectedProduct.sizes.count - 1])"
            } else if indexPath.row == 0 && selectedProduct.sizes.count == 1{
                cell?.detailTitle.text = "尺寸"
                cell?.detailText.text = "\(selectedProduct.sizes[0])"
            } else if indexPath.row == 1 {
                cell?.detailTitle.text = "庫存"
                cell?.detailText.text = "\(String(describing: selectedProduct.variants.reduce(0) { $0 + $1.stock }))"
            } else if indexPath.row == 2 {
                cell?.detailTitle.text = "材質"
                cell?.detailText.text = selectedProduct.texture
            } else if indexPath.row == 3 {
                cell?.detailTitle.text = "洗滌"
                cell?.detailText.text = selectedProduct.wash
            } else if indexPath.row == 4 {
                cell?.detailTitle.text = "產地"
                cell?.detailText.text = selectedProduct.place
            } else {
                cell?.detailTitle.text = "備註"
                cell?.detailText.text = selectedProduct.note
            }
            
            return cell ?? UITableViewCell()
        }
  
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            
            let headerView = UIView()

            headerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 500)

            let scrollView = UIScrollView()
            
            scrollView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 500)
            
            scrollView.isPagingEnabled = true
            
            scrollView.showsHorizontalScrollIndicator = false
            
            scrollView.delegate = self
            
            let pageControl = UIPageControl(frame: CGRect(x: -140, y: headerView.frame.height - 50, width: headerView.frame.width, height: 50))
            
            pageControl.numberOfPages = 4
            
            pageControl.currentPage = 0
            
            pageControl.addTarget(self, action: #selector(pageControlChanged(_:)), for: .valueChanged)

            let imageUrls = [
                
                selectedProduct?.images[0],
                
                selectedProduct?.images[1],
                
                selectedProduct?.images[2],
                
                selectedProduct?.images[3]
                
            ].compactMap { $0 }

            let imageWidth = scrollView.frame.width
            
            let imageHeight = scrollView.frame.height

            for i in 0..<imageUrls.count {
                
                let imageView = UIImageView(frame: CGRect(x: CGFloat(i) * imageWidth, y: 0, width: imageWidth, height: imageHeight))
                
                if let url = URL(string: imageUrls[i]) {
                    
                    imageView.kf.setImage(with: url)
                    
                }
                
                imageView.contentMode = .scaleAspectFill
                
                imageView.clipsToBounds = true

                scrollView.addSubview(imageView)
                
            }
            
            scrollView.contentSize = CGSize(width: imageWidth * CGFloat(imageUrls.count), height: imageHeight)

            headerView.addSubview(scrollView)
            
            headerView.addSubview(pageControl)

            return headerView
            
        } else {
            
            return nil
            
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
            if section == 0 {
                
                return UIScreen.main.bounds.width * (4 / 3)
                
            } else {
                
                return 0
                
            }
        }


    @objc func pageControlChanged(_ sender: UIPageControl) {
        
        let page = sender.currentPage
        
        let offsetX = CGFloat(page) * UIScreen.main.bounds.width
        
        if let scrollView = sender.superview?.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView {
            
            scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
            
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let pageControl = scrollView.superview?.subviews.compactMap { $0 as? UIPageControl }.first
        
        let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
        
        pageControl?.currentPage = Int(pageIndex)
        
    }
    
    func setupFooterView() {
        
            footerView.translatesAutoresizingMaskIntoConstraints = false
        
            footerView.backgroundColor = .white
        
            footerView.layer.borderWidth = 1
        
            footerView.layer.borderColor = UIColor.lightGray.cgColor
            view.addSubview(footerView)

            cartButton.setTitle("加入購物車", for: .normal)
        
            cartButton.setTitleColor(.white, for: .normal)
        
            cartButton.backgroundColor = UIColor(hex: "443F42" )
        
            cartButton.translatesAutoresizingMaskIntoConstraints = false
        
            cartButton.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
            footerView.addSubview(cartButton)

            NSLayoutConstraint.activate([
                
                footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                
                footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                
                footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                
                footerView.heightAnchor.constraint(equalToConstant: 120),

                cartButton.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
                
                cartButton.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 15),
                
                cartButton.widthAnchor.constraint(equalToConstant: 350),
                
                cartButton.heightAnchor.constraint(equalToConstant: 50)

            ])
        }

    
    
    @IBAction func backButtonTapped(_ sender: Any) {

        navigationController?.popViewController(animated: true)
           
    }
    
    
    
    @objc func cartButtonTapped() {

        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let addToCartViewController = storyBoard.instantiateViewController(withIdentifier: "AddToCartViewController") as? AddToCartViewController
        
        let addToCartView = addToCartViewController?.view
        
        addToCartViewController?.selectedProduct = selectedProduct
        
        guard let addToCartViewController = addToCartViewController else {return}

        present(addToCartViewController, animated: true, completion: nil)
        
        UIView.animate(withDuration: 0.6, animations: {
            
            self.backgroundView.isHidden = false
            
            addToCartView?.frame = CGRect(x: 0, y: self.view.bounds.height - 578, width: self.view.bounds.width, height: 395)
            
            self.cartButton.backgroundColor = UIColor.lightGray
        })

    }
    
    @objc func dismissAddToCartView() {
        
        let addToCartViewController = storyBoard.instantiateViewController(withIdentifier: "AddToCartViewController") as? AddToCartViewController
        
            UIView.animate(withDuration: 0.8, animations: {
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                
                let addToCartViewController = storyBoard.instantiateViewController(withIdentifier: "AddToCartViewController") as? AddToCartViewController
                
                addToCartViewController?.view.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: 615)
            }) { _ in
                
                addToCartViewController?.view.removeFromSuperview()

                self.backgroundView.isHidden = true
                
            }
        
        }
    
}

extension UIColor {
    convenience init(hex: String) {
        
        let hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let scanner = Scanner(string: hexString)

        if hexString.hasPrefix("#") {
            
            scanner.currentIndex = hexString.index(after: hexString.startIndex)
            
        }

        var color: UInt64 = 0
        
        scanner.scanHexInt64(&color)

        let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
        
        let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
        
        let b = CGFloat(color & 0x0000FF) / 255.0

        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}

