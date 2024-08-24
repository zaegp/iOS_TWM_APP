//
//  LoginViewController.swift
//  iOS_TWM_APP
//
//  Created by 小妍寶 on 2024/8/23.
//

import Foundation
import UIKit
import SnapKit

class LoginViewController: UIViewController {
    
    let contentView = UIView()
    
    let userIDLabel = UILabel()
    let passwordLabel = UILabel()
    let userIDTextField = UITextField()
    let passwordTextField = UITextField()
    let checkButton = UIButton()
    let checkLabel = UILabel()
    let signinButton = UIButton()
    let loginButton = UIButton()
    
    var loginDataRequest = LoginDataRequest()
    let group = DispatchGroup()
    let concurrentQueue = DispatchQueue(label: "com.example.concurrentQueue", attributes: .concurrent)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.backgroundColor = .clear
        loginDataRequest.delegate = self

        setupLoginPage()
        setupTextFieldAction()
        setupButtonAction()
        
    }
    
    func setupLoginPage() {
        
        view.addSubview(contentView)
        
        contentView.addSubview(userIDLabel)
        contentView.addSubview(passwordLabel)
        contentView.addSubview(userIDTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(checkButton)
        contentView.addSubview(checkLabel)
        contentView.addSubview(signinButton)
        contentView.addSubview(loginButton)
        
        contentView.snp.makeConstraints { make in
            make.width.centerX.bottom.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        userIDLabel.snp.makeConstraints { make in
            make.trailing.equalTo(userIDTextField.snp.leading).offset(-15)
            make.centerY.equalTo(contentView).offset(-150)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.trailing.equalTo(passwordTextField.snp.leading).offset(-15)
            make.top.equalTo(userIDLabel.snp.bottom).offset(70)
        }
        
        userIDTextField.snp.makeConstraints { make in
            make.height.equalTo(55)
            make.width.equalTo(contentView).multipliedBy(0.57)
            make.centerY.equalTo(userIDLabel)
            make.trailing.equalTo(contentView).offset(-20)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(55)
            make.width.equalTo(contentView).multipliedBy(0.57)
            make.centerY.equalTo(passwordLabel)
            make.trailing.equalTo(contentView).offset(-20)
        }
        
        checkButton.snp.makeConstraints { make in
            make.leading.equalTo(passwordTextField)
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.width.height.equalTo(27)
        }
        
        checkLabel.snp.makeConstraints { make in
            make.leading.equalTo(checkButton.snp.trailing).offset(10)
            make.centerY.equalTo(checkButton)
        }
        
        loginButton.snp.makeConstraints { make in
            make.width.equalTo(contentView).multipliedBy(0.35)
            make.height.equalTo(65)
            make.trailing.equalTo(passwordTextField.snp.trailing).offset(-5)
            make.top.equalTo(checkLabel.snp.bottom).offset(25)
        }
        
        signinButton.snp.makeConstraints { make in
            make.width.equalTo(contentView).multipliedBy(0.35)
            make.height.equalTo(65)
            make.trailing.equalTo(loginButton.snp.leading).offset(-15)
            make.top.equalTo(checkLabel.snp.bottom).offset(25)
        }
        
        contentView.backgroundColor = .systemGray5
        
        userIDLabel.text = "UserID"
        userIDLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        userIDLabel.textAlignment = .right
        
        passwordLabel.text = "Password"
        passwordLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        passwordLabel.textAlignment = .right
        
        userIDTextField.placeholder = "請輸入帳號"
        userIDTextField.textAlignment = .center
        userIDTextField.layer.borderColor = UIColor.black.cgColor
        userIDTextField.layer.borderWidth = 1.5
        userIDTextField.layer.cornerRadius = 5
        userIDTextField.backgroundColor = .white
        userIDTextField.text = ""
        
        passwordTextField.text = ""
        passwordTextField.placeholder = "請輸入密碼"
        passwordTextField.textAlignment = .center
        passwordTextField.layer.borderColor = UIColor.black.cgColor
        passwordTextField.layer.borderWidth = 1.5
        passwordTextField.layer.cornerRadius = 5
        passwordTextField.backgroundColor = .white
        
        checkButton.backgroundColor = .white
        checkButton.setImage(UIImage(named: "check"), for: .selected)
        checkButton.imageView?.contentMode = .scaleAspectFill
        checkButton.layer.cornerRadius = 5
        checkButton.layer.borderColor = UIColor.gray.cgColor
        checkButton.layer.borderWidth = 0.8
        
        checkLabel.text = "記得登入狀態"
        checkLabel.font = UIFont.systemFont(ofSize: 16)
        
        loginButton.setTitle("登入", for: .normal)
        loginButton.backgroundColor = .systemGray2
        loginButton.layer.cornerRadius = 5
        loginButton.layer.borderColor = UIColor.darkGray.cgColor
        loginButton.layer.borderWidth = 2.5
        loginButton.isEnabled = false
        
        signinButton.setTitle("註冊", for: .normal)
        signinButton.backgroundColor = .systemGray2
        signinButton.layer.cornerRadius = 5
        signinButton.layer.borderColor = UIColor.darkGray.cgColor
        signinButton.layer.borderWidth = 2.5
        signinButton.isEnabled = false
    }
    
    func setupTextFieldAction() {
        
        userIDTextField.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
        
        passwordTextField.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
        
    }
    
    func setupButtonAction() {
        
        checkButton.addTarget(self, action: #selector(checkboxTapped(_:)), for: .touchUpInside)
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        signinButton.addTarget(self, action: #selector(signinButtonTapped), for: .touchUpInside)
    }
    
    @objc func checkboxTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    @objc func loginButtonTapped() {
        
        print("------tap login")
        
        guard let userID = userIDTextField.text, let passwordText = passwordTextField.text else {
            print("------no userID or password")
            return
        }
        

        
        self.loginDataRequest.loginData(userID: userID, password: passwordText)
        
        
        
        
//        if !self.loginDataRequest.token.isEmpty {
//            if let navController = self.navigationController {
//                let mapVC = MapVC()
//                navController.pushViewController(mapVC, animated: true)
//            }
//            if self.checkButton.isSelected {
//                print("拿到token")
//                let token = self.loginDataRequest.token
//                let expiresIn: TimeInterval = 60
//                self.saveLoginState(token: self.loginDataRequest.token, expiresIn: expiresIn)
//            } else {
//                print("沒有token")
//            }
//        } else {
//            print("------no token")
//        }

        
    }
    
    @objc func signinButtonTapped() {
        print("++++++tap signin")
        if let userID = userIDTextField.text, let passwordText = passwordTextField.text {
            loginDataRequest.registerData(userID: userID, password: passwordText)
        }
    }
    
    @objc func textFieldsDidChange() {
        
        if userIDTextField.text != "" && passwordTextField.text != "" {
            signinButton.isEnabled = true
            loginButton.isEnabled = true
        } else {
            signinButton.isEnabled = false
            loginButton.isEnabled = false
        }
    }
    

    func saveLoginState(token: String, expiresIn: TimeInterval) {
        print("存進去～～～")
        let defaults = UserDefaults.standard
        defaults.set(token, forKey: "userToken")
        
        let expirationDate = Date().addingTimeInterval(expiresIn)
        defaults.set(expirationDate, forKey: "tokenExpirationDate")
        
    }
    
    func getToken() -> String? {
        
        return UserDefaults.standard.string(forKey: "userToken")
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
    
}

extension LoginViewController: LoginDataRequestDelegate {
    
    func didGetToken(token: String) {
        if !token.isEmpty {
            if let navgationController = self.navigationController {
                let mapVC = MapViewController()
                navgationController.pushViewController(mapVC, animated: true)
            }
            
            if self.checkButton.isSelected {
                print("有token也有打勾勾")
                let token = self.loginDataRequest.token
                let expiresIn: TimeInterval = 3600
                self.saveLoginState(token: self.loginDataRequest.token, expiresIn: expiresIn)
            } else {
                print("沒有感覺到勾勾")
            }
        } else {
            print("完全～沒有～token～")
        }
    }
    
}
