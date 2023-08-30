//
//
//  avito-tech-task
//
//  Created by macbook on 26.08.2023.
//

import UIKit

class ProductCell: UICollectionViewCell {
    private var title: UILabel! = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 14)
        title.textColor = .black
        title.numberOfLines = 2
        title.lineBreakMode = .byTruncatingTail
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    private var price: UILabel! = {
        let price = UILabel()
        price.font = UIFont.boldSystemFont(ofSize: 16)
        price.textColor = .black
        price.numberOfLines = 1
        price.textAlignment = .left
        price.translatesAutoresizingMaskIntoConstraints = false
        return price
    }()
    private var location: UILabel! = {
        let location = UILabel()
        location.font = UIFont.systemFont(ofSize: 10)
        location.textColor = .gray
        location.numberOfLines = 1
        location.textAlignment = .left
        location.translatesAutoresizingMaskIntoConstraints = false
        return location
    }()
    private var imageView: UIImageView! = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private var createdDate: UILabel! = {
        let createdDate = UILabel()
        createdDate.font = UIFont.systemFont(ofSize: 10)
        createdDate.textColor = .gray
        createdDate.numberOfLines = 1
        createdDate.textAlignment = .left
        createdDate.translatesAutoresizingMaskIntoConstraints = false
        return createdDate
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}







extension ProductCell {
    
    private func setupUI() {
        layer.cornerRadius = 6
        addSubview()
        setupConstraints()
    }
    private func addSubview() {
        addSubview(imageView)
        addSubview(title)
        addSubview(price)
        addSubview(location)
        addSubview(createdDate)
    }
    private func setupConstraints() {
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 184).isActive = true
        imageView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        title.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        title.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        title.widthAnchor.constraint(equalToConstant: 160).isActive = true
            
        price.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 4).isActive = true
        price.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        price.widthAnchor.constraint(equalToConstant: 80).isActive = true
            
        location.topAnchor.constraint(equalTo: price.bottomAnchor, constant: 4).isActive = true
        location.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        location.widthAnchor.constraint(equalToConstant: 100).isActive = true
            
        createdDate.topAnchor.constraint(equalTo: location.bottomAnchor, constant: 4).isActive = true
        createdDate.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        createdDate.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func add(title: String) {
        self.title.text = title
    }
    func add(price: String) {
        self.price.text = price
    }
    func add(location: String) {
        self.location.text = location
    }
    func add(image: UIImage) {
        self.imageView.image = image
    }
    func add(createdDate: String) {
        self.createdDate.text = createdDate
    }
    
    func loadImage(from imageURL: String, placeholder: UIImage?) {
            // Проверяем, что URL для изображения корректный
            guard let url = URL(string: imageURL) else {
                imageView.image = placeholder
                return
            }
            
            // Создаем запрос
            let request = URLRequest(url: url)
            
            // Используем URLSession для выполнения запроса
            URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                guard let self = self else { return }
                
                if let error = error {
                    print("Ошибка при загрузке изображения: \(error)")
                    DispatchQueue.main.async {
                        self.imageView.image = placeholder
                    }
                    return
                }
                
                guard let data = data, let image = UIImage(data: data) else {
                    DispatchQueue.main.async {
                        self.imageView.image = placeholder
                    }
                    return
                }
                
                // Обновляем изображение на главном потоке
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }.resume() // Запускаем запрос
        }
}



