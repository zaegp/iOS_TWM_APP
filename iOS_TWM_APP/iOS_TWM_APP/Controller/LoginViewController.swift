//
//  LoginViewController.swift
//  iOS_TWM_APP
//
//  Created by 小妍寶 on 2024/8/23.
//

import Foundation
import UIKit
import SnapKit
import IQKeyboardManagerSwift
class LoginViewController: UIViewController {
    
    let contentView = UIImageView()
    
    let userIDLabel = UILabel()
    let passwordLabel = UILabel()
    let userIDTextField = UITextField()
    let passwordTextField = UITextField()
    let checkButton = UIButton()
    let checkLabel = UILabel()
    let signinButton = UIButton()
    let loginButton = UIButton()
    let logoImageView = UIImageView()
    
    
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
        
        
        
        userIDTextField.accessibilityIdentifier = "userIDTextField"
        passwordTextField.accessibilityIdentifier = "passwordTextField"
        loginButton.accessibilityIdentifier = "loginButton"
        signinButton.accessibilityIdentifier = "signinButton"
        checkButton.accessibilityIdentifier = "checkButton"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    func setupLoginPage() {
        
        view.addSubview(contentView)
        contentView.isUserInteractionEnabled = true
        
        contentView.addSubview(userIDLabel)
        contentView.addSubview(passwordLabel)
        contentView.addSubview(userIDTextField)
        contentView.addSubview(passwordTextField)
        
        contentView.addSubview(checkLabel)
        contentView.addSubview(signinButton)
        contentView.addSubview(loginButton)
        contentView.addSubview(logoImageView)
        contentView.addSubview(checkButton)
        
        contentView.snp.makeConstraints { make in
            make.width.centerX.bottom.top.equalTo(view)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.width.equalTo(contentView).multipliedBy(0.7)
            make.height.equalTo(contentView).multipliedBy(0.25)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(25)
        }
        
        userIDLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(30)
            make.top.equalTo(logoImageView.snp.bottom).offset(view.frame.height * 0.15)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(30)
            make.top.equalTo(userIDLabel.snp.bottom).offset(50)
        }
        
        userIDTextField.snp.makeConstraints { make in
            make.height.equalTo(45)
            make.width.equalTo(contentView).multipliedBy(0.5)
            make.centerY.equalTo(userIDLabel)
            make.trailing.equalTo(contentView).offset(-20)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(45)
            make.width.equalTo(contentView).multipliedBy(0.5)
            make.centerY.equalTo(passwordLabel)
            make.trailing.equalTo(contentView).offset(-20)
        }
        
