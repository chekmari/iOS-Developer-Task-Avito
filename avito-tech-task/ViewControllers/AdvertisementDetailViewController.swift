//
//  ProductDetailViewController.swift
//  avito-tech-task
//
//  Created by macbook on 26.08.2023.
//

import UIKit

class AdvertisementDetailViewController: UIViewController {
    
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .gray
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    private var errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.isDirectionalLockEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private var price: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.numberOfLines = 1
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    private var titleText: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let descriptionHeader: UILabel = {
        let label = UILabel()
        
        label.text = "Описание"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userHeader: UILabel = {
        let label = UILabel()
        
        label.text = "Пользователь"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private var userLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Номер телефона: "
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private var call: UIButton = {
        let button = UIButton()
        
        button.setTitle("Позвонить", for: .normal)
        button.backgroundColor = UIColor(rgb: 0x02D15C)
        return button
    }()
    private var chat: UIButton = {
        let button = UIButton()
        
        button.setTitle("Написать", for: .normal)
        button.backgroundColor = UIColor(rgb: 0x00AAFF)
        
        return button
    }()
    
    private var location: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        
        return label
    }()
    
    private var createdDate: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .lightGray
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    
    private var isLoading = false
    private var isError = false
    
    var advertisement: Advertisement? 

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        scrollView.delegate = self
        //scrollView.contentSize = .init(width: view.bounds.width, height: view.bounds.height * 3)
        scrollView.layer.borderWidth = 0.3

        addSubview()
        setupConstraints()
        loadData()
        call.addTarget(self, action: #selector(callPressed), for: .touchUpInside)
        chat.addTarget(self, action: #selector(chatPressed), for: .touchUpInside)
    }
    
    private func loadData() {
        let id = advertisement?.id
        
        let urlString = "https://www.avito.st/s/interns-ios/details/\(id!).json"
        
        guard let url = URL(string: urlString) else {
            showErrorState()
            return
        }
        
        let request = URLRequest(url: url)
        print("Before data task")
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("Ошибка при загрузке данных: \(String(describing: error))")
                DispatchQueue.main.async {
                    self.errorLabel.text = "Ошибка при загрузке данных!"
                    self.showLoadingState()
                    self.showErrorState()
                }
                return
            }
            
            guard let data = data else {
                print("Данные не получены!")
                DispatchQueue.main.async {
                    self.errorLabel.text = "Данные не получены!"
                    self.showErrorState()
                }
                return
            }
            
            do
            {
                let decoder = JSONDecoder()
                let details = try decoder.decode(Advertisement.self, from: data)
                self.advertisement = details
                
                DispatchQueue.main.async {

                    self.showDataState()
                }
            }
            catch
            {
                print("Ошибка при парсинге JSON: \(error)")
                DispatchQueue.main.async {
                    self.errorLabel.text = "Ошибка при обработке данных!"
                    self.showErrorState()
                }
            }
            
        }.resume()
    }
    private func showErrorState() {
        isLoading = false
        isError = true
        
        contentView.isHidden = true
        errorLabel.isHidden = false
        activityIndicator.isHidden = true
        
        activityIndicator.stopAnimating()
    }
    private func showLoadingState() {
        isLoading = true
        isError = false
        
        contentView.isHidden = true
        errorLabel.isHidden = true
        activityIndicator.isHidden = false
        
        activityIndicator.startAnimating()
    }
    private func showDataState() {
        isLoading = false
        isError = false
        
        errorLabel.isHidden = true
        activityIndicator.isHidden = true
        contentView.isHidden = false
        
        activityIndicator.stopAnimating()
        contentViewReloadData()
    }
    
    // TODO: - добавить createdDate
    func addSubview() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(imageView)
        contentView.addSubview(price)
        contentView.addSubview(titleText)
        contentView.addSubview(descriptionHeader)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(userHeader)
        contentView.addSubview(userLabel)
        contentView.addSubview(location)
        contentView.addSubview(createdDate)
        
    }
    func setupConstraints() {
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 256).isActive = true
        
        price.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        price.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        
        titleText.topAnchor.constraint(equalTo: price.bottomAnchor).isActive = true
        titleText.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        
        descriptionHeader.topAnchor.constraint(equalTo: titleText.bottomAnchor, constant: 20).isActive = true
        descriptionHeader.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo: descriptionHeader.bottomAnchor, constant: 10).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        
        userHeader.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20).isActive = true
        userHeader.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        
        userLabel.topAnchor.constraint(equalTo: userHeader.bottomAnchor, constant: 10).isActive = true
        userLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        
        location.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 10).isActive = true
        location.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        
        createdDate.topAnchor.constraint(equalTo: location.bottomAnchor, constant: 20).isActive = true
        createdDate.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
    }
   

}

extension AdvertisementDetailViewController: UIScrollViewDelegate {
    
}

// MARK: - нажатие на кнопки
extension AdvertisementDetailViewController {
    
    @objc private func callPressed() {
        print("Начинается звонок: \(advertisement?.phoneNumber ?? "")")
    }
    @objc private func chatPressed() {
        print("Переход в чат с пользователем: \(advertisement?.phoneNumber ?? "")")
    }
}


// MARK: - some methods
extension AdvertisementDetailViewController {
    
    private func contentViewReloadData() {
        guard let advertisement = advertisement else {
            return
            
        }
        price.text = advertisement.price
        titleText.text = advertisement.title
        descriptionLabel.text = advertisement.description
        userLabel.text! += "\(advertisement.phoneNumber ?? "")"
        location.text = "\(advertisement.address ?? "")\n\(advertisement.location)"
        createdDate.text = advertisement.createdDate
        
        
    }
}
