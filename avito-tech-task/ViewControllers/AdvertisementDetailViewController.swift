// MARK: - Advertisement Detail View Controller

import UIKit
import Kingfisher

class AdvertisementDetailViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - Properties
    
    var advertisement: Advertisement!
    private let network = AvitoAPI()
    private var isLoading = false
    private var isError = false
    
    // MARK: - UI Elements
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.isDirectionalLockEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imageView: UIImageView = {
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
    
    private var descriptionText: UILabel = {
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
    
    private var user: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2 // Изменено количество строк
        return label
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
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .gray
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let callButton: UIButton = {
        let button = UIButton()
        button.setTitle("Позвонить", for: .normal)
        button.backgroundColor = UIColor(rgb: 0x02D15C)
        return button
    }()
    
    private let chatButton: UIButton = {
        let button = UIButton()
        button.setTitle("Написать", for: .normal)
        button.backgroundColor = UIColor(rgb: 0x00AAFF)
        return button
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }
    
    // MARK: - Conditions
    
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
    }
    
    // MARK: - Button methods
    
    @objc private func callPressed() {
        if let phoneNumber = advertisement?.phoneNumber {
            print("Начинается звонок: \(phoneNumber)")
        }
    }
    
    @objc private func chatPressed() {
        if let phoneNumber = advertisement?.phoneNumber {
            print("Переход в чат с пользователем: \(phoneNumber)")
        }
    }
    
    // MARK: - API
    
    func loadData() {
        guard let id = advertisement?.id else {
            showErrorState()
            return
        }
        
        let urlString = "https://www.avito.st/s/interns-ios/details/\(id).json"
        
        network.fetchData(fromURL: urlString, responseType: Advertisement.self) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let details):
                    self?.advertisement = details
                    self?.contentViewReloadData()
                    self?.showDataState()
                case .failure(let error):
                    print("Error loading data: \(error)")
                    self?.errorLabel.text = "Ошибка при загрузке данных!"
                    self?.showErrorState()
                }
            }
        }
    }
    
    // MARK: - Reload Data
    
    private func contentViewReloadData() {
        guard let advertisement = advertisement else {
            return
        }
        imageView.kf.setImage(with: URL(string: advertisement.imageURL))
        price.text = advertisement.price
        titleText.text = advertisement.title
        descriptionText.text = advertisement.description
        user.text! += "\(advertisement.phoneNumber ?? "")"
        location.text = "\(advertisement.address ?? "")\n\(advertisement.location)"
        createdDate.text = advertisement.createdDate
    }
    
    // MARK: - UI Setup
        
    private func setupUI() {
        view.backgroundColor = .white
        scrollView.delegate = self
        addSubview()
        setupConstraints()
    }
    
    private func addSubview() {
        view.addSubview(scrollView)
        view.addSubview(errorLabel)
        view.addSubview(activityIndicator)
        scrollView.addSubview(contentView)
        contentView.addSubview(imageView)
        contentView.addSubview(price)
        contentView.addSubview(titleText)
        contentView.addSubview(descriptionHeader)
        contentView.addSubview(descriptionText)
        contentView.addSubview(userHeader)
        contentView.addSubview(user)
        contentView.addSubview(location)
        contentView.addSubview(createdDate)
        }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 256),
            
            price.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            price.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            
            titleText.topAnchor.constraint(equalTo: price.bottomAnchor),
            titleText.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            
            descriptionHeader.topAnchor.constraint(equalTo: titleText.bottomAnchor, constant: 20),
            descriptionHeader.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            
            descriptionText.topAnchor.constraint(equalTo: descriptionHeader.bottomAnchor, constant: 10),
            descriptionText.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            descriptionText.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            
            userHeader.topAnchor.constraint(equalTo: descriptionText.bottomAnchor, constant: 20),
            userHeader.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            
            user.topAnchor.constraint(equalTo: userHeader.bottomAnchor, constant: 10),
            user.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            
            location.topAnchor.constraint(equalTo: user.bottomAnchor, constant: 10),
            location.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            
            createdDate.topAnchor.constraint(equalTo: location.bottomAnchor, constant: 20),
            createdDate.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

    }
}


