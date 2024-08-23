import UIKit
import SnapKit

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
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = false
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 2
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 5
        return view
    }()
    
    var venueImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
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
            make.edges.equalToSuperview().inset(2) // Optional inset
        }
        
        venueTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.top).offset(16)
            make.leading.equalTo(containerView.snp.leading).offset(16)
        }
        
        venueLocationLabel.snp.makeConstraints { make in
            make.top.equalTo(venueTitleLabel.snp.bottom).offset(8)
            make.leading.equalTo(containerView.snp.leading).offset(16)
        }
        
        venueFacilitiesLabel.snp.makeConstraints { make in
            make.top.equalTo(venueLocationLabel.snp.bottom).offset(8)
            make.leading.equalTo(containerView.snp.leading).offset(16)
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
        
        contentView.backgroundColor = .lightGray // Optional to match your cell design
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
