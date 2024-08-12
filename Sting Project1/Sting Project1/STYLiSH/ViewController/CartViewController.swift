//
//  CartViewController.swift
//  STYLiSH
//
//  Created by 謝霆 on 2024/8/2.
//

import UIKit
import Kingfisher
import CoreData
import FacebookLogin
import StatusAlert



class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var cartTabelVIew: UITableView!
    
    var cartItems: [CartEntity] = []
    
    var delegate: PassDatatoCheckOut?
    
    @IBAction func loggedOutButton(_ sender: Any) {
        
        print("logged out")
        
        let manager = LoginManager()
        
        manager.logOut()
        
        let statusAlert = StatusAlert()
        
        statusAlert.image = UIImage(named: "Icons_44px_Success01")
        
        statusAlert.title = "Logged out"
        
        statusAlert.appearance.tintColor = .white
        
        statusAlert.appearance.backgroundColor = .darkGray
        
        statusAlert.canBePickedOrDismissed =  true
        
        isLoggedin = false
        
        statusAlert.showInKeyWindow()
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: nil)
        
        cartTabelVIew.dataSource = self
        
        cartTabelVIew.delegate = self
        
        setupFooterView()
        
        let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        
        getCoreData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.cartTabelVIew.reloadData()
        
        getCoreData()
        
        //guard let cartItemsNumbers = cartItems.count else {return}
        
        self.tabBarItem.badgeValue = String(cartItems.count)
        
    }
    
    let footerView = UIView()
    
    let checkoutButton = UIButton(type: .system)
    
    var cell2: CartCell?
    
    var stockForShow: Int?
    
    var context: NSManagedObjectContext?
    
    func getCoreData() {
        
        let fetchRequest:NSFetchRequest = CartEntity.fetchRequest()
        
        do {
            
            removeNilValuesFromCartItems()
            
            guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {return}
            
            cartItems = try context.fetch(CartEntity.fetchRequest())
            
            if let tabItems = tabBarController?.tabBar.items {
                
                let tabItem = tabItems[2]
                
                tabItem.badgeColor = .brown
                
                //guard let cartItemsNumbers = cartItems.count else {return}
                
                tabItem.badgeValue = String(cartItems.count)
                
            }
            
            cartTabelVIew.reloadData()
            
        }catch{
            
            fatalError("Failed to fetch data: \(error)")
            
        }
        
    }
    
    
    func removeNilValuesFromCartItems() {
        
       // guard let cartItems = cartItems else {return}
        
        for item in cartItems {
            
            if item.color == nil {
                
                context?.delete(item)
                
            }
        }
        
        do {
            
            try context?.save()
            
        } catch {
            
            print("Failed to save context: \(error)")
            
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cartItems.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath)as? CartCell
        
        guard let cell = cell else {return UITableViewCell()}
        
        
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        
        cell.removeButton.tag = indexPath.row
        cell.plusButton.contentHorizontalAlignment = .center
        
        let cartItem = cartItems[indexPath.row]
        
        cell.producrPrice.text = cartItem.price
        
        guard let color = cartItem.color else {return UITableViewCell()}
        
        cell.productColor.backgroundColor = UIColor(hex: color)
        cell.productLabel.text = cartItem.title
        cell.productSize.text = cartItem.size
        cell.productLabel.text = cartItem.title
        
        guard let image = cartItem.image else {return UITableViewCell()}
        
        let imageURL = URL(string: image)
        cell.productImage.kf.setImage(with: imageURL)
        
        cell.textfield.text = cartItem.number
        cell.tag = indexPath.row
        
        guard let stock = cartItem.stock else {return UITableViewCell()}
        
        stockForShow = Int(stock)
        
        cell.removeButton.addTarget(self, action: #selector(removerowButtonClicked), for: .touchUpInside)
        cell.plusButton.addTarget(self, action: #selector(tapPlusButton), for: .touchUpInside)
        cell.minusButton.addTarget(self, action: #selector(tapMinusButton), for: .touchUpInside)
        cell.minusButton.layer.borderWidth = 1
        cell.minusButton.layer.borderColor = UIColor.black.cgColor
        cell.plusButton.layer.borderWidth = 1
        cell.plusButton.layer.borderColor = UIColor.black.cgColor
        
        if cell.textfield.text == stock {
            
            cell.plusButton.alpha = 0.6
            
        }
        
        if cell.textfield.text == "1" {
            
            cell.plusButton.alpha = 1
            cell.plusButton.isUserInteractionEnabled = true
            cell.textfield.alpha = 1
            cell.textfield.isUserInteractionEnabled = true
            cell.minusButton.alpha = 0.2
            cell.minusButton.isUserInteractionEnabled = false
            
        } else if cell.textfield.text == stock {
            
            cell.minusButton.alpha = 1
            cell.minusButton.isUserInteractionEnabled = true
            
            cell.textfield.alpha = 1
            cell.textfield.isUserInteractionEnabled = true
            
            cell.plusButton.alpha = 0.2
            cell.plusButton.isUserInteractionEnabled = false
            
        } else {
            
            cell.plusButton.alpha = 1
            cell.plusButton.isUserInteractionEnabled = true
            
            cell.minusButton.alpha = 1
            cell.minusButton.isUserInteractionEnabled = true
            
            cell.textfield.alpha = 1
            cell.textfield.isUserInteractionEnabled = true
            
        }
        
        self.cell2 = cell
        
        return cell
        
    }
    
    var textfieldnumber: Int = 0
    
    @objc func tapPlusButton (_ sender: UIButton!)  {
        
        let buttonPosition = sender.convert(CGPoint.zero, to: cartTabelVIew)
        
        if let indexPath = cartTabelVIew.indexPathForRow(at: buttonPosition) {
            
            let cell = cartTabelVIew.cellForRow(at: indexPath) as? CartCell
            
            guard let cell = cell,
                  let stockForShow = stockForShow else {return}
            
            if let currentValue = Int(cell.textfield.text!), currentValue < stockForShow {
                textfieldnumber = currentValue + 1
            }
            
            cell.textfield.text = String(textfieldnumber)
            setButtonBorder()
            
            func setButtonBorder() {
                
                guard let textfieldNumber = cell2?.textfield.text else {return}
                
                if cell.textfield.text == "1" {
                    cell.plusButton.alpha = 1
                    cell.plusButton.isUserInteractionEnabled = true
                    cell.textfield.alpha = 1
                    cell.textfield.isUserInteractionEnabled = true
                    cell.minusButton.alpha = 0.2
                    cell.minusButton.isUserInteractionEnabled = false
                    
                    
                } else if Int(cell.textfield.text!)! < stockForShow {
                    
                    cell.plusButton.alpha = 1
                    cell.plusButton.isUserInteractionEnabled = true
                    
                    cell.minusButton.alpha = 1
                    cell.minusButton.isUserInteractionEnabled = true
                    
                    cell.textfield.alpha = 1
                    cell.textfield.isUserInteractionEnabled = true
                    
                } else if cell.textfield.text == String(stockForShow) {
                    
                    cell.minusButton.alpha = 1
                    cell.minusButton.isUserInteractionEnabled = true
                    
                    cell.textfield.alpha = 1
                    cell.textfield.isUserInteractionEnabled = true
                    
                    cell.plusButton.alpha = 0.2
                    cell.plusButton.isUserInteractionEnabled = false
                    
                } else {
                    
                    return
                    
                }
            }
            
            let cartItem = cartItems[indexPath.row]
            
            cartItem.number = String(textfieldnumber)
            
            do {
                
                try (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext.save()
                
                cartItems = try context!.fetch(CartEntity.fetchRequest())
                
            } catch {
                
            }
        }
        
    }
    
    @objc func tapMinusButton (_ sender: UIButton?)  {
        
        guard let buttonPosition = sender?.convert(CGPoint.zero, to: cartTabelVIew) else { return }
        
        if let indexPath = cartTabelVIew.indexPathForRow(at: buttonPosition) {
            
            let cell = cartTabelVIew.cellForRow(at: indexPath) as? CartCell
            
            if let currentValue = Int(cell?.textfield.text ?? ""), currentValue > 1 {
                
                textfieldnumber = currentValue - 1
                
            }
            
            cell?.textfield.text = String(textfieldnumber)
            
            guard let cell = cell else {return}
            
            if cell.textfield.text == "1" {
                
                cell.plusButton.alpha = 1
                cell.plusButton.isUserInteractionEnabled = true
                cell.textfield.alpha = 1
                cell.textfield.isUserInteractionEnabled = true
                cell.minusButton.alpha = 0.2
                cell.minusButton.isUserInteractionEnabled = false
                
            } else if Int((cell2?.textfield.text)!)! < stockForShow! {
                
                cell.plusButton.alpha = 1
                cell.plusButton.isUserInteractionEnabled = true
                
                cell.minusButton.alpha = 1
                cell.minusButton.isUserInteractionEnabled = true
                
                cell.textfield.alpha = 1
                cell.textfield.isUserInteractionEnabled = true
                
            } else {
                
                cell.minusButton.alpha = 1
                cell.minusButton.isUserInteractionEnabled = true
                
                cell.textfield.alpha = 1
                cell.textfield.isUserInteractionEnabled = true
                
                cell.plusButton.alpha = 0.2
                cell.plusButton.isUserInteractionEnabled = false
                
            }
            
            print("-\(String(describing: cell.textfield.text))")
            
            let cartItem = cartItems[indexPath.row]
            
            cartItem.number = String(textfieldnumber)
            
            do {
                
                try (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext.save()
                
                cartItems = try context!.fetch(CartEntity.fetchRequest())
                
            } catch {
                
                print("Failed to save context: \(error)")
                
            }
            
        }
        
    }
    
    
    var rowindex: Int = 0
    
    @objc func removerowButtonClicked (sender : UIButton!) {
        
        rowindex = sender.tag
        
        let fetchRequest:NSFetchRequest = CartEntity.fetchRequest()
        
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            
            guard let cartItems = try context?.fetch(fetchRequest) else {return}
            
            guard rowindex < cartItems.count else {
                
                print("Index out of bounds")
                
                return
                
            }
            
            context?.delete(cartItems[rowindex])
            
            try context?.save()
            
            self.cartItems.remove(at: rowindex)
            
            self.cartTabelVIew.reloadData()
            
        } catch let error {
            
            print("Detele all data in \(CartEntity()) error :", error)
            
        }
        if let tabItems = tabBarController?.tabBar.items {
            
            let tabItem = tabItems[2]
            
            tabItem.badgeColor = .brown
            
            //let cartItemsCount = cartItems.count else {return}
            
            tabItem.badgeValue = String(cartItems.count)
            
        }
        
    }
    
    func setupFooterView() {
        
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.backgroundColor = .white
        footerView.layer.borderWidth = 1
        footerView.layer.borderColor = UIColor.lightGray.cgColor
        view.addSubview(footerView)
        checkoutButton.setTitle("前往結賬", for: .normal)
        checkoutButton.setTitleColor(.white, for: .normal)
        checkoutButton.backgroundColor = UIColor(hex: "443F42" )
        checkoutButton.translatesAutoresizingMaskIntoConstraints = false
        footerView.addSubview(checkoutButton)
        
        
        NSLayoutConstraint.activate([
            
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 160),
            checkoutButton.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            checkoutButton.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 15),
            checkoutButton.widthAnchor.constraint(equalToConstant: 350),
            checkoutButton.heightAnchor.constraint(equalToConstant: 50)
            
        ])
        
        checkoutButton.addTarget(self, action: #selector(tapToCheckoutPage), for: .touchUpInside)
        
    }
    
    
    @objc func tapToCheckoutPage() {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let checkOutPageViewController = storyBoard.instantiateViewController(withIdentifier: "CheckOutPageViewController") as? CheckOutPageViewController
        
        if let navigationController = self.navigationController {
            
            guard let checkOutPageViewController = checkOutPageViewController else {return}
            
            func sendData() {
                
            delegate?.passData(cartItems: cartItems)
                
            }
            
            sendData()
            
            delegate?.passData(cartItems: cartItems)
            
            navigationController.pushViewController(checkOutPageViewController, animated: true)
                        
        } else {
            
            print("NavigationController is nil")
            
        }
        
    }
            
}






