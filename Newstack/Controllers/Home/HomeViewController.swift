//
//  HomeViewController.swift
//  Newstack
//
//  Created by Aaron Cleveland on 6/25/20.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let networkManager = NetworkingManager()
    
    //=======================
    // MARK: - Properties
    let mainNewsTitle = CustomLabel(style: .header, text: "Headlines")
    
    //=======================
    // MARK: - Computed Properties
    let mainHStack: UIStackView = {
        let mainHStack = UIStackView()
        mainHStack.translatesAutoresizingMaskIntoConstraints = false
        mainHStack.axis = .horizontal
        return mainHStack
    }()
    
    let secondHStack: UIStackView = {
        let secondHStack = UIStackView()
        secondHStack.translatesAutoresizingMaskIntoConstraints = false
        secondHStack.axis = .horizontal
        return secondHStack
    }()
    
    let headlineCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 375, height: 250)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(HeadlineCollectionViewCell.self, forCellWithReuseIdentifier: HeadlineCollectionViewCell.identifier)
        cv.backgroundColor = .systemBackground
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        headlineCollectionView.delegate = self
        headlineCollectionView.dataSource = self
        networkManager.fetchNews {
            self.updateViews()
        }
        setupNavigationController()
        setupSubviews()
        setupConstraints()
    }
    
    func setupNavigationController() {
        self.navigationItem.title = "Newstack"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func updateViews() {
        print(networkManager.myFeed)
        headlineCollectionView.reloadData()
    }
}

extension HomeViewController {
    func setupSubviews() {
        view.addSubview(headlineCollectionView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            headlineCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            headlineCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            headlineCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            headlineCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return networkManager.myFeed.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeadlineCollectionViewCell.identifier, for: indexPath) as? HeadlineCollectionViewCell else { return UICollectionViewCell() }

        let newArticle = networkManager.myFeed[indexPath.item]
        cell.article = newArticle
        
        guard let url = newArticle.urlToImage else { return UICollectionViewCell() }
        networkManager.fetchImage(imageURL: url) { (data) in
            guard let newImage = UIImage(data: data) else { return }
            cell.headlineImage.image = newImage
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let itemWidth = collectionView.bounds.width
            let itemHeight = collectionView.bounds.height
            return CGSize(width: itemWidth, height: itemHeight)
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let article = networkManager.myFeed[indexPath.item]
//    }

}
