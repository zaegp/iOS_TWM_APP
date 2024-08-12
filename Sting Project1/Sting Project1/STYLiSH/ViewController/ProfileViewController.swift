//
//  ProfileViewController.swift
//  STYLiSH
//
//  Created by 謝霆 on 2024/7/20.
//

import UIKit
import Kingfisher

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let screenWidth = UIScreen.main.bounds.width
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var profileName: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    var fullScreenSize :CGSize!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        collectionView.delegate = self
        
        collectionView.dataSource = self
        
        profileName.text = profileAccessDataName
        
        profileImage.kf.setImage(with: profileAccessimage)
        
    }
    
    //MARK: insetForSectionAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
                        
        UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if section == 2 {
            
            return UIEdgeInsets(top: screenWidth / 30, left: screenWidth / 22, bottom: 0, right: screenWidth / 22)
            
        } else {
            
            return UIEdgeInsets(top: screenWidth / 30, left: 0, bottom: screenWidth / 20, right: 0)
            
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 2
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return screenWidth / 13
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 {
            
            return 0
            
        } else {
            
            return screenWidth / 20
            
        }
    }
    
    //MARK: numberOfItemsInSection
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return 5
            
        } else {
            
            return 8
        }
    }
    
    
    //MARK: sizeForItemAt
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
        {
            
           return CGSize(width: screenWidth / 6, height: screenWidth / 6)
            
        }
    
    //MARK: cellForItemAt
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as? ProfileCollectionViewCell
                
        if indexPath.section == 0 {

            cell?.imageView.image = UIImage(named: profileCellData[indexPath.section][indexPath.row][0])
            
            cell?.iconLabel.text  = profileCellData[indexPath.section][indexPath.row][1]
            
            return cell ?? UICollectionViewCell()
            
        } else {
            
            cell?.imageView.image = UIImage(named: profileCellData[indexPath.section][indexPath.row][0])
            
            cell?.iconLabel.text  = profileCellData[indexPath.section][indexPath.row][1]
            
            return cell ?? UICollectionViewCell()
            
        }
    }
    
    
    //MARK: viewForSupplementaryElementOfKind
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerView", for: indexPath) as? SectionHeader
            
            if indexPath.section == 0 {
                
                headerView?.sectionHeaderLabel.text = "我的訂單"
                
            } else {
                
                headerView?.headerButton.isHidden = true
                
                headerView?.sectionHeaderLabel.text = "更多服務"
                
            }
            
            return headerView ?? SectionHeader()
            
        }
        
        return UICollectionReusableView()
        
    }
    
    
}


