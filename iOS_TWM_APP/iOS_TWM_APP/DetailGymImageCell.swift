import UIKit
import SnapKit

class DetailGymImageCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(150)
            make.center.equalToSuperview()  // 將 imageView 居中
        }
    }
}
