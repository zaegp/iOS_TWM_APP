//
//  ViewController.swift
//  iOS_TWM_APP
//
//  Created by shachar on 2024/8/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let test: UIViewController = LoginViewController()
        addChild(test)
        view.addSubview(test.view)
        
        test.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        test.view.backgroundColor = .lightGray

        // 5. 通知子視圖控制器它已經被添加到父視圖控制器
        test.didMove(toParent: self)

    }


}

