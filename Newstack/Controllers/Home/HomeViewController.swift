//
//  HomeViewController.swift
//  Newstack
//
//  Created by Aaron Cleveland on 6/25/20.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let networkManager = NetworkingManager()
    private let articleDetailVC = ArticleDetailViewController()
    
    //=======================
    // MARK: - Stored Properties
    let tableBackgroundView = UIView()
    let catergoryTableView = UITableView()
    let firstHStack = CustomStackView(style: .horizontal, distribution: .fill, alignment: .fill)
    let contentStack = CustomStackView(style: .contentStack, distribution: .fill, alignment: .fill)
    
    let headlineCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 350, height: 200)
        layout.minimumLineSpacing = 20
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(HeadlineCollectionViewCell.self, forCellWithReuseIdentifier: HeadlineCollectionViewCell.identifier)
        cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        headlineCollectionView.delegate = self
        headlineCollectionView.dataSource = self
        setupNavigationController()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        networkManager.fetchSources {
            print("\(self.networkManager.sourcesFeed.count)")
            self.updateViews()
        }
    }
    
    func configureUI() {
        view.addSubview(headlineCollectionView)
        headlineCollectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                      bottom: view.bottomAnchor,
                                      leading: view.leadingAnchor,
                                      trailing: view.trailingAnchor,
                                      anchorLeading: 10,
                                      anchorTrailing: -10)
    }
    
    func setupNavigationController() {
        self.navigationItem.title = "Top Headlines"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func updateViews() {
        networkManager.fetchHeadlines(country: "us") {
            self.headlineCollectionView.reloadData()
        }
        catergoryTableView.reloadData()
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return networkManager.headlineFeed.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeadlineCollectionViewCell.identifier, for: indexPath) as! HeadlineCollectionViewCell
        let newArticle = networkManager.headlineFeed[indexPath.item]
        cell.headlineArticle = newArticle
        
        if let url = newArticle.urlToImage {
            networkManager.fetchImage(imageURL: url) { (data) in
                guard let newImage = UIImage(data: data) else { return }
                cell.headlineImage.image = newImage
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc: ArticleDetailViewController = ArticleDetailViewController()
        let selectedArticle = networkManager.headlineFeed[indexPath.item]
        vc.article = selectedArticle
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}
