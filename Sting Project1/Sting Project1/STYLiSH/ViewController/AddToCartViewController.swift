//
//  AddToCartViewController.swift
//  STYLiSH
//
//  Created by 謝霆 on 2024/7/28.
//

import UIKit
import StatusAlert
import CoreData


class AddToCartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, StockNumberDelegate {
    
    //var addToCartNumberCell = AddToCartNumberCell()
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedProduct: Product?
    
    var selectedView: UIView?
    
    var sizeSelectedView: UIView?
    
    var minValue = 1
    
    var isSizeCellEnabled = false
    
    var textfieldnumber = 1
    
    weak var delegate:  (StockNumberDelegate)?
    
    var sizeCell = AddToCartSizeCell()
    
    var cell2: AddToCartNumberCell?
    
    var colorCell: AddToCartColorCell?
    
    var stockForShow = 0
    
    let cartButton: UIButton = {
        
        let button = UIButton(type: .system)
        
        button.setTitle("加入購物車", for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
        
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        tableView.delegate = self
        
        self.modalPresentationStyle = .overCurrentContext
        
        self.modalTransitionStyle = .crossDissolve
        
        tableView.separatorStyle = .none
        
        view.addSubview(cartButton)
        
        cartButtonConfig()
        
        let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name("DidDismissAddToCartPage"), object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: nil)
        
    }
    
    
    func cartButtonConfig () {
        
        cartButton.setTitle("加入購物車", for: .normal)
        
        cartButton.setTitleColor(.white, for: .normal)
        
        cartButton.backgroundColor = UIColor(hex: "443F42" )
        
        cartButton.isHidden = true
        
        let didTapAddToCart = UITapGestureRecognizer(target: self, action: #selector(self.didTapAddToCart(_:)))
        
        cartButton.addGestureRecognizer(didTapAddToCart)
        
        NSLayoutConstraint.activate([
            
            cartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            
            cartButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            cartButton.widthAnchor.constraint(equalToConstant: 350),
            
            cartButton.heightAnchor.constraint(equalToConstant: 50)
            
        ])
    }
    
    @IBAction func tapDismiss(_ sender: Any) {
        
        NotificationCenter.default.post(name: Notification.Name("DidDismissAddToCartPage"), object: nil)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
    }
    
    
    @objc func dismissDropdownView() {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddToCartTitleCell", for: indexPath) as? AddToCartTitleCell,
            let selectedProduct = selectedProduct else {return UITableViewCell()}
            
            cell.productNameLabel.text = selectedProduct.title
            
            cell.productPriceLabel.text = "NT $\(selectedProduct.price)"
            
            cell.selectionStyle = .none
            
            return cell
            
        } else if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddToCartColorCell", for: indexPath) as? AddToCartColorCell
            
            cell?.viewTappedCallback = {[weak self] in
                
                self?.enableSizeCell()
                
            }
            
            guard let cell = cell,
            let selectedProduct = selectedProduct else{return UITableViewCell()}
            
            if selectedProduct.colors.count == 1 {
                
                let color1 = selectedProduct.colors[0].code
                
                cell.colorView1.backgroundColor = UIColor(hex: color1)
                
                cell.colorView2.isHidden = true
                
                cell.colorView3.isHidden = true
                
                let tapGesture5 = UITapGestureRecognizer(target: self, action: #selector(self.tapColorButton(_:)))
                
                cell.colorView1.addGestureRecognizer(tapGesture5)
                
                cell.colorView1.isUserInteractionEnabled = true
                
                
            } else if selectedProduct.colors.count == 2 {
                
                let color1 = selectedProduct.colors[0].code
                
                let color2 = selectedProduct.colors[1].code
                
                cell.colorView1.backgroundColor = UIColor(hex: color1)
                
                cell.colorView2.backgroundColor = UIColor(hex: color2)
                
                cell.colorView3.isHidden = true
                
                let tapGesture6 = UITapGestureRecognizer(target: self, action: #selector(self.tapColorButton(_:)))
                
                cell.colorView2.addGestureRecognizer(tapGesture6)
                
                cell.colorView2.isUserInteractionEnabled = true
                
                let tapGesture7 = UITapGestureRecognizer(target: self, action: #selector(self.tapColorButton(_:)))
                
                cell.colorView1.addGestureRecognizer(tapGesture7)
                
                cell.colorView1.isUserInteractionEnabled = true
                
            } else {
                
                let color1 = selectedProduct.colors[0].code
                
                let color2 = selectedProduct.colors[1].code
                
                let color3 = selectedProduct.colors[2].code
                
                cell.colorView1.backgroundColor = UIColor(hex: color1)
                
                cell.colorView2.backgroundColor = UIColor(hex: color2)
                
                cell.colorView3.backgroundColor = UIColor(hex: color3)
                
                let tapGesture5 = UITapGestureRecognizer(target: self, action: #selector(self.tapColorButton(_:)))
                
                cell.colorView1.addGestureRecognizer(tapGesture5)
                
                cell.colorView1.isUserInteractionEnabled = true
                
                let tapGesture6 = UITapGestureRecognizer(target: self, action: #selector(self.tapColorButton(_:)))
                
                cell.colorView2.addGestureRecognizer(tapGesture6)
                
                cell.colorView2.isUserInteractionEnabled = true
                
                let tapGesture7 = UITapGestureRecognizer(target: self, action: #selector(self.tapColorButton(_:)))
                
                cell.colorView3.addGestureRecognizer(tapGesture7)
                
                cell.colorView3.isUserInteractionEnabled = true
                
            }
            
            cell.colorView1.tag = 0
            
            cell.colorView2.tag = 1
            
            cell.colorView3.tag = 2
            
            cell.selectionStyle = .none
            
            return cell
            
        } else if indexPath.section == 2 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddToCartSizeCell", for: indexPath) as? AddToCartSizeCell else {return AddToCartSizeCell()}
            
            cell.isUserInteractionEnabled = isSizeCellEnabled
            
            if selectedProduct?.sizes.count == 1 {
                
                cell.size2.isUserInteractionEnabled = true
                
                cell.size2.isHidden = true
                
                cell.size2Label.isHidden = true
                
                cell.size3.isHidden = true
                
                cell.size3Label.isHidden = true
                
                let size1 = selectedProduct?.sizes[0]
                
                cell.size1Label.text = size1
                
            } else if selectedProduct?.sizes.count == 2 {
                
                cell.size3.isHidden = true
                
                cell.size3Label.isHidden = true
                
                cell.size2.isHidden = false
                
                cell.size2Label.isHidden = false
                
                let size1 = selectedProduct?.sizes[0]
                
                let size2 = selectedProduct?.sizes[1]
                
                cell.size1Label.text = size1
                
                cell.size2Label.text = size2
                
            } else {
                cell.size3.isHidden = false
                
                cell.size3Label.isHidden = false
                
                cell.size2.isHidden = false
                
                cell.size2Label.isHidden = false
                
                let size1 = selectedProduct?.sizes[0]
                
                let size2 = selectedProduct?.sizes[1]
                
                let size3 = selectedProduct?.sizes[2]
                
                cell.size1Label.text = size1
                
                cell.size2Label.text = size2
                
                cell.size3Label.text = size3
                
            }
            
            
            let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(self.tapSizeButton(_:)))
            
            cell.size1.addGestureRecognizer(tapGesture1)
            
            let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(self.tapSizeButton(_:)))
            
            cell.size2.addGestureRecognizer(tapGesture2)
            
            let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(self.tapSizeButton(_:)))
            
            cell.size3.addGestureRecognizer(tapGesture3)
            
            cell.size1.tag = 0
            
            cell.size2.tag = 1
            
            cell.size3.tag = 2
            
            cell.selectionStyle = .none
            
            self.sizeCell = cell
            
            return cell
            
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddToCartNumberCell", for: indexPath) as? AddToCartNumberCell else {return AddToCartNumberCell()}
            
            NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange), name: UITextField.textDidChangeNotification, object: nil)
            
            func passData(data: String) {
                
                cell.stockNumber.text = data
                
            }
            
            cell.delegate = self
            
            cell.textField.keyboardType = .numberPad
            
            cell.textField.textAlignment = .center
            
            cell.minusbutton.layer.borderWidth = 1
            
            cell.minusbutton.layer.borderColor = UIColor.gray.cgColor
            
            cell.minusbutton.isUserInteractionEnabled = true
            
            cell.plusbutton.layer.borderWidth = 1
            
            cell.plusbutton.layer.borderColor = UIColor.gray.cgColor
            
            cell.plusbutton.isUserInteractionEnabled = true
            
            cell.textField.layer.borderWidth = 1
            
            cell.textField.layer.borderColor = UIColor.gray.cgColor
            
            cell.textField.isUserInteractionEnabled = true
            
            cell.minusbutton.alpha = 0.8
            
            cell.plusbutton.alpha = 0.8
            
            cell.textField.alpha = 0.8
            
            cell.textField.text = "\(textfieldnumber)"
            
            cell.stockNumber.text = "庫存 ： \(stockForShow)"
            
            let tapMinusButton = UITapGestureRecognizer(target: self, action: #selector(self.tapMinusButton(_:)))
            
            
            let tapPlusButton = UITapGestureRecognizer(target: self, action: #selector(self.tapPlusButton(_:)))
            
            cell.plusbutton.addGestureRecognizer(tapPlusButton)
            
            cell.minusbutton.addGestureRecognizer(tapMinusButton)
            
            cell.stockNumber.isHidden = true
            
            cell.selectionStyle = .none
            
            cell.textField.isUserInteractionEnabled = false
            
            self.cell2 = cell
            
            reloadInputViews()
            
            return cell
        }
        
    }
    
    func passData(data: String) {
        
        cell2?.stockNumber.text = "庫存 ： \(stockForShow)"
        
    }
    
    func enableSizeCell() {
        
        isSizeCellEnabled = true
        
        if let sizeCellview = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) {
            
            sizeCellview.isUserInteractionEnabled = true
            
        }
    }
    
