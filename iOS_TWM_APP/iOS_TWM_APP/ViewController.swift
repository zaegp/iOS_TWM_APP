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
        
        if isTokenValid() {
            print("yes token~ so map")
            let mapVC = MapViewController()
            addChild(mapVC)
            view.addSubview(mapVC.view)
            mapVC.view.frame = view.bounds
            mapVC.didMove(toParent: self)
        } else {
            print("no token~ so login")
            let loginVC = LoginViewController()
            addChild(loginVC)
            view.addSubview(loginVC.view)
            loginVC.view.frame = view.bounds
            loginVC.view.backgroundColor = .lightGray
            loginVC.didMove(toParent: self)
        }
        
    }
    
    func isTokenValid() -> Bool {
        let defaults = UserDefaults.standard
        
        if let expirationDate = defaults.object(forKey: "tokenExpirationDate") as? Date {
            if Date() < expirationDate {
                print("期限內")
                return true
            } else {
                print("token過期")
                clearLoginState()
                return false
            }
        } else {
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
