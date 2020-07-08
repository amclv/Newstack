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
    var images = [UIImage]()
    
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
        layout.itemSize = CGSize(width: 190, height: 300)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 0

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(HeadlineCollectionViewCell.self, forCellWithReuseIdentifier: HeadlineCollectionViewCell.identifier)
        cv.backgroundColor = .systemBackground
        cv.showsVerticalScrollIndicator = false
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
        if let layout = headlineCollectionView.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        headlineCollectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        setupNavigationController()
        setupSubviews()
        setupConstraints()
    }
    
    func setupNavigationController() {
        self.navigationItem.title = "Newstack"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func updateViews() {
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
            headlineCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            headlineCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
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
            self.images.append(newImage)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc: ArticleDetailViewController = ArticleDetailViewController()
        let selectedArticle = networkManager.myFeed[indexPath.item]
        
        guard let url = selectedArticle.urlToImage else { return }
        let data = try? Data(contentsOf: url)
        vc.articleTitle.text = selectedArticle.title
        vc.articleDate.text = selectedArticle.formattedDate
        vc.articleDetail.text = selectedArticle.content ?? "No Content"
        vc.articleAuthorName.text = selectedArticle.author ?? "No Author"
        vc.articleAuthorPaper.text = selectedArticle.source.name ?? "No Source"
        vc.topViewBackgroundImage.image = UIImage(data: data!)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
}

extension HomeViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 0
        let article = networkManager.myFeed[indexPath.item]
        guard let url = article.urlToImage else { return 0 }
        networkManager.fetchImage(imageURL: url) { (data) in
            guard let newImage = UIImage(data: data) else { return }
            height = newImage.size.height
        }
        return height
    }
}
