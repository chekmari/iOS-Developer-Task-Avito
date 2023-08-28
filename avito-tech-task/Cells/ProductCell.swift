//
//  ProductCell.swift
//  avito-tech-task
//
//  Created by macbook on 26.08.2023.
//

import UIKit

class ProductCell: UICollectionViewCell {
    var title: UILabel!
    var price: UILabel!
    var location: UILabel!
    var imageView: UIImageView!
    var createdDate: UILabel! 
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        layer.cornerRadius = 6
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}







extension ProductCell {
    
    func setupUI() {
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 184).isActive = true
        imageView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        title = UILabel()
        title.font = UIFont.systemFont(ofSize: 14)
        title.textColor = .black
        title.numberOfLines = 2
        title.lineBreakMode = .byTruncatingTail
        title.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(title)
        
        title.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        title.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        title.widthAnchor.constraint(equalToConstant: 160).isActive = true
        
        price = UILabel()
        price.font = UIFont.boldSystemFont(ofSize: 16)
        price.textColor = .black
        price.numberOfLines = 1
        price.textAlignment = .left
        price.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(price)
        
        price.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 4).isActive = true
        price.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        price.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        location = UILabel()
        location.font = UIFont.systemFont(ofSize: 10)
        location.textColor = .gray
        location.numberOfLines = 1
        location.textAlignment = .left
        location.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(location)
        location.topAnchor.constraint(equalTo: price.bottomAnchor, constant: 4).isActive = true
        location.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        location.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        
        createdDate = UILabel()
        createdDate.font = UIFont.systemFont(ofSize: 10)
        createdDate.textColor = .gray
        createdDate.numberOfLines = 1
        createdDate.textAlignment = .left
        createdDate.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(createdDate)
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