    var colorData: String?
    
    var productData: String?
    
    var imageData: String?
    
    var sizeData: String?
    
    var priceData: Int64 = 0
    
    var titleData: String?
    
    var colorrowIndex: Int?
    
    var sizerowIndex: Int?
    
    var addToCartDictionary:[String: String] = [:]
    
    @objc func tapColorButton(_ sender: UITapGestureRecognizer) {
        
        guard let tappedView = sender.view,
        let selectedProduct = selectedProduct else { return }
        
        addToCartDictionary["color"] = " "
        addToCartDictionary["title"] = " "
        addToCartDictionary["image"] = " "
        addToCartDictionary["price"] = " "
        
        
        colorrowIndex = tappedView.tag
        
        colorData = selectedProduct.colors[colorrowIndex!].code
        
        productData = selectedProduct.title
        
        imageData = selectedProduct.mainImage
        
        priceData = Int64(selectedProduct.price)
        
        titleData = selectedProduct.title
        
        let sizeCellview = tableView.cellForRow(at: IndexPath(row: 0, section: 2))
        
        isSizeCellEnabled = true
        
        let variantsforstock = selectedProduct.variants.count
        
        let variant = selectedProduct.variants
        
        let sizes = [sizeCell.size1, sizeCell.size2, sizeCell.size3]
        
        func hiddenSize () {
            
            for i in 0 ..< variantsforstock {
                
                if variant[i].colorCode == colorData && variant[i].stock == 0 {
                    
                    let sizeValue = variant[i].size

                    if sizeValue == "S" {
                        guard let sizeButton = sizes[0] else { return }
                        sizeButton.alpha = 0.6
                        sizeButton.isUserInteractionEnabled = false
                    } else if sizeValue == "M" {
                        guard let sizeButton = sizes[1] else { return }
                        sizeButton.alpha = 0.6
                        sizeButton.isUserInteractionEnabled = false
                    } else {
                        guard let sizeButton = sizes[2] else { return }
                        sizeButton.alpha = 0.6
                        sizeButton.isUserInteractionEnabled = false
                    }                }
            }
        }
        
        hiddenSize ()
        addToCartDictionary["color"] = "\(colorData)"
        addToCartDictionary["title"] = "\(productData)"
        addToCartDictionary["image"] = "\(imageData)"
        addToCartDictionary["price"] = "\(String(priceData))"
        
        
        func showsize() {
            
            sizes[0]?.isUserInteractionEnabled = true
            sizes[0]?.alpha = 1
            sizes[1]?.isUserInteractionEnabled = true
            sizes[1]?.alpha = 1
            sizes[2]?.isUserInteractionEnabled = true
            sizes[2]?.alpha = 1
        }
        
        sizes[0]?.layer.borderWidth = 0
        sizes[2]?.layer.borderWidth = 0
        sizes[1]?.layer.borderWidth = 0
        
        sizeCellview?.isUserInteractionEnabled = true
        cell2?.stockNumber.isHidden = true
        cartButton.isHidden = true
        
        if let currentSelectedView = selectedView {
            currentSelectedView.layer.borderWidth = 0
            
        }
        
        if tappedView == selectedView {
            selectedView = nil
            
        } else {
            showsize()
            selectedView = tappedView
            selectedView?.layer.borderWidth = 1
            selectedView?.layer.borderColor = UIColor.black.cgColor
            hiddenSize ()
            
        }
        
    }
    
