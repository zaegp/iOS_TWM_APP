//
//  LoginDataRequest.swift
//  iOS_TWM_APP
//
//  Created by 小妍寶 on 2024/8/23.
//

import Foundation
import UIKit
import Alamofire

@objc protocol LoginDataRequestDelegate {
    @objc optional func didGetToken(token: String)
    @objc optional func didGetMockData(deviceName: String)
}

class LoginDataRequest {
    
    var delegate: LoginDataRequestDelegate?
    
    var token: String = ""
    
    var passDeviceName: ((String) -> Void)?
    
    func registerData(userID: String, password: String, completion: @escaping (Bool, String) -> Void) {
        let parameters: [String: Any] = [
            "userName": userID,
            "email": "\(UUID().uuidString)",
            "password": password
        ]
        
        let url = "https://fastapi-production-a532.up.railway.app/register"
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["accept": "application/json", "Content-Type": "application/json"]).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let decodeData = try decoder.decode(Register.self, from: data)
                    print(decodeData)
                    completion(true, "註冊成功")
                } catch {
                    print("fail")
                    completion(false, "資料解析失敗")
                }
            case .failure(let error):
                print("bb")
                completion(false, "註冊失敗：\(error.localizedDescription)")
            }
        }
    }
    
    
    func loginData(userID: String, password: String, completion: @escaping (Bool, String) -> Void) {
        let parameters: [String: String] = [
            "grant_type": "",
            "username": userID,
            "password": password,
            "scope": "",
            "client_id": "",
            "client_secret": ""
        ]
        
        AF.request("https://fastapi-production-a532.up.railway.app/login",
                   method: .post,
                   parameters: parameters,
                   encoding: URLEncoding.default,
                   headers: ["accept": "application/json", "Content-Type": "application/x-www-form-urlencoded"]).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let decodeData = try decoder.decode(Login.self, from: data)
                    print("Decoded Response: \(decodeData)")
                    self.token = decodeData.accessToken ?? ""
                    UserDefaults.standard.set(self.token, forKey: "userToken")
                    self.getInformation(self.token)
                    self.delegate?.didGetToken?(token: self.token)
                    completion(true, "登入成功")
                } catch let decodingError {
                    print("Decoding Error: \(decodingError)")
                    completion(false, "資料解析失敗")
                }
            case .failure(let error):
                print("Error: \(error)")
                completion(false, "登入失敗：\(error.localizedDescription)")
            }
        }
    }
    
    
    func getInformation(_ token: String) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "accept": "application/json"
        ]
        
        AF.request("https://fastapi-production-a532.up.railway.app/info",
                   method: .get, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let decodeData = try decoder.decode(Register.self, from: data)
                    
                    print("Decoded Response: \(decodeData)")
                    
                } catch let decodingError {
                    print("Decoding Error: \(decodingError)")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func getMockData(_ token: String, completion: @escaping () -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "accept": "application/json"
        ]
        
        AF.request("https://fastapi-production-a532.up.railway.app/Info/",
                   method: .get, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let decodeData = try decoder.decode(MockData.self, from: data)
                    
                    let encodedData = try JSONEncoder().encode(decodeData)
                    UserDefaults.standard.set(encodedData, forKey: "MockData")
                    let test = UserDefaults.standard.mockData
                    print("MockData Response: \(decodeData)")
                    completion()
                } catch let decodingError {
                    print("Decoding Error: \(decodingError)")
                    completion()
                }
            case .failure(let error):
                print("Error: \(error)")
                completion()
            }
        }
    }
    
    func getDetailGymPageData(_ gymID: Int, completion: @escaping (GymDetailData?) -> Void) {
        let urlString = "https://iplay.sa.gov.tw/odata/Gym(\(gymID))?$format=application/json;odata.metadata=none&$expand=GymFuncData"
        
        print("==============================================")
        AF.request(urlString, method: .get).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    print("==============================================")
                    if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
                        print("Raw JSON Response: \(json)")
                    }
                    print("==============================================")
                    
                    let decoder = JSONDecoder()
                    let decodeData = try decoder.decode(GymDetailData.self, from: data)
                    print("MockData Response: \(decodeData)")
                    completion(decodeData)
                } catch let decodingError {
                    print("Decoding Error: \(decodingError)")
                    completion(nil)
                }
            case .failure(let error):
                print("Error: \(error)")
                completion(nil)
            }
        }
    }
    
    
}


extension UserDefaults {
    private enum Keys {
        static let mockDataKey = "MockData"
    }
    
    var mockData: MockData? {
        get {
            guard let savedData = data(forKey: Keys.mockDataKey) else {
                return nil
            }
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(MockData.self, from: savedData)
                return decodedData
            } catch {
                print("Failed to decode MockData: \(error.localizedDescription)")
                return nil
            }
        }
        
        set {
            let encoder = JSONEncoder()
            do {
                let encodedData = try encoder.encode(newValue)
                set(encodedData, forKey: Keys.mockDataKey)
            } catch {
                print("Failed to encode MockData: \(error.localizedDescription)")
            }
        }
    }
}
