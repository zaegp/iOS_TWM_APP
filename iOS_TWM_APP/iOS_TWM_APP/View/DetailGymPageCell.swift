import UIKit
import SnapKit

class DetailGymPageCell: UITableViewCell {
    
    let iconArray = ["detail-icon-announcement", "detail-icon-location", "detail-icon-bus", "detail-icon-telephone", "detail-icon-website", "detail-icon-buildings", "detail-icon-parking", "detail-icon-wheelchair", "detail-icon-gender", "detail-icon-photo", "detail-icon-photo"]
    
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
        imageView.layer.cornerRadius = 2
        return imageView
    }()
    
    var titleButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    var detailLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 20
        layout.itemSize = CGSize(width: 100, height: 200)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.clipsToBounds = false
        collectionView.isPagingEnabled = false
        collectionView.isScrollEnabled = true
        collectionView.isHidden = true
        collectionView.register(DetailGymImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        return collectionView
    }()
    
    var imageCacheArray: [String] = []

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(borderView)
        borderView.addSubview(viewImage)
        contentView.addSubview(titleButton)
        contentView.addSubview(detailLabel)
        contentView.addSubview(collectionView)
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        
        borderView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(10)
            make.left.equalTo(contentView).offset(16)
            make.width.height.equalTo(30)
        }
        
        viewImage.snp.makeConstraints { make in
            make.edges.equalTo(borderView).inset(5)
        }
        
        titleButton.snp.makeConstraints { make in
            make.centerY.equalTo(borderView)
            make.left.equalTo(borderView.snp.right).offset(10)
            make.right.equalTo(contentView).offset(-16)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(titleButton.snp.bottom).offset(5)
            make.left.equalTo(borderView.snp.right).offset(10)
            make.right.equalTo(contentView).offset(-16)
            make.bottom.equalTo(contentView).offset(-16)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleButton.snp.bottom).offset(10)
            make.left.equalTo(borderView.snp.right).offset(5)
            make.right.equalTo(contentView.snp.right).offset(-10)
            //make.height.equalTo(100)
            make.bottom.equalTo(contentView).inset(20)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        viewImage.image = nil
        titleButton.setTitle("", for: .normal)
        detailLabel.text = ""
        collectionView.isHidden = true
        detailLabel.isHidden = false
        titleButton.isHidden = false
        titleButton.tintColor = .black
    }
}

extension DetailGymPageCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageCacheArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! DetailGymImageCell
        
        let url = URL(string: imageCacheArray[indexPath.row])
        cell.imageView.kf.setImage(with: url)
        return cell
    }
}
