import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        

        // 創建初始的 view controller
        let initialViewController = MapViewController()
//        let initialViewController = LoginViewController()
//        let initialViewController = SportsVenue()
        
        
        let navigationController = UINavigationController(rootViewController: FirstViewController())
        

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        let currentTime = Date()
        UserDefaults.standard.set(currentTime, forKey: "lastCloseTime")
        print("應用進入背景，記錄時間：\(currentTime)")
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        if let lastCloseTime = UserDefaults.standard.value(forKey: "lastCloseTime") as? Date {
            let elapsedTime = Date().timeIntervalSince(lastCloseTime)
            print("從背景返回，距離上次關閉已過 \(elapsedTime) 秒")
            
            if elapsedTime >= 60 {
                print("超過 60 秒，返回登錄頁面")
                navigateToLogin()
            } else {
                print("未超過 60 秒，保持當前狀態")
            }
        } else {
            print("沒有找到上次關閉的時間記錄，保持當前狀態")
        }
    }
    
    private func navigateToLogin() {
        if let navigationController = window?.rootViewController as? UINavigationController {
            let loginVC = LoginViewController()
            navigationController.setViewControllers([loginVC], animated: true)
        } else {
            let loginVC = LoginViewController()
            let navigationController = UINavigationController(rootViewController: loginVC)
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
        }
    }
}
