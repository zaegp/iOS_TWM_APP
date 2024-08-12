//
//  TabbarController.swift
//  STYLiSH
//
//  Created by 謝霆 on 2024/8/6.
//

import UIKit
import FacebookLogin
import Alamofire

var profileAccessDataName: String?

var profileAccessimage: URL?

var isLoggedin: Bool?

let defaults = UserDefaults()

class TabbarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.delegate = self
        
        if let accessToken = AccessToken.current,
           !accessToken.isExpired {
            
            print("\(accessToken.userID) login")
            
        } else {
            
            print("not login")
            
        }
        
        isLoggedin = false
        
    }
    
    private var loginView: UIView?
    
    private var previousIndex: Int?
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if let viewControllers = tabBarController.viewControllers,
           
            let index = viewControllers.firstIndex(of: viewController),
           
            index == 2 || index == 3 {
            
            if isLoggedin == false {
                
                UIView.animate(withDuration: 0.8, animations: {
                    
                    self.previousIndex = self.selectedIndex
                    
                    self.showLoginPage()
                    
                })
                
                return true
            }
            
        }
        
        return true
        
    }
    
    private func isUserLoggedIn() -> Bool {
        
        return false // 默认未登录
        
    }
    
    var isLoginIn: Bool?
    
    private func showLoginPage() {
        
        if isLoggedin == false{
            
            loginView = UIView(frame: self.view.bounds)
            
            loginView?.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
            
            guard let loginView = loginView else {return}
            
            
            self.view.addSubview(loginView)
            
            let loginContainer = UIView()
            loginContainer.backgroundColor = .white
            loginContainer.layer.cornerRadius = 10
            loginContainer.translatesAutoresizingMaskIntoConstraints = false
            loginContainer.layer.cornerRadius = 10
            loginView.addSubview(loginContainer)
            
            let titleLabel = UILabel()
            titleLabel.text = "請先登入會員"
            titleLabel.textAlignment = .left
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            loginContainer.addSubview(titleLabel)
            
            let textlabel = UILabel()
            textlabel.text = "登入會員後即可使用個人功能。"
            textlabel.textAlignment = .left
            textlabel.translatesAutoresizingMaskIntoConstraints = false
            loginContainer.addSubview(textlabel)
            
            let dividerView = UIView()
            dividerView.translatesAutoresizingMaskIntoConstraints = false
            
            let backButton = UIButton(type: .system)
            backButton.setImage(UIImage(named: "Icons_24px_Close"), for: .normal)
            backButton.translatesAutoresizingMaskIntoConstraints = false
            backButton.addTarget(self, action: #selector(tapBack), for: .touchUpInside)
            loginContainer.addSubview(backButton)
            
            let button = UIButton(type: .system)
            button.setTitle("Facebook 登入", for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
            button.backgroundColor = UIColor(hex: "3B5998")
            button.tintColor = .white
            loginContainer.addSubview(button)
            
            NSLayoutConstraint.activate([
                
                loginContainer.centerXAnchor.constraint(equalTo: loginView.centerXAnchor),
                loginContainer.bottomAnchor.constraint(equalTo: loginView.bottomAnchor),
                loginContainer.widthAnchor.constraint(equalToConstant: 393),
                loginContainer.heightAnchor.constraint(equalToConstant: 230),
                
                titleLabel.topAnchor.constraint(equalTo: loginContainer.topAnchor, constant: 24),
                titleLabel.centerXAnchor.constraint(equalTo: loginContainer.centerXAnchor),
                titleLabel.widthAnchor.constraint(equalToConstant: 343),
                titleLabel.heightAnchor.constraint(equalToConstant: 25),
                
                textlabel.topAnchor.constraint(equalTo: loginContainer.topAnchor, constant: 73),
                textlabel.centerXAnchor.constraint(equalTo: loginContainer.centerXAnchor),
                textlabel.widthAnchor.constraint(equalToConstant: 343),
                textlabel.heightAnchor.constraint(equalToConstant: 21),
                
                backButton.topAnchor.constraint(equalTo: loginContainer.topAnchor, constant: 24),
                backButton.centerXAnchor.constraint(equalTo: loginContainer.centerXAnchor, constant: 180),
                backButton.widthAnchor.constraint(equalToConstant: 24),
                backButton.heightAnchor.constraint(equalToConstant: 24),
                
                
                button.bottomAnchor.constraint(equalTo: loginContainer.bottomAnchor, constant: -40),
                button.centerXAnchor.constraint(equalTo: loginContainer.centerXAnchor),
                button.widthAnchor.constraint(equalToConstant: 343),
                button.heightAnchor.constraint(equalToConstant: 48)
                
            ])
            
        } else {
            
            return
            
        }
    }
    
    let clientId = "your-app-id"
    let redirectUri = "your-redirect-uri"
    let clientSecret = "your-app-secret"
    let code = "authorization-code"
    
    @objc func loginTapped() {
        
        let manager = LoginManager()
        
        let configuration  = LoginConfiguration(permissions: [.publicProfile, .email])
        
        manager.logIn(configuration: configuration) { result in
            
            switch result {
                
            case .success(_, _, let token):
                
                guard let accessToken = token?.tokenString else {return}
                
                let url = "https://api.appworks-school.tw/api/1.0/user/signin"
                
                let parameters: [String: Any] = [
                    
                    "provider": "facebook",
                    "access_token": accessToken,
                    
                ]
                
                AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseDecodable(of: ApiResponse.self) { response in
                    
                    switch response.result {
                    case .success(let value):
                        
                        if let json = value as? ApiResponse {
                            
                            let data = json.data
                            
                            let profileToken = data.accessToken
                            
                            defaults.set(profileToken, forKey: "profileToken")
                            
                            let profileUrl = "https://api.appworks-school.tw/api/1.0/user/profile"
                            
                            let profileHeader: HTTPHeaders = [
                                
                                "Authorization": "Bearer \(profileToken)"
                                
                            ]
                            
                            let profileparameters: [String: Any] = [
                                
                                "provider": "facebook",
                                "access_token": profileToken,
                                
                            ]
                            
                            AF.request(profileUrl, method: .get,encoding: JSONEncoding.default, headers: profileHeader).responseDecodable(of: ProfileApiResponse.self) { profileResponse in
                                switch profileResponse.result {
                                    
                                case .success(let profileValue):
                                    
                                    if let profileJson = profileValue as? ProfileApiResponse
                                    {
                                        
                                        let profileAccessData = profileValue.data
                                        
                                        profileAccessDataName = profileAccessData.name
                                        
                                        profileAccessimage = URL(string: profileAccessData.picture)
                                        
                                        isLoggedin = true
                                        
                                        self.loginView?.removeFromSuperview()
                                    }
                                    
                                case .failure(_):
                                    print("fetch profile failed")
                                }
                                
                            }
                        }
                        
                    case .failure(_):
                        
                        if let data = response.data {
                            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                print("Error: \(json["error"] ?? "Unknown error")")
                            }
                        }
                        
                    }
                    
                }
                
            case .cancelled:
                print("cancelled")
                
            case .failed(_):
                print("failed")
                
            }
        }
        
        
    }
    
    @objc private func tapBack() {
        
        self.loginView?.removeFromSuperview()
        
    }
    
    func addBackgroundView () {
        
        let view = UIView()
        
        view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        view.backgroundColor = .darkGray
        
        self.view.addSubview(view)
        
        self.view.bringSubviewToFront(view)
    }
    
}

extension TabbarController {
    
    func fetchToken(clientId: String, redirectUri: String, clientSecret: String, code: String) {
        
       guard let url = URL(string: "https://graph.facebook.com/v2.10/oauth/access_token") else {return}
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        let requestBody: [String: Any] = [
            
            "client_id": clientId,
            "redirect_uri": redirectUri,
            "client_secret": clientSecret,
            "code": code
            
        ]
        
        
        AF.request(url, method: .get, parameters: requestBody).responseJSON { response in
            
            
            switch response.result {
                
            case .success(let decodedData):
                
                if let logInData = decodedData as? [String: Any], let accessToken = logInData["access_token"]as? String{
                    
                } else {
                    print("Access token not found in response")
                    
                }
                
                
            case .failure(let productFetcherror):
                print("Error: \(productFetcherror)")
                
            }
        }
         
    }
    
}
