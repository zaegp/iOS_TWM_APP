//
//  ProfileDataSource.swift
//  STYLiSH
//
//  Created by 謝霆 on 2024/7/20.
//

import Foundation
import UIKit

class SataSource: NSObject, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 2
        }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
       
        if section == 0 {
            return 5
        } else {
            return 8
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let profileCell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCell.reuseIdentifier, for: indexPath) as? ProfileCell else {
                    fatalError("Cell cannot be created")
                }
                return profileCell
    }
    
    
}
