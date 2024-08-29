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
        view.frame = CGRect(x: 0, y: 15, width: 102, height: 102) // 设置 frame
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 8
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        layout.minimumLineSpacing = 50
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        contentView.addSubview(borderView)
        
        borderView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(100)
            make.edges.equalTo(borderView).inset(5)
        }
    }
}

