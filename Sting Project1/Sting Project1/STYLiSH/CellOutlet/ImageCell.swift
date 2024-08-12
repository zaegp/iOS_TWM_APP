//
//  ImageCell.swift
//  STYLiSH
//
//  Created by 謝霆 on 2024/7/18.
//

import UIKit

class SingleImageCell: UITableViewCell {
    
    @IBOutlet weak var singleImageText1: UILabel!
    
    @IBOutlet weak var singleImageText2: UILabel!
    
    @IBOutlet weak var singleImage1: UIImageView!
}

class MultiImageCell: UITableViewCell {
    
    @IBOutlet weak var multiImageText1: UILabel!
    
    @IBOutlet weak var multiImageText2: UILabel!
    
    @IBOutlet weak var multiImage1: UIImageView!
    
    @IBOutlet weak var multiImage2: UIImageView!
    
    @IBOutlet weak var multiImage3: UIImageView!
    
    @IBOutlet weak var multiImage4: UIImageView!
    
}

class DetailStoryCell: UITableViewCell {
    
    @IBOutlet weak var storyLabel: UILabel!
}
 
class DetailColorCell: UITableViewCell {
    
    @IBOutlet weak var colorView1: UIView!
    
    @IBOutlet weak var colorView2: UIView!
}

class DetailDescriptionCell: UITableViewCell {
    
    @IBOutlet weak var detailTitle: UILabel!
    
    @IBOutlet weak var detailText: UILabel!
}

class DetailTitleCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var titlePrice: UILabel!
    
    @IBOutlet weak var titleId: UILabel!
}
 
class AddToCartTitleCell: UITableViewCell {
    
    @IBOutlet weak var productNameLabel: UILabel!
    
    @IBOutlet weak var dissmissButton: UIButton!
    
    @IBOutlet weak var productPriceLabel: UILabel!
}

class AddToCartColorCell: UITableViewCell {
    var viewTappedCallback: (() -> Void)?

    @IBOutlet weak var colorView1: UIView!
    
    @IBOutlet weak var colorView2: UIView!
    
    @IBOutlet weak var colorView3: UIView!

    @objc private func viewTapped() {
        
            viewTappedCallback?()
        
        }
    
}
class AddToCartSizeCell: UITableViewCell {
    

    @IBOutlet weak var size1: UIView!
    
    @IBOutlet weak var size2: UIView!
    
    @IBOutlet weak var size3: UIView!
    
    @IBOutlet weak var size1Label: UILabel!
    
    @IBOutlet weak var size2Label: UILabel!
    
    @IBOutlet weak var size3Label: UILabel!
    
}
class CartCell: UITableViewCell, UITextFieldDelegate {
    

    
    @IBAction func didtapremove(_ sender: Any) {
    }
    
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var productLabel: UILabel!
    
    @IBOutlet weak var productColor: UIView!
    
    @IBOutlet weak var productSize: UILabel!
    
    @IBOutlet weak var removeButton: UIButton!
    
    @IBOutlet weak var producrPrice: UILabel!
    
    @IBOutlet weak var textfield: UITextField!
    
    @IBOutlet weak var minusButton: UIButton!
    
    @IBOutlet weak var plusButton: UIButton!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        textfield.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(notification:)), name: UITextField.textDidChangeNotification, object: textfield)
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: textfield)
    }
    
    var textfieldnumber: Int = 1

    var stockForShow: Int? {
        
        didSet {
            
            validateValue()
            }
        
        }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.isEmpty {
            
                    return true
            
                }
        
        let currentText = textfield.text ?? ""

        guard let range = Range(range, in: currentText) else {
                    return false
                }
        
        let newText = currentText.replacingCharacters(in: range, with: string)
        
        guard let newValue = Int(newText),let stockForShow = stockForShow,newValue >= 1 && newValue <= stockForShow else {
            
                    return false
            
                }
        
                return true
        
        }
    
    func validateValue() {
        
        if let currentValue = Int(textfield.text ?? ""), currentValue >= 1 && textfieldnumber <= stockForShow ?? 0 {
            
            } else {
                
                textfield.text = "1"
                
            }
        }
    

        func textField(_ textField: UITextField, shouldPasteWithSender sender: Any?) -> Bool {
            
            return false
            
        }
    
    @objc func textFieldDidChange(notification: NSNotification) {
        
        guard let textField = notification.object as? UITextField, textField == self.textfield else {
            
            return
            
        }
        
        if let text = textField.text, let number = Int(text) {
            
            textfieldnumber = number
            
            guard let stockForShow = stockForShow else{return}
            
            if textfieldnumber >= stockForShow {
                
                textfield.text = String(stockForShow)
                
                plusButton.isUserInteractionEnabled = false
                
                plusButton.alpha = 0.6
                
            } else if  textfieldnumber < 1 {
                
                textfield.text = "1"
                
                minusButton.isUserInteractionEnabled = false
                
            } else {
                
                textfieldnumber = stockForShow
                
                textfield.text = String(textfieldnumber)
                
                plusButton.alpha = 0.6
                
            }
            
        } else {
            
            textField.text = "\(1)"
            
        }
 
    }

}

class AddToCartNumberCell: UITableViewCell {
    
    weak var delegate: StockNumberDelegate?

    let addToCartViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddToCartViewController") as? AddToCartViewController
    
    func passData(data: String) {
        
        addToCartViewController?.cell2?.stockNumber.text = "庫存： \(data)"
        
        addToCartViewController?.cell2?.stockNumber.isHidden = false

    }
    var textfieldnumber: Int = 1
 
    @IBOutlet weak var plusbutton: UIButton!
    
    @IBOutlet weak var minusbutton: UIButton!
    
    @IBAction func didTapMinusButton(_ sender: UIButton) {

    }
    
    @IBAction func didTapPlusButton(_ sender: Any) {
        
    }
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var stockNumber: UILabel!
}