        checkButton.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.snp.centerX).offset(-35)
            make.top.equalTo(passwordTextField.snp.bottom).offset(50)
            make.width.height.equalTo(27)
        }
        
        checkLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.centerX).offset(-25)
            make.centerY.equalTo(checkButton)
        }
        
        loginButton.snp.makeConstraints { make in
            make.width.equalTo(contentView).multipliedBy(0.4)
            make.height.equalTo(45)
            make.leading.equalTo(contentView.snp.centerX).offset(5)
            make.top.equalTo(checkLabel.snp.bottom).offset(40)
        }
        
        signinButton.snp.makeConstraints { make in
            make.width.equalTo(contentView).multipliedBy(0.4)
            make.height.equalTo(45)
            make.trailing.equalTo(contentView.snp.centerX).offset(-5)
            make.top.equalTo(checkLabel.snp.bottom).offset(40)
        }
        
        contentView.image = UIImage(named: "sports-background")
        contentView.contentMode = .scaleAspectFill
        
        logoImageView.image = UIImage(named: "logo")
        logoImageView.contentMode = .scaleAspectFill
        
        userIDLabel.text = "U s e r I D"
        userIDLabel.font = UIFont.systemFont(ofSize: 20, weight: .light)
        userIDLabel.textColor = .darkGray
        userIDLabel.textAlignment = .right
        
        passwordLabel.text = "P a s s w o r d"
        passwordLabel.font = UIFont.systemFont(ofSize: 20, weight: .light)
        passwordLabel.textColor = .darkGray
        passwordLabel.textAlignment = .right
        
        userIDTextField.placeholder = "請輸入帳號"
        userIDTextField.textAlignment = .center
        userIDTextField.layer.borderColor = UIColor.gray.cgColor
        userIDTextField.layer.borderWidth = 0.5
        userIDTextField.layer.cornerRadius = 20
        userIDTextField.backgroundColor = .white.withAlphaComponent(0.5)
        userIDTextField.textColor = .black
        userIDTextField.text = ""
        
        passwordTextField.text = ""
        passwordTextField.isSecureTextEntry = true
        passwordTextField.placeholder = "請輸入密碼"
        passwordTextField.textAlignment = .center
        passwordTextField.layer.borderColor = UIColor.gray.cgColor
        passwordTextField.layer.borderWidth = 0.5
        passwordTextField.layer.cornerRadius = 20
        passwordTextField.textColor = .black
        passwordTextField.backgroundColor = .white.withAlphaComponent(0.5)
        
        checkButton.backgroundColor = .white.withAlphaComponent(0.6)
        checkButton.setImage(UIImage(named: "check"), for: .selected)
        checkButton.imageView?.contentMode = .scaleAspectFill
        checkButton.layer.cornerRadius = 8
        checkButton.layer.borderColor = UIColor.gray.cgColor
        checkButton.layer.borderWidth = 0.5
        
        checkLabel.text = "記得登入狀態"
        checkLabel.textColor = .white
        checkLabel.font = UIFont.systemFont(ofSize: 14)
        
        loginButton.setTitle("登入", for: .normal)
        loginButton.backgroundColor = .white.withAlphaComponent(0.3)
        loginButton.layer.cornerRadius = 20
        loginButton.layer.borderColor = UIColor.white.cgColor
        loginButton.layer.borderWidth = 0.5
        loginButton.isEnabled = false
        
        signinButton.setTitle("註冊", for: .normal)
        signinButton.backgroundColor = .white.withAlphaComponent(0.3)
        signinButton.layer.cornerRadius = 20
        signinButton.layer.borderColor = UIColor.white.cgColor
        signinButton.layer.borderWidth = 0.5
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
        guard let userID = userIDTextField.text, let passwordText = passwordTextField.text else {
            return
        }
        
        loginDataRequest.loginData(userID: userID, password: passwordText) { [weak self] success, message in
            guard let self = self else { return }
            self.showAlert(title: success ? "成功" : "失敗", message: message)
        }
    }
    
    @objc func signinButtonTapped() {
        if let userID = userIDTextField.text, let passwordText = passwordTextField.text {
            loginDataRequest.registerData(userID: userID, password: passwordText) { [weak self] success, message in
                guard let self = self else { return }
                self.showAlert(title: success ? "成功" : "失敗", message: message)
            }
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
        
        let defaults = UserDefaults.standard
        defaults.set(token, forKey: "userToken")
        
        let expirationDate = Date().addingTimeInterval(expiresIn)
        defaults.set(expirationDate, forKey: "tokenExpirationDate")
        
        print("Saved token: \(token), expirationDate: \(expirationDate)")
    }
    
    func saveLoginToken(token: String) {
        let defaults = UserDefaults.standard
        defaults.set(token, forKey: "userToken")
        
        print("Saved token: \(token)")
    }
    
    func getToken() -> String? {
        
        
        return UserDefaults.standard.string(forKey: "userToken")
    }
    
    
    func isTokenValid() -> Bool {
        let defaults = UserDefaults.standard
        
        if let expirationDate = defaults.object(forKey: "tokenExpirationDate") as? Date {
            
            if Date() < expirationDate {
                print("在可用效期內")
                return true
            } else {
                print("超出可用效期")
                clearLoginState()
                return false
            }
        } else {
            print("No expiration date found")
            return false
        }
    }
    
    func clearLoginState() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "userToken")
        defaults.removeObject(forKey: "tokenExpirationDate")
        print("Cleared userToken and tokenExpirationDate")
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}

extension LoginViewController: LoginDataRequestDelegate {
    
    func didGetToken(token: String) {
        
        if !token.isEmpty {
            if let navigationController = self.navigationController {
                let token = self.loginDataRequest.token
                
                self.loginDataRequest.getMockData(token) { [weak self] in
                    guard let self = self else { return }
                    let mapVC = MapViewController()
                    navigationController.pushViewController(mapVC, animated: true)
                }
                
                if self.checkButton.isSelected {
                    let expiresIn: TimeInterval = 3600
                    self.saveLoginState(token: self.loginDataRequest.token, expiresIn: expiresIn)
                } else {
                    self.saveLoginToken(token: token)
                }
            }
        } else {
            print("完全～沒有～token～")
        }
    }
    
}

