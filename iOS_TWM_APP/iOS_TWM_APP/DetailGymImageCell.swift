import UIKit

import Kingfisher

class DetailGymImageCell: UITableViewCell {
    
    static let identifier = "DetailGymImageCell"
    
    var collectionView: UICollectionView!

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupCollectionView()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func setupCollectionView() {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            
            collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCollectionViewCellIdentifier")
            collectionView.backgroundColor = .white
            
            contentView.addSubview(collectionView)
            
            // Setup constraints
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
                collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                collectionView.heightAnchor.constraint(equalToConstant: 150) // Adjust the height as needed
            ])
        }
    }

    extension DetailGymImageCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 5 // Number of image views
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCellIdentifier", for: indexPath) as! ImageCollectionViewCell
            // Configure the image view
            cell.imageView.image = UIImage(named: "image\(indexPath.item + 1)") // Replace with your image names
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 100, height: 100) // Size of each image container
        }
    }
