//
//  STUserInputCell.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/7/25.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit

protocol STOrderUserInputCellDelegate: AnyObject {
    
    func didChangeUserData(
        _ cell: STOrderUserInputCell,
        username: String,
        email: String,
        phoneNumber: String,
        address: String,
        shipTime: String,
        textFieldIsFilled: Bool
    )
}

class STOrderUserInputCell: UITableViewCell {

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var shipTimeSelector: UISegmentedControl!
    
    weak var delegate: STOrderUserInputCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        phoneTextField.delegate = self
        addressTextField.delegate = self
        // Initialization code
        
        nameTextField.addTarget(self, action:  #selector(textFieldDidChange(_:)), for: .allEditingEvents)
        emailTextField.addTarget(self, action:  #selector(textFieldDidChange(_:)), for: .allEditingEvents)
        phoneTextField.addTarget(self, action:  #selector(textFieldDidChange(_:)), for: .allEditingEvents)
        addressTextField.addTarget(self, action:  #selector(textFieldDidChange(_:)), for: .allEditingEvents)
        

    }

    var textFieldIsFilled: Bool? = false
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        NotificationCenter.default.post(name: Notification.Name("CheckTextFieldIsFilled"), object: self)
    }
    
    
    
    
}

extension STOrderUserInputCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder() // 讓 textField 失去焦點
        emailTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        addressTextField.resignFirstResponder()
            return true
        }
    


    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard
            let name = nameTextField.text,
            let email = emailTextField.text,
            let phoneNumber = phoneTextField.text,
            let address = addressTextField.text,
            let shipTime = shipTimeSelector.titleForSegment(at: shipTimeSelector.selectedSegmentIndex)
          
        else
        {
            return
        }
        
         textFieldIsFilled = !(nameTextField.text?.isEmpty ?? true) &&
        !(emailTextField.text?.isEmpty ?? true) &&
        !(phoneTextField.text?.isEmpty ?? true) &&
        !(addressTextField.text?.isEmpty ?? true)

        
        delegate?.didChangeUserData(
            self,
            username: name,
            email: email,
            phoneNumber: phoneNumber,
            address: address,
            shipTime: shipTime, 
            textFieldIsFilled: textFieldIsFilled!
        )
    }
}

class STOrderUserInputTextField: UITextField {
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        addUnderLine()
    }
    
    private func addUnderLine() {
        
        let underline = UIView()
        
        underline.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(underline)
        
        NSLayoutConstraint.activate([
            
            leadingAnchor.constraint(equalTo: underline.leadingAnchor),
            trailingAnchor.constraint(equalTo: underline.trailingAnchor),
            bottomAnchor.constraint(equalTo: underline.bottomAnchor),
            underline.heightAnchor.constraint(equalToConstant: 1.0)
        ])
        
        underline.backgroundColor = UIColor(hex: "cccccc")
    }
}
