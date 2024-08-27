//
//  Cell.swift
//  iOS_TWM_APP
//
//  Created by Rowan Su on 2024/8/23.
//

import UIKit
import SnapKit
import Kingfisher

class Cell: UITableViewCell {
    
    var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    var venueTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28)
        label.textColor = .black
        return label
    }()
    
    var venueLocationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    var venueFacilitiesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    var imageBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = false
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    var venueImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(containerView)
        containerView.addSubview(venueTitleLabel)
        containerView.addSubview(venueLocationLabel)
        containerView.addSubview(venueFacilitiesLabel)
        containerView.addSubview(imageBackgroundView)
        imageBackgroundView.addSubview(venueImageView)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(2)
        }
        
        venueTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.top).offset(16)
            make.leading.equalTo(containerView.snp.leading).offset(16)
        }
        
        venueLocationLabel.snp.makeConstraints { make in
            make.top.equalTo(venueTitleLabel.snp.bottom).offset(8)
            make.leading.equalTo(containerView.snp.leading).offset(16)
            make.width.equalTo(160)
        }
        
        venueFacilitiesLabel.snp.makeConstraints { make in
            make.top.equalTo(venueLocationLabel.snp.bottom).offset(8)
            make.leading.equalTo(containerView.snp.leading).offset(16)
            make.width.equalTo(160)
        }
        
        imageBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(venueTitleLabel.snp.bottom)
            make.trailing.equalTo(containerView.snp.trailing).offset(-16)
            make.width.height.equalTo(150)
        }
        
        venueImageView.snp.makeConstraints { make in
            make.top.equalTo(imageBackgroundView.snp.top).offset(8)
            make.leading.equalTo(imageBackgroundView.snp.leading).offset(8)
            make.trailing.equalTo(imageBackgroundView.snp.trailing).offset(-8)
            make.bottom.equalTo(imageBackgroundView.snp.bottom).offset(-8)
        }
        
        contentView.backgroundColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 1.00)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ title: String) {
        if title.count >= 11 {
            let startIndex = title.startIndex
            let endIndex = title.index(startIndex, offsetBy: 11)
            let title = title[startIndex..<endIndex] + "..."
            venueTitleLabel.text = String(title)
        } else {
            venueTitleLabel.text = title
        }
    }
    
    func setLocation(_ location: String) {
        venueLocationLabel.text = location
    }
    
    func setFacilities(_ facilities: String) {
        venueFacilitiesLabel.text = facilities
    }
    
    func setImage(_ image: String) {
        let placeholderImage = UIImage(named: "Image")
        let url = URL(string: image)
        venueImageView.kf.setImage(with: url, placeholder: placeholderImage)
    }
}

