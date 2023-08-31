// MARK: - Main View Controller

import UIKit
import Kingfisher

class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    private var advertisements: [Advertisement] = []
    private let network = AvitoAPI()
    private var isLoading = false
    private var isError = false
    
    // MARK: - UI Elements
    
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
    
    private var collectionView: UICollectionView!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Список товаров"
        
        setupUI()
        showLoadingState()
        loadData()
    }
    
    // MARK: - Conditions
    
    private func showLoadingState() {
        isLoading = true
        isError = false
        
        collectionView.isHidden = true
        errorLabel.isHidden = true
        activityIndicator.isHidden = false
        
        activityIndicator.startAnimating()
    }
    
    private func showErrorState() {
        isLoading = false
        isError = true
        
        collectionView.isHidden = true
        errorLabel.isHidden = false
        activityIndicator.isHidden = true
        
        activityIndicator.stopAnimating()
    }
    
    private func showDataState() {
        isLoading = false
        isError = false
        
        collectionView.isHidden = false
        errorLabel.isHidden = true
        activityIndicator.isHidden = true
        
        activityIndicator.stopAnimating()
        collectionView.reloadData()
    }

    // MARK: - API
    
    private func loadData() {
        let urlString = "https://www.avito.st/s/interns-ios/main-page.json"
            
        network.fetchData(fromURL: urlString, responseType: Advertisements.self) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let advertisements):
                    for advertisement in advertisements.advertisements {
                        self?.advertisements.append(advertisement)
                    }
                    self?.showDataState()
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print("Error loading data: \(error)")
                    self?.errorLabel.text = "Ошибка при загрузке данных!"
                    self?.showErrorState()
                }
            }
        }
    }
    
    // MARK: - UI Setup

    private func setupUI() {
        view.backgroundColor = .white
        activityIndicator.isHidden = true
        errorLabel.isHidden = true
        setupCollectionView()
        addSubview()
        setupConstaints()
    }
    
    private func addSubview() {
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        view.addSubview(errorLabel)
    }
        
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: createLayout())
        collectionView.register(AdvertisementCell.self,
                                forCellWithReuseIdentifier: "AdvertisementCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstaints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let spacing: CGFloat = 10
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(320))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(spacing)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        section.interGroupSpacing = spacing

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}


// MARK: - UICollection Delegates

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        advertisements.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdvertisementCell", for: indexPath) as? AdvertisementCell else { return UICollectionViewCell() }
        let advertisement = advertisements[indexPath.item]
        var imageURLs: [URL] = []
        for advertisement in advertisements {
            if let url = URL(string: advertisement.imageURL)  {
                imageURLs.append(url)
            }
        }
        let imageURL = imageURLs[indexPath.row]

        cell.configure(withTitle: advertisement.title,
                       price: advertisement.price,
                       location: advertisement.location,
                       imageURL: imageURL,
                       createdDate: advertisement.createdDate)
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = advertisements[indexPath.item]
        let vc = AdvertisementDetailViewController()
        vc.advertisement = selectedItem
        navigationController?.pushViewController(vc, animated: true)
    }

}

    