    func textfieldBorder(){
        
        guard let textfield = cell2?.textField.text else {return}
        
        if textfield == "1" {
            
            cell2?.plusbutton.layer.borderColor = UIColor.black.cgColor
            cell2?.plusbutton.isUserInteractionEnabled = true
            
            cell2?.textField.layer.borderColor = UIColor.black.cgColor
            cell2?.textField.isUserInteractionEnabled = true
            
            cell2?.minusbutton.layer.borderColor = UIColor.gray.cgColor
            cell2?.minusbutton.isUserInteractionEnabled = false
            
            
        } else if let textfieldInt = Int(textfield), textfieldInt < stockForShow {
            cell2?.plusbutton.layer.borderColor = UIColor.black.cgColor
            cell2?.plusbutton.isUserInteractionEnabled = true
            
            cell2?.minusbutton.layer.borderColor = UIColor.black.cgColor
            cell2?.minusbutton.isUserInteractionEnabled = true
            
            cell2?.textField.layer.borderColor = UIColor.black.cgColor
            cell2?.textField.isUserInteractionEnabled = true
            
        } else {
            
            cell2?.minusbutton.layer.borderColor = UIColor.black.cgColor
            cell2?.minusbutton.isUserInteractionEnabled = true
            
            cell2?.textField.layer.borderColor = UIColor.black.cgColor
            cell2?.textField.isUserInteractionEnabled = true
            
            cell2?.plusbutton.layer.borderColor = UIColor.gray.cgColor
            cell2?.plusbutton.isUserInteractionEnabled = false
            
        }
        
    }
    
