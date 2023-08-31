// MARK: - Cell

import UIKit
import Kingfisher

class AdvertisementCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    
    private var title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var price: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 1
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var location: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .gray
        label.numberOfLines = 1
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var createdDate: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .gray
        label.numberOfLines = 1
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        layer.cornerRadius = 6
        addSubview(imageView)
        addSubview(title)
        addSubview(price)
        addSubview(location)
        addSubview(createdDate)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leftAnchor.constraint(equalTo: leftAnchor),
            imageView.rightAnchor.constraint(equalTo: rightAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 184),
            imageView.widthAnchor.constraint(equalTo: widthAnchor),
            
            title.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            title.leftAnchor.constraint(equalTo: leftAnchor),
            title.widthAnchor.constraint(equalToConstant: 160),
            
            price.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 4),
            price.leftAnchor.constraint(equalTo: leftAnchor),
            price.widthAnchor.constraint(equalToConstant: 80),
            
            location.topAnchor.constraint(equalTo: price.bottomAnchor, constant: 4),
            location.leftAnchor.constraint(equalTo: leftAnchor),
            location.widthAnchor.constraint(equalToConstant: 100),
            
            createdDate.topAnchor.constraint(equalTo: location.bottomAnchor, constant: 4),
            createdDate.leftAnchor.constraint(equalTo: leftAnchor),
            createdDate.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    // MARK: - Data Population
    
    func configure(withTitle title: String, price: String, location: String, imageURL: URL?, createdDate: String) {
        self.title.text = title
        self.price.text = price
        self.location.text = location
        self.createdDate.text = createdDate
        if let imageURL = imageURL {
            self.imageView.kf.setImage(with: imageURL)
        }
            
    }
}
