//
//  SuccessViewController.swift
//  STYLiSH
//
//  Created by 謝霆 on 2024/8/9.
//

import UIKit
import CoreData

class SuccessViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    @IBAction func didTapBackToCart(_ sender: UIButton) {
        
        let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CartEntity")
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let cartItems = try context?.execute(batchDeleteRequest)
            
        } catch {
            print("error")
        }
        
        self.navigationController?.popToRootViewController(animated: true)
    }

    
}
