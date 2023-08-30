//
//  ViewController.swift
//  avito-tech-task
//
//  Created by macbook on 26.08.2023.
//

import UIKit
import Kingfisher

class MainViewController: UIViewController {
    
    var collectionView: UICollectionView!
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
    
    
    private var isLoading = false
    private var isError = false
    
    private var advertisements: [Advertisement] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Список товаров"
        view.backgroundColor = .white
        
        
        setupCollectionView()
        setupConstaints()
        showLoadingState()
        loadData()
    }
    
    // загрузка данных из JSON
    func loadData() {
        let urlString = "https://www.avito.st/s/interns-ios/main-page.json"
        guard let url = URL(string: urlString) else {
            showErrorState()
            return
        }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { (data, error, response) in
            // проверка наличия ошибок
            guard error != nil else {
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
                let advertisements = try decoder.decode(Advertisements.self, from: data)
                
                for advertisement in advertisements.advertisements {
                    self.advertisements.append(advertisement)
                }
                
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
    
    func showLoadingState() {
        isLoading = true
        isError = false
        
        collectionView.isHidden = true
        errorLabel.isHidden = true
        activityIndicator.isHidden = false
        
        activityIndicator.startAnimating()
    }
    func showErrorState() {
        isLoading = false
        isError = true
        
        collectionView.isHidden = true
        errorLabel.isHidden = false
        activityIndicator.isHidden = true
        
        activityIndicator.stopAnimating()
    }
    func showDataState() {
        isLoading = false
        isError = false
        
        collectionView.isHidden = false
        errorLabel.isHidden = true
        activityIndicator.isHidden = true
        
        activityIndicator.stopAnimating()
        collectionView.reloadData()
    }
    func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: createLayout())
        collectionView.register(ProductCell.self,
                                forCellWithReuseIdentifier: "productCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func setupConstaints() {
        
        
        view.addSubview(activityIndicator)
        view.addSubview(errorLabel)
        
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
               
       
        activityIndicator.isHidden = true
        errorLabel.isHidden = true
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

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        advertisements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as? ProductCell else { return UICollectionViewCell() }
        
        let advertisement = advertisements[indexPath.item]
        
        var imageURLs: [URL] = []
        
        for advertisement in advertisements {
            if let url = URL(string: advertisement.imageURL)  { imageURLs.append(url)
            }
        }
        let imageURL = imageURLs[indexPath.row]
        
        cell.imageView.kf.setImage(with: imageURL)
        cell.add(title: advertisement.title)
        cell.add(price: advertisement.price)
        cell.add(location: advertisement.location)
        cell.add(createdDate: advertisement.createdDate)
        
        
        
        //cell.loadImage(from: advertisement.imageURL,
                      // placeholder: UIImage(systemName: "wifi.slash"))
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = advertisements[indexPath.item]
        
        let vc = AdvertisementDetailViewController()
        
        vc.advertisement = selectedItem
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension MainViewController: UICollectionViewDelegate {
    
    
}

    

