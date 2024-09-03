import UIKit
import SnapKit

import Kingfisher

class DetailGymImageCell: UICollectionViewCell {
   

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let borderView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.frame = CGRect(x: 0, y: 15, width: 102, height: 102) 
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 8
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        contentView.addSubview(borderView)
        
        contentView.addSubview(imageView)
        
        borderView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).inset(50)
            make.width.equalTo(105)
            make.height.equalTo(105)
            
        }
        
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(100)
            make.edges.equalTo(borderView).inset(5)
        }
    }
}

