//
//  SectionCell.swift
//  STYLiSH
//
//  Created by 謝霆 on 2024/7/20.
//

import Foundation
import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var iconLabel: UILabel!
}

class CatalogCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var catalogImage: UIImageView!
    
    @IBOutlet weak var catalogTitleLabel: UILabel!
    
    @IBOutlet weak var catalogPriceLabel: UILabel!
}

let profileCellData =
[
    [
    ["Icons_24px_AwaitingPayment", "待付款"],
    ["Icons_24px_AwaitingShipment", "待出貨"],
    ["Icons_24px_Shipped", "待簽收"],
    ["Icons_24px_AwaitingReview", "待評價"],
    ["Icons_24px_Exchange", "退換貨"],
    ],
    [
    ["Icons_24px_Starred", "收藏"],
    ["Icons_24px_Notification", "貨到通知"],
    ["Icons_24px_Refunded", "退戶退款"],
    ["Icons_24px_Address", "地址"],
    ["Icons_24px_CustomerService", "客服訊息"],
    ["Icons_24px_SystemFeedback", "系統回饋"],
    ["Icons_24px_RegisterCellphone", "手機綁定"],
    ["Icons_24px_Settings", "設置"]
    ]
]

var dict2 = Dictionary<String, Int>()

var cartData: [[String: String]] = []