    func addCoreData() {
        
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {return}
        
        let cartCoreData = CartEntity(context: context)
        
        cartCoreData.title = productData
        cartCoreData.image = imageData
        cartCoreData.color = colorData
        cartCoreData.number = String(textfieldnumber)
        cartCoreData.size = sizeData
        cartCoreData.price = String(priceData)
        cartCoreData.stock = String(stockForShow)
        
        do {
            
            try context.save()
            
        } catch {
            
            print("error-Saving data")
            
        }
    }
    
    
    @objc func tapSizeButton(_ sender: UITapGestureRecognizer) {
        
        addToCartDictionary["size"] = " "
        
        guard let sizeTappedView = sender.view else { return }
        
        sizerowIndex = sizeTappedView.tag
        
        guard let sizeData = selectedProduct?.sizes[sizerowIndex!],
        let selectedProduct = selectedProduct else {return}
        
        cartButton.isHidden = false
        
        cell2?.stockNumber.isHidden = false
        
        let variantsforstock = selectedProduct.variants.count
        
        let variant = selectedProduct.variants
        
        isSizeCellEnabled = true
        
        for i in 0 ..< variantsforstock {
            
            if variant[i].colorCode == colorData && variant[i].size == sizeData{
                
                stockForShow = (selectedProduct.variants[i].stock)
                
            }
        }
        
        
        cell2?.delegate?.passData(data: String(stockForShow))
        
        cell2?.textField.isUserInteractionEnabled = true
        
        cell2?.textField.text = "1"
        
        addToCartDictionary["size"] = "\(sizeData ?? " ")"
        
        if let sizeCurrentSelectedView = sizeSelectedView {
            
            sizeCurrentSelectedView.layer.borderWidth = 0
            
        }
        
        if sizeTappedView == sizeSelectedView {
            
            sizeSelectedView = nil
            
            cell2?.stockNumber.isHidden = true
            
            cartButton.isHidden = true
            
        } else {
            sizeSelectedView = sizeTappedView
            
            sizeSelectedView?.layer.borderWidth = 1
            
            sizeSelectedView?.layer.borderColor = UIColor.black.cgColor
            
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleStockUpdate(_:)), name: Notification.Name("didUpdateStock"), object: nil)
        
