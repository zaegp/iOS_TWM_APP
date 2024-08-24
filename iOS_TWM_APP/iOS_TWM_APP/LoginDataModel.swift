//
//  LoginDataModel.swift
//  iOS_TWM_APP
//
//  Created by 小妍寶 on 2024/8/23.
//

import Foundation

struct Register: Codable {
    let userName, email, password: String
}


struct Login: Codable {
    let accessToken, tokenType: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
    }
    
    
}


// MARK: - MockData
struct MockData: Codable {
    let deviceName: String
    let power: Int
    let trackingModeColor, connected, connectStatus: String
    let step: Int
    let lockMode: String
}

