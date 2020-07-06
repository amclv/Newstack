//
//  HomeViewController.swift
//  Newstack
//
//  Created by Aaron Cleveland on 6/25/20.
//

import UIKit

class HomeViewController: UIViewController {
    
    //    var articles = [NewsFeed.ArticleRepresentation]()
    //    var headlineArticle = [NewsFeed.ArticleRepresentation]()
    //    var selectedArticle: NewsFeed.ArticleRepresentation?
    
    private let networkManager = NetworkingManager()
    
    //=======================
    // MARK: - Properties
    let mainNewsTitle = CustomLabel(style: .header, text: "Headlines")
    let secondNewsTitle = CustomLabel(style: .header, text: "Everything")
    
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
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 300, height: 300)
        layout.minimumLineSpacing = 30
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(HeadlineCollectionViewCell.self, forCellWithReuseIdentifier: "headlineCell")
        cv.backgroundColor = .systemBackground
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    let everythingCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 180, height: 200)
        layout.minimumLineSpacing = 10
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
//        cv.register(EverythingCollectionViewCell.self, forCellWithReuseIdentifier: "everythingCell")
        cv.backgroundColor = .systemBackground
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        headlineCollectionView.delegate = self
        headlineCollectionView.dataSource = self
        everythingCollectionView.delegate = self
        everythingCollectionView.dataSource = self
        headlineCollectionView.reloadData()
        setupNavigationController()
        setupSubviews()
        setupConstraints()
    }
    
    func setupNavigationController() {
        self.navigationItem.title = "Headlines"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension HomeViewController {
    func setupSubviews() {
        secondHStack.addArrangedSubview(secondNewsTitle)
        view.addSubview(headlineCollectionView)
        view.addSubview(secondHStack)
        view.addSubview(everythingCollectionView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            headlineCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            headlineCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            headlineCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            headlineCollectionView.heightAnchor.constraint(equalToConstant: 300),
            
            secondHStack.topAnchor.constraint(equalTo: headlineCollectionView.bottomAnchor, constant: 20),
            secondHStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            secondHStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            everythingCollectionView.topAnchor.constraint(equalTo: secondHStack.bottomAnchor, constant: 20),
            everythingCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            everythingCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            everythingCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(networkManager.headlineArticle.count)
        return networkManager.headlineArticle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let headlineCell = collectionView.dequeueReusableCell(withReuseIdentifier: "headlineCell", for: indexPath) as! HeadlineCollectionViewCell
        let headlineArt = networkManager.headlineArticle[indexPath.item]
        headlineCell.headlineTitle.text = headlineArt.title
        let url = URL(string: "\(headlineArt.urlToImage)")
        if let data = try? Data(contentsOf: url!) {
            headlineCell.headlineImage.image = UIImage(data: data)
        } else {
            headlineCell.headlineImage.image = UIImage(systemName: "xmark.seal")?.withTintColor(.systemRed)
        }
        headlineCell.layoutIfNeeded()
        return headlineCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 250, height: 150)
    }
}
