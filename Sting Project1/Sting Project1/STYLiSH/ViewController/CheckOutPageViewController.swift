//
//  CheckOutPageViewController.swift
//  STYLiSH
//
//  Created by 謝霆 on 2024/8/3.
//

import UIKit
import Kingfisher
import CoreData
import TPDirect





class CheckOutPageViewController: UIViewController {

    static let checkOutPageViewController = CheckOutPageViewController()
    
    @IBOutlet weak var checkOutTableView: UITableView!
   
    var tpdForm: TPDForm?
        
    var tpdCard: TPDCard?
    
    var textFieldIsFilled: Bool?
    
    let header = ["結帳商品", "收件資訊", "付款詳情"]
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        checkOutTableView.dataSource = self
        
        checkOutTableView.delegate = self
        
        checkOutTableView.lk_registerCellWithNib(identifier: String(describing: STOrderProductCell.self), bundle: nil)
        
        checkOutTableView.lk_registerCellWithNib(identifier: String(describing: STOrderUserInputCell.self), bundle: nil)
        
        checkOutTableView.lk_registerCellWithNib(identifier: String(describing: STPaymentInfoTableViewCell.self), bundle: nil)
        
        let headerXib = UINib(nibName: String(describing: STOrderHeaderView.self), bundle: nil)
        
        checkOutTableView.register(headerXib, forHeaderFooterViewReuseIdentifier: String(describing: STOrderHeaderView.self))
        
        checkOutTableView.estimatedRowHeight = UITableView.automaticDimension
        
        self.checkOutTableView.rowHeight = UITableView.automaticDimension
        
        checkOutTableView.contentInset = .zero
        
        checkOutTableView.contentInsetAdjustmentBehavior = .never
        
        self.navigationController?.navigationBar.isHidden = true
        
        self.navigationItem.setHidesBackButton(true, animated: true)

        checkOutTableView.separatorStyle = .none
        
        let cartViewController = CartViewController()
        
        cartViewController.delegate = self
        
        
        checkOutTableView.register(UINib(nibName: "STOrderProductCell", bundle: nil), forCellReuseIdentifier: "CheckOUtProductCell")
  
        getCoreData()
        
        removeNilValuesFromCartItems()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    var cartItems: [CartEntity] = []
    
    func passData(cartItems: [CartEntity]) {
        
        self.cartItems = cartItems
        
    }
    
    func getCoreData() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Unable to get AppDelegate")
            
        }

        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<CartEntity> = CartEntity.fetchRequest()

        do {
            
            cartItems = try context.fetch(fetchRequest)
            
            checkOutTableView.reloadData()
            
        } catch {
            
            fatalError("Failed to fetch data: \(error)")
            
        }
    }
    
    func removeNilValuesFromCartItems() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Unable to get AppDelegate")
        }

        let context = appDelegate.persistentContainer.viewContext
        
        for item in cartItems {
            
            if item.color == nil {
                
                context.delete(item)
                
            }
        }
        
        do {
            try context.save()
            
            cartItems = try context.fetch(CartEntity.fetchRequest())
            
        } catch {
            
            print("Failed to save context: \(error)")
            
        }
        
        
    }

}

extension CheckOutPageViewController: UITableViewDataSource, UITableViewDelegate, PassDatatoCheckOut, STOrderUserInputCellDelegate {
    
    func didChangeUserData(_ cell: STOrderUserInputCell, username: String, email: String, phoneNumber: String, address: String, shipTime: String, textFieldIsFilled: Bool) {
        
       self.textFieldIsFilled = textFieldIsFilled
        
        let indexPath = IndexPath(row: 0, section: 2)
        
        let cell = checkOutTableView.cellForRow(at: indexPath)as? STPaymentInfoTableViewCell
        
        if textFieldIsFilled == false {
            
            cell?.isUserInteractionEnabled = false
            
            cell?.alpha = 0.5
            
        } else {
            
            cell?.isUserInteractionEnabled = true
            
            cell?.alpha = 1
            
        }

    }
    
    

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 67.0
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: STOrderHeaderView.self)) as? STOrderHeaderView else {
            
            return nil
            
        }
        
        headerView.titleLabel.text = header[section]
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 2 {
            
            return 500
            
        } else {
            
            return UITableView.automaticDimension
            
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        
        guard let footerView = view as? UITableViewHeaderFooterView else { return }
        
        footerView.contentView.backgroundColor = UIColor(hex: "cccccc")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return header.count
    }
    
    func tableView(_ TableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return cartItems.count
            
        } else {
            
            return 1
            
        }
       
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cartItem = cartItems[indexPath.row]
        
        guard let color = cartItem.color else {return UITableViewCell()}
        
        guard let number = cartItem.number else {return UITableViewCell()}


        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckOUtProductCell", for: indexPath)as? STOrderProductCell
             
            guard let image = cartItem.image,let imageURL = URL(string: image) else {return UITableViewCell()}
            
            guard let cell = cell else {return UITableViewCell()}
            
            cell.productImageView.kf.setImage(with: imageURL)
            
            cell.productTitleLabel.text = cartItem.title
            
            cell.productSizeLabel.text = cartItem.size
            
            cell.colorView.backgroundColor = UIColor(hex:color)
            
            cell.orderNumberLabel.text = "x \(String(describing: number))"
            
            return cell
            
            
        } else if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: STOrderUserInputCell.self), for: indexPath)as? STOrderUserInputCell
            
            let userInputCell = STOrderUserInputCell()
            
            cell?.delegate = self
                   
            guard let cell = cell else {return UITableViewCell()}
            
            return cell
        
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: STPaymentInfoTableViewCell.self), for: indexPath)as? STPaymentInfoTableViewCell

            if textFieldIsFilled == false {
                
                cell?.isUserInteractionEnabled = false
                
            } else {
                
                cell?.isUserInteractionEnabled = true
                
            }
            
            cell?.isUserInteractionEnabled = false
                        
            var totalPrice: Int = 0
            
            for i in 0 ..< cartItems.count {
                
                guard let number = cartItems[i].number,
                let price = cartItems[i].price,
                let cartItemNumber = Int(number),
                let cartItemPrice = Int(price) else {return UITableViewCell()}
                
               totalPrice += cartItemNumber * cartItemPrice
                
            }
            
            cell?.productPriceLabel.text = "NT$ \(totalPrice)"
            
            cell?.productAmountLabel.text = "總計 (\(cartItems.count)樣商品)"
            
            cell?.totalPriceLabel.text = "NT$ \(totalPrice + 240)"
            
            cell?.checkOutButton.addTarget(self, action:  #selector(pushSuccessPage), for: .touchUpInside)
            
            guard let cell = cell else {return UITableViewCell()}
            
            return cell
        }
        
    }
    
    @objc func pushSuccessPage(sender: Any?) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

        let successViewController = storyBoard.instantiateViewController(withIdentifier: "SuccessViewController") as? SuccessViewController
    
        self.performSegue(withIdentifier: "SuccessViewController", sender: sender)
    }
    

}

extension CheckOutPageViewController: STPaymentInfoTableViewCellDelegate {
    
    func didChangePaymentMethod(_ cell: STPaymentInfoTableViewCell) {
        
        checkOutTableView.reloadData()
    }
     
    func checkout(_ cell:STPaymentInfoTableViewCell) {
        
        print("User did tap checkout button")
        
    }
}

protocol PassDatatoCheckOut {
    
    func passData(cartItems: [CartEntity])
    
}
