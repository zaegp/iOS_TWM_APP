//
//  ProductListManager.swift
//  STYLiSH
//
//  Created by 謝霆 on 2024/7/23.
//

import UIKit
import Alamofire

protocol ProductListManagerDelegate {
    
    func manager(_ manager: ProductListManager, didGet product: [ProductListProduct]
    )
    
    func manager(_ manager: ProductListManager, didFailWith error: Error)
}

class ProductListManager {
    
    var delegate: ProductListManagerDelegate?
    
    let baseURLString = "https://api.appworks-school.tw/api/1.0/products/"
    
    var isPaging: Bool = false
    
    func loadApiData(category: String = "women", page: Int = 0){
        
        
        
        let urlString = "\(baseURLString)\(category)?paging=\(page)"
        AF.request(urlString)
            .responseDecodable(of: ProductListApiResponse.self) { response in
                
                switch response.result {
                    
                case .success(let decodedData):
                    
                    let product = decodedData.data
                                        
                    DispatchQueue.main.async {
                        self.delegate?.manager(self, didGet: product)
                    }
                    
                    
                case .failure(let productFetcherror):
                    print("Error: \(productFetcherror)")
                    
                }
            }
    }
    
    
}
