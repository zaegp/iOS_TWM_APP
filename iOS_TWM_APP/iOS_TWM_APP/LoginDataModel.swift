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


// MARK: - GymDetailData
struct GymDetailData: Codable {
    let id: Int
    let gymType, name, addr, operationTel: String?
    let webURL: String?
    let parkType: String?
    let enableYear, enableMonth: Int?
    let introduction, contest: String?
    let contestIntro: String?
    let lat, lng: Double?
    let photo1URL, photo2URL: String?
    let passEasyEle: Int?
    let passEasyElePhotoURL: String?
    let passEasyFuncOthers: String?
    let passEasyParking: Int?
    let passEasyParkingPhotoURL: String?
    let passEasyShower: Int?
    let passEasyShowerPhotoURL: String?
    let passEasyToilet: Int?
    let passEasyToiletPhotoURL: String?
    let passEasyWay: Int?
    let passEasyWayPhotoURL: String?
    let wheelchairAuditorium: Int?
    let wheelchairAuditoriumPhotoURL: String?
    let publicTransport, declaration: String?
    let declarationURL: JSONNull?
    let rate: Double?
    let rateCount: Int?

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case gymType = "GymType"
        case name = "Name"
        case addr = "Addr"
        case operationTel = "OperationTel"
        case webURL = "WebUrl"
        case parkType = "ParkType"
        case enableYear = "EnableYear"
        case enableMonth = "EnableMonth"
        case introduction = "Introduction"
        case contest = "Contest"
        case contestIntro = "ContestIntro"
        case lat = "Lat"
        case lng = "Lng"
        case photo1URL = "Photo1Url"
        case photo2URL = "Photo2Url"
        case passEasyEle = "PassEasyEle"
        case passEasyElePhotoURL = "PassEasyElePhotoUrl"
        case passEasyFuncOthers = "PassEasyFuncOthers"
        case passEasyParking = "PassEasyParking"
        case passEasyParkingPhotoURL = "PassEasyParkingPhotoUrl"
        case passEasyShower = "PassEasyShower"
        case passEasyShowerPhotoURL = "PassEasyShowerPhotoUrl"
        case passEasyToilet = "PassEasyToilet"
        case passEasyToiletPhotoURL = "PassEasyToiletPhotoUrl"
        case passEasyWay = "PassEasyWay"
        case passEasyWayPhotoURL = "PassEasyWayPhotoUrl"
        case wheelchairAuditorium = "WheelchairAuditorium"
        case wheelchairAuditoriumPhotoURL = "WheelchairAuditoriumPhotoUrl"
        case publicTransport = "PublicTransport"
        case declaration = "Declaration"
        case declarationURL = "DeclarationUrl"
        case rate = "Rate"
        case rateCount = "RateCount"
    }
}


