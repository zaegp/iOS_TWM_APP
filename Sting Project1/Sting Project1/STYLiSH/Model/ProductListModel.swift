//
//  ProductListModel.swift
//  STYLiSH
//
//  Created by 謝霆 on 2024/7/23.
//

import Foundation

protocol Product {
    var id: Int { get }
    var category: String { get }
    var title: String { get }
    var description: String { get }
    var price: Int { get }
    var texture: String { get }
    var wash: String { get }
    var place: String { get }
    var note: String { get }
    var story: String { get }
    var colors: [Color] { get }
    var sizes: [String] { get }
    var variants: [Variant] { get }
    var mainImage: String { get }
    var images: [String] { get }
    
}

    
    struct ProductListApiResponse: Codable {
        let data: [ProductListProduct]
        let nextPaging: Int?
        
        enum CodingKeys: String, CodingKey {
            case data
            case nextPaging = "next_paging"
        }
    }
    
    struct ProductListProduct: Codable, Product {
        let id: Int
        let category: String
        let title: String
        let description: String
        let price: Int
        let texture: String
        let wash: String
        let place: String
        let note: String
        let story: String
        let colors: [Color]
        let sizes: [String]
        let variants: [Variant]
        let mainImage: String
        let images: [String]
        
        enum CodingKeys: String, CodingKey {
                case id, category, title, description, price, texture, wash, place, note, story, colors, sizes, variants
                case mainImage = "main_image"
                case images
            }
    }

    
    struct ProductListColor: Codable {
        let code: String
        let name: String
    }
    
    struct ProductListVariant: Codable {
        let colorCode: String
        let size: String
        let stock: Int
        
        enum CodingKeys: String, CodingKey {
            case colorCode = "color_code"
            case size
            case stock
        }
    }

struct ApiResponse: Codable {
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let accessToken, accessExpired, loginAt: String
    let user: User

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case accessExpired = "access_expired"
        case loginAt = "login_at"
        case user
    }
}

// MARK: - User
struct User: Codable {
    let id: Int
    let provider, name, email: String
    let picture: String
}

struct ProfileApiResponse: Codable {
    let data: ProfileData
}

// MARK: - DataClass
struct ProfileData: Codable {
    let provider, name, email: String
    let picture: String
}

struct OrderCheckout: Codable {
    let prime: String
    let order: OrderDetails
}

struct OrderDetails: Codable {
    let shipping: String
    let payment: String
    let subtotal: Int
    let freight: Int
    let total: Int
    let recipient: RecipientDetails
    let list: [OrderItem]
}

struct RecipientDetails: Codable {
    let name: String
    let phone: String
    let email: String
    let address: String
    let time: String
}

struct OrderItem: Codable {
    let id: String
    let name: String
    let price: Int
    let color: ItemColor
    let size: String
    let qty: Int
}

struct ItemColor: Codable {
    let name: String
    let code: String
}


// MARK: - Root Struct
struct CheckoutRequest: Codable {
    let prime: String
    let order: CheckoutDetails
}

// MARK: - OrderDetails
struct CheckoutDetails: Codable {
    let shipping: String
    let payment: String
    let subtotal: Int
    let freight: Int
    let total: Int
    let recipient: CheckoutRecipient
    let list: [CheckoutProduct]
}

// MARK: - Recipient
struct CheckoutRecipient: Codable {
    let name: String
    let phone: String
    let email: String
    let address: String
    let time: String
}

// MARK: - Product
struct CheckoutProduct: Codable {
    let id: String
    let name: String
    let price: Int
    let color: Color
    let size: String
    let qty: Int
}

// MARK: - Color
struct CheckoutColor: Codable {
    let code: String
    let name: String
}