        textfieldBorder()
        
    }
    
    
    
    @objc func handleStockUpdate(_ notification: Notification) {
        
        if let stock = notification.userInfo?["stockForShow"] as? Int {
            
            self.stockForShow = stock
        }
    }
    
    
    @objc func tapPlusButton (_ sender: UITapGestureRecognizer)  {
        
        guard let texfieldText = cell2?.textField.text else {return}
        
        if let currentValue = Int(texfieldText), currentValue < stockForShow {
            
            textfieldnumber = currentValue + 1
            
        }
        
        cell2?.textField.text = String(textfieldnumber)
        
        textfieldBorder()
        
    }
    
    
    @objc func tapMinusButton (_ sender: UITapGestureRecognizer)  {
        
        guard let texfieldText = cell2?.textField.text else {return}
        
        if let currentValue = Int(texfieldText), currentValue > 1 {
            
            textfieldnumber = currentValue - 1
            
        }
        
        cell2?.textField.text = String(textfieldnumber)
        
        textfieldBorder()
    }
    
    @objc func didTapAddToCart(_ sender: UITapGestureRecognizer) {
        
        addToCartDictionary["number"] = ""
        
        let statusAlert = StatusAlert()
        
        statusAlert.image = UIImage(named: "Icons_44px_Success01")
        statusAlert.title = "success"
        statusAlert.appearance.tintColor = .white
        statusAlert.appearance.backgroundColor = .darkGray
        statusAlert.canBePickedOrDismissed =  true
        
        addToCartDictionary["number"] = "\(textfieldnumber)"
        
        cartData.append(addToCartDictionary)
        
        addCoreData()
        
        statusAlert.showInKeyWindow()
    }
    
}

protocol StockNumberDelegate: AnyObject {
    
    func passData(data: String)
    
}


extension AddToCartViewController: UITextFieldDelegate {
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.isEmpty {
            
            return true
            
        }
        
        let currentText = cell2?.textField.text ?? ""
        
        guard let range = Range(range, in: currentText) else {
            
            return false
            
        }
        
        
        let newText = currentText.replacingCharacters(in: range, with: string)
        
        if let newValue = Int(newText), newValue >= minValue && newValue <= stockForShow {
            
            return true
            
        }
        
        return false
        
    }
    
    func validateValue() {
        
        guard let texfieldText = cell2?.textField.text else {return}
        
        if let currentValue = Int(texfieldText), currentValue >= minValue && textfieldnumber <= stockForShow {
            
        } else {
            
            cell2?.textField.text = "\(minValue)"
        }
    }
    
    
    func textField(_ textField: UITextField, shouldPasteWithSender sender: Any?) -> Bool {
        
        return false
        
    }
    
    @objc func textFieldDidChange(notification: NSNotification) {
        
        if let textField = notification.object as? UITextField, textField  == cell2?.textField {
            
            guard let textfield = textField.text,
            let textfieldNumber = Int(textfield) else {return}
                        
            if textfieldnumber >= stockForShow {
                
                cell2?.textField.text = String(stockForShow)
                
                cell2?.plusbutton.isUserInteractionEnabled = false
                
            } else if  textfieldnumber < 1 {
                
                cell2?.textField.text = "1"
                
                cell2?.minusbutton.isUserInteractionEnabled = false
                
            } else {
                
                textfieldnumber = stockForShow
                
                cell2?.textField.text = String(textfieldnumber)
                
            }
            
        }
        
    }
        
}
