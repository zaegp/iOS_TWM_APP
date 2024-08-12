//
//  STPaymentInfoTableViewCell.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/7/26.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit
import TPDirect
import Alamofire


private enum PaymentMethod: String {
    
    case creditCard = "信用卡付款"
    
    case cash = "貨到付款"
}

protocol STPaymentInfoTableViewCellDelegate: AnyObject {
    
    func didChangePaymentMethod(_ cell: STPaymentInfoTableViewCell)

    
    func checkout(_ cell:STPaymentInfoTableViewCell)
}

class STPaymentInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var checkOutButton: UIButton!
    
    var tpdForm: TPDForm!
        
    var tpdCard: TPDCard!
    
    @IBOutlet weak var paymentTextField: UITextField! {
        
        didSet {
        
            let shipPicker = UIPickerView()
            
            shipPicker.dataSource = self
            
            shipPicker.delegate = self
            
            paymentTextField.inputView = shipPicker
            
            let button = UIButton(type: .custom)
            
            button.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
            
            button.setBackgroundImage(
                UIImage.asset(.Icons_24px_DropDown),
                for: .normal
            )
            
            button.isUserInteractionEnabled = false
            
            paymentTextField.rightView = button
            
            paymentTextField.rightViewMode = .always
            
            paymentTextField.delegate = self
            
            paymentTextField.text = PaymentMethod.cash.rawValue
        }
    }
    
    func setUpTapPay() {
        
        tpdForm = TPDForm.setup(withContainer: creditView)
        
        tpdForm!.setErrorColor(UIColor(hex: "D62D20"))
        tpdForm!.setOkColor(UIColor(hex: "008744"))
        tpdForm!.setNormalColor(UIColor(hex: "0F0F0F"))
        
        tpdForm!.onFormUpdated { (status) in
            
            weak var weakSelf = self
            
            weakSelf?.checkOutButton.isEnabled = status.isCanGetPrime()
            weakSelf?.checkOutButton.alpha     = (status.isCanGetPrime()) ? 1.0 : 0.25
            
        }
        
        checkOutButton.isEnabled = false
        checkOutButton.alpha     = 0.25
        
    }
    
    
    @IBAction func didTapCheckoutButton(_ sender: UIButton) {

        tpdCard = TPDCard.setup(tpdForm)
        
        tpdCard.onSuccessCallback { (prime, cardInfo, cardIdentifier, merchantReferenceInfo)  in
        
        let result = "Prime : \(prime!),\n card identifier : \(cardIdentifier!),\n merchantReferenceInfo : \(merchantReferenceInfo["affiliateCodes"]!),\nLastFour : \(cardInfo!.lastFour!),\n Bincode : \(cardInfo!.bincode!),\n Issuer : \(cardInfo!.issuer!),\n Issuer_zh_tw : \(cardInfo!.issuerZhTw),\n bank_id : \(cardInfo!.bankId),\n cardType : \(cardInfo!.cardType),\n funding : \(cardInfo!.cardType),\n country : \(cardInfo!.country!),\n countryCode : \(cardInfo!.countryCode!),\n level : \(cardInfo!.level!)"
                
            DispatchQueue.main.async {
                let payment = "Use below cURL to proceed the payment.\ncurl -X POST \\\nhttps://sandbox.tappaysdk.com/tpc/payment/pay-by-prime \\\n-H \'content-type: application/json\' \\\n-H \'x-api-key: partner_6ID1DoDlaPrfHw6HBZsULfTYtDmWs0q0ZZGKMBpp4YICWBxgK97eK3RM\' \\\n-d \'{ \n \"prime\": \"\(prime!)\", \"partner_key\": \"partner_6ID1DoDlaPrfHw6HBZsULfTYtDmWs0q0ZZGKMBpp4YICWBxgK97eK3RM\", \"merchant_id\": \"GlobalTesting_CTBC\", \"details\":\"TapPay Test\", \"amount\": 100, \"cardholder\": { \"phone_number\": \"+886923456789\", \"name\": \"Jane Doe\", \"email\": \"Jane@Doe.com\", \"zip_code\": \"12345\", \"address\": \"123 1st Avenue, City, Country\", \"national_id\": \"A123456789\" }, \"remember\": true }\'"

            }
                
                let recipient = CheckoutRecipient(
                    name: "Luke",
                    phone: "0987654321",
                    email: "luke@gmail.com",
                    address: "市政府站",
                    time: "morning"
                )

                let product = CheckoutProduct(
                    id: "\(merchantReferenceInfo)",
                    name: "活力花紋長筒牛仔褲",
                    price: 1299,
                    color: Color(code: "DDF0FF", name: "淺藍"),
                    size: "M",
                    qty: 1
                )

                let orderDetails = CheckoutDetails(
                    shipping: "delivery",
                    payment: "credit_card",
                    subtotal: 1234,
                    freight: 14,
                    total: 1300,
                    recipient: recipient,
                    list: [product]
                )

                let orderRequest = CheckoutRequest(
                    prime: "\(prime)",
                    order: orderDetails
                )

                let encoder = JSONEncoder()
                encoder.keyEncodingStrategy = .convertToSnakeCase

                
                let url = "https://api.appworks-school.tw/api/1.0/order/checkout"
                let profileToken = defaults.string(forKey: "profileToken")
                
                
                let headers: HTTPHeaders = [
                    "Content-Type": "application/json",
                    "Authorization": "Bearer \(profileToken)"
                ]

                AF.request(url, method: .post, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: ApiResponse.self) { response in
                    
                    switch response.result {
                        
                    case .success(let value):
                        
                        if let checkoutData = value as?ApiResponse {
                            
                            let data = checkoutData.data
                            
                        }
                        
                    case .failure(_):
                        print("fetch checkout data failed")
                        
                    }
                    
                }
            
            weak var weakSelf = self
            
            weakSelf?.showResult(message: result)
            
          
            }.onFailureCallback { (status, message) in
                
                let result = "status : \(status),\n message : \(message)"
                
                weak var weakSelf = self
                
                weakSelf?.showResult(message: result)
                
        }.getPrime()
        
    }
    
    func showResult(message:String!){
        
        let alertController = UIAlertController(title: "Result", message: message, preferredStyle: UIAlertController.Style.alert)
        
        let doneAction = UIAlertAction.init(title: "Done", style: UIAlertAction.Style.default, handler: nil)
          
    }
    
    @IBOutlet weak var cardNumberTextField: UITextField! {
        
        didSet {
            
            cardNumberTextField.delegate = self
        }
    }
    
    @IBOutlet weak var dueDateTextField: UITextField! {
        
        didSet {
            
            dueDateTextField.delegate = self
        }
    }
    
    @IBOutlet weak var verifyCodeTextField: UITextField! {
        
        didSet {
            
            verifyCodeTextField.delegate = self
        }
    }
    
    @IBOutlet weak var productPriceLabel: UILabel!
    
    @IBOutlet weak var shipPriceLabel: UILabel!
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    @IBOutlet weak var productAmountLabel: UILabel!
    
    @IBOutlet weak var topDistanceConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var creditView: UIView! {
        
        didSet {
        
            creditView.isHidden = true
        }
        
        
    }
    
    private let paymentMethod: [PaymentMethod] = [.cash, .creditCard]
    
    weak var delegate: STPaymentInfoTableViewCellDelegate?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
    }
    
    func layoutCellWith(
        productPrice: Int,
        shipPrice: Int,
        productCount: Int
    ) {
        
        productPriceLabel.text = "NT$ \(productPrice)"
        
        shipPriceLabel.text = "NT$ \(shipPrice)"
        
        totalPriceLabel.text = "NT$ \(shipPrice + productPrice)"
        
        productAmountLabel.text = "總計 (\(productCount)樣商品)"
    }
    
    @IBAction func checkout() {
        
        delegate?.checkout(self)
    }
}

extension STPaymentInfoTableViewCell: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    func pickerView(
        _ pickerView: UIPickerView,
        numberOfRowsInComponent component: Int
    ) -> Int
    {
        return 2
    }
    
    func pickerView(
        _ pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int
    ) -> String?
    {
        
        return paymentMethod[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        paymentTextField.text = paymentMethod[row].rawValue
    }
    
    private func manipulateHeight(_ distance: CGFloat) {
        
        topDistanceConstraint.constant = distance
        
        delegate?.didChangePaymentMethod(self)
    }
}

extension STPaymentInfoTableViewCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField != paymentTextField {
            
            passData()
            
            return
        }
        
        guard
            let text = textField.text,
            let payment = PaymentMethod(rawValue: text) else
        {
            
            passData()
            
            return
        }
        
        switch payment {
            
        case .cash:
            
            manipulateHeight(44)
            
            creditView.isHidden = true
            
        case .creditCard:
            
            manipulateHeight(228)
            
            setUpTapPay()
            
            creditView.isHidden = false


        }
        
        passData()
    }
    
    private func passData() {
        
    }
}
