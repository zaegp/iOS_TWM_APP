//
//  MarketManager.swift
//  STYLiSH
//
//  Created by 謝霆 on 2024/7/18.
//

import UIKit
 
protocol MarketManagerDelegate {
    
    func manager(_ manager: MarketManager, didGet marketingHots: [MarketingHot]
    )
    
    func manager(_ manager: MarketManager, didFailWith error: Error)
}


class MarketManager {
    
    var delegate: MarketManagerDelegate?
    
    func getMarketingHots() {
        
        let urlString = "https://api.appworks-school.tw/api/1.0/marketing/hots"
        
        guard let url  = URL(string: urlString) else {
            
            return
            
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) {
            
            data, response, error in
            
            if let error = error {
                
                print("Error: \(error.localizedDescription)")
                return
                
            }
            
            guard let data = data else {
                
                return
                
            }
            
            let decoder = JSONDecoder()
            
            do {
                let decodedData = try decoder.decode(MarketingHotsResponse.self, from: data)
                
                let marketingHots = decodedData.data
                                
                DispatchQueue.main.async {
                    
                    self.delegate?.manager(self, didGet: marketingHots)
                    
                }
                
            } catch {
                
                print(error)
                
            }
        }
        
        task.resume()
                                    
 }
    
}


