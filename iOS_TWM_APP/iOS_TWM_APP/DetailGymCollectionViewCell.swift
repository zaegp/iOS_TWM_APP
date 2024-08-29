//
//  DetailGymCollectionViewCell.swift
//  iOS_TWM_APP
//
//  Created by 謝霆 on 2024/8/29.
//

import UIKit

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    var containerView: UIView!
    var imageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        containerView = UIView()
        containerView.backgroundColor = .gray
        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = true
        
        contentView.addSubview(containerView)
        
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        containerView.addSubview(imageView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8)
        ])
    }
}

