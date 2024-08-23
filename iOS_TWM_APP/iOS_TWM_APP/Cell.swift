//
//  Cell.swift
//  iOS_TWM_APP
//
//  Created by Rowan Su on 2024/8/23.
//

import UIKit
import SnapKit

class Cell: UITableViewCell {
    
    var venueTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32)
        label.textColor = .black
        return label
    }()
    
    var venueLocationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    var venueFacilitiesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    var imageBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    var venueImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(venueTitleLabel)
        contentView.addSubview(venueLocationLabel)
        contentView.addSubview(venueFacilitiesLabel)
        contentView.addSubview(imageBackgroundView)
        imageBackgroundView.addSubview(venueImageView)
        
        venueTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
        }
        
        venueLocationLabel.snp.makeConstraints { make in
            make.top.equalTo(venueTitleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
        }
        
        venueFacilitiesLabel.snp.makeConstraints { make in
            make.top.equalTo(venueLocationLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
        }
        
        imageBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(venueTitleLabel.snp.bottom)
            make.trailing.equalToSuperview().offset(-16)
            make.width.height.equalTo(150)
        }
        
        venueImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()  
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ title: String) {
        venueTitleLabel.text = title
    }
    
    func setLocation(_ location: String) {
        venueLocationLabel.text = location
    }
    
    func setFacilities(_ facilities: String) {
        venueFacilitiesLabel.text = facilities
    }
    
    func setImage(_ image: UIImage?) {
        venueImageView.image = image
    }
}

