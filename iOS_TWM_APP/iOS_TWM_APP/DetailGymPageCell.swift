import UIKit
import SnapKit

class DetailGymPageCell: UITableViewCell {
    
   
    
    let borderView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 8
        return view
    }()
    
    let viewImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        return imageView
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "defaulttext"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail

        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(borderView)
        borderView.addSubview(viewImage)
        contentView.addSubview(titleLabel)
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        
        
        borderView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(10)
            make.left.equalTo(contentView).offset(16)
            make.width.height.equalTo(30)
            make.bottom.equalTo(contentView).offset(-10)

        }
        
        viewImage.snp.makeConstraints { make in
            make.edges.equalTo(borderView).inset(3)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(borderView)
            make.left.equalTo(borderView.snp.right).offset(10)
            make.right.equalTo(contentView).offset(-16)
        }
    }
}
