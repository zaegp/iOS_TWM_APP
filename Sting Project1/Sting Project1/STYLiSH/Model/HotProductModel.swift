//
//  HotProductModel.swift
//  STYLiSH
//
//  Created by 謝霆 on 2024/7/18.
//

import Foundation

    struct HotProduct: Codable, Product {
        let id: Int
        let category, title, description: String
        let price: Int
        let texture, wash, place, note, story: String
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
    
    struct Color: Codable {
        let code, name: String
    }
    
    struct Variant: Codable {
        let colorCode, size: String
        let stock: Int
        
        enum CodingKeys: String, CodingKey {
            case colorCode = "color_code"
            case size, stock
        }
        
    }
    
    struct MarketingHot: Codable {
        let title: String
        let products: [HotProduct]
    }
    
    struct MarketingHotsResponse: Decodable {
        let data: [MarketingHot]
    }
    


