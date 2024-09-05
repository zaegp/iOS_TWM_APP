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
    let deviceName: String?
    let power: Int?
    let trackingModeColor, connected, connectStatus: String?
    let step: Int?
    let lockMode: String?
    let frequency: String?
}



// MARK: - GymDetailData
struct GymDetailData: Codable {
    let id: Int?
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
    let declarationURL: String?
    let rate: Double?
    let rateCount: Int?
    let gymFuncData: [GymFuncDatum]?
    
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
        case gymFuncData = "GymFuncData"
    }
}

// MARK: - GymFuncDatum
struct GymFuncDatum: Codable {
    let id: Int?
    let name, gymType, inOut, floor: String?
    let air, sale: Bool?
    let saleContent: String?
    let seat: Bool?
    let seatNum: Int?
    let showers, wc, dressingRoom, instructor: Bool?
    let light, lounge, fitAll, fitInter: Bool?
    let photo1: String?
    let photo2: String?
    let openState, openTime: String?
    let openDayMon, openDayTue, openDayWed, openDayThu: Bool?
    let openDayFri, openDaySat, openDaySun: Bool?
    let openCharge, restRemark: Bool?
    let rentState, rentCharge, rentContantorDep, rentContantorEmail: String?
    let rentContantorFax, rentContantorName, rentContantorTel: String?
    let rentURL: String?
    let passEasyUseItem: Bool?
    let passEasyUseItemPhotoURL: String?
    let passEasyForChild: Bool?
    let passEasyForChildPhotoURL: String?
    let passEasyIntoSwim: Bool?
    let passEasyIntoSwimPhotoURL: String?
    let passEasyIntoSwimChar: Bool?
    let passEasyIntoSwimCharPhotoURL, passEasyOthers: String?
    let passEasyLightAlert: Bool?
    let passEasyLightAlertPhotoURL: String?
    let passEasyComm, gameRadio: Bool?
    let gameRadioPhotoURL: String?
    let passEasyRemote: Bool?
    let passEasyRemotePhotoURL: String?
    let passEasyWizard: Bool?
    let passEasyWizardPhotoURL: String?
    let passEasySupport: Bool?
    let passEasySupportPhotoURL, passEasySupportOthers: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case name = "Name"
        case gymType = "GymType"
        case inOut = "InOut"
        case floor = "Floor"
        case air = "Air"
        case sale = "Sale"
        case saleContent = "SaleContent"
        case seat = "Seat"
        case seatNum = "SeatNum"
        case showers = "Showers"
        case wc = "WC"
        case dressingRoom = "DressingRoom"
        case instructor = "Instructor"
        case light = "Light"
        case lounge = "Lounge"
        case fitAll = "FitAll"
        case fitInter = "FitInter"
        case photo1 = "Photo1"
        case photo2 = "Photo2"
        case openState = "OpenState"
        case openTime = "OpenTime"
        case openDayMon = "OpenDayMon"
        case openDayTue = "OpenDayTue"
        case openDayWed = "OpenDayWed"
        case openDayThu = "OpenDayThu"
        case openDayFri = "OpenDayFri"
        case openDaySat = "OpenDaySat"
        case openDaySun = "OpenDaySun"
        case openCharge = "OpenCharge"
        case restRemark = "RestRemark"
        case rentState = "RentState"
        case rentCharge = "RentCharge"
        case rentContantorDep = "RentContantorDep"
        case rentContantorEmail = "RentContantorEmail"
        case rentContantorFax = "RentContantorFax"
        case rentContantorName = "RentContantorName"
        case rentContantorTel = "RentContantorTel"
        case rentURL = "RentUrl"
        case passEasyUseItem = "PassEasyUseItem"
        case passEasyUseItemPhotoURL = "PassEasyUseItemPhotoUrl"
        case passEasyForChild = "PassEasyForChild"
        case passEasyForChildPhotoURL = "PassEasyForChildPhotoUrl"
        case passEasyIntoSwim = "PassEasyIntoSwim"
        case passEasyIntoSwimPhotoURL = "PassEasyIntoSwimPhotoUrl"
        case passEasyIntoSwimChar = "PassEasyIntoSwimChar"
        case passEasyIntoSwimCharPhotoURL = "PassEasyIntoSwimCharPhotoUrl"
        case passEasyOthers = "PassEasyOthers"
        case passEasyLightAlert = "PassEasyLightAlert"
        case passEasyLightAlertPhotoURL = "PassEasyLightAlertPhotoUrl"
        case passEasyComm = "PassEasyComm"
        case gameRadio = "GameRadio"
        case gameRadioPhotoURL = "GameRadioPhotoUrl"
        case passEasyRemote = "PassEasyRemote"
        case passEasyRemotePhotoURL = "PassEasyRemotePhotoUrl"
        case passEasyWizard = "PassEasyWizard"
        case passEasyWizardPhotoURL = "PassEasyWizardPhotoUrl"
        case passEasySupport = "PassEasySupport"
        case passEasySupportPhotoURL = "PassEasySupportPhotoUrl"
        case passEasySupportOthers = "PassEasySupportOthers"
    }
}

