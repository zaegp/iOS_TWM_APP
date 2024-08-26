//
//  ViewController.swift
//  iOS_TWM_APP
//
//  Created by shachar on 2024/8/23.
//

import UIKit

class FirstViewController: UIViewController {
    
    var token: String?
    let loginDataRequest = LoginDataRequest()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("======")
        print(getToken())
        if isTokenValid() {
            print("yes token~ so map")
            // 如果有 token，显示地图页面
            token = getToken()
            let mapVC = MapViewController()
            addChild(mapVC)
            view.addSubview(mapVC.view)
            mapVC.view.frame = view.bounds
            mapVC.didMove(toParent: self)
        } else {
            print("no token~ so login")
            // 如果没有 token，显示登录页面
            let loginVC = LoginViewController()
            addChild(loginVC)
            view.addSubview(loginVC.view)
            loginVC.view.frame = view.bounds
            loginVC.view.backgroundColor = .lightGray
            loginVC.didMove(toParent: self)
        }
        
        
        //        let loginVC: UIViewController = LoginViewController()
        //        addChild(loginVC)
        //        view.addSubview(loginVC.view)
        //
        //        loginVC.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        //        loginVC.view.backgroundColor = .lightGray
        //
        //
        //        loginVC.didMove(toParent: self)
        
    }
    
    func isTokenValid() -> Bool {
        let defaults = UserDefaults.standard
        
        if let expirationDate = defaults.object(forKey: "tokenExpirationDate") as? Date {
            // 比較當前時間和 token 的過期時間
            if Date() < expirationDate {
                return true
            } else {
                // Token 過期
                clearLoginState()
                return false
            }
        } else {
            // 如果找不到 tokenExpirationDate，表示沒有登入狀態
            return false
        }
    }
    
    func clearLoginState() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "userToken")
        defaults.removeObject(forKey: "tokenExpirationDate")
    }
    
    func getToken() -> String? {
        return UserDefaults.standard.string(forKey: "userToken")
    }
    
    
}

extension FirstViewController: LoginDataRequestDelegate {
    
    
    func didGetToken(token: String) {
        self.token = token
    }
    
    
    
    
}
