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
    // MARK: - Stored Properties
    let mainNewsTitle = CustomLabel(style: .header, text: "Headlines")
    let secondaryNewsLabel = CustomLabel(style: .header, text: "Everything")
    
    let secondaryHStack: UIStackView = {
        let secondHStack = UIStackView()
        secondHStack.translatesAutoresizingMaskIntoConstraints = false
        secondHStack.axis = .horizontal
        return secondHStack
    }()
    
    let headlineCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 300, height: 275)
        layout.minimumLineSpacing = 20
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(HeadlineCollectionViewCell.self, forCellWithReuseIdentifier: HeadlineCollectionViewCell.identifier)
        cv.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        cv.backgroundColor = .systemBackground
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    //TODO: - Change this collectionview to tableview.
    let everythingCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 375, height: 100)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(EverythingCollectionViewCell.self, forCellWithReuseIdentifier: "everythingCell")
        cv.backgroundColor = .brown
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Background")
        headlineCollectionView.delegate = self
        headlineCollectionView.dataSource = self
        everythingCollectionView.delegate = self
        everythingCollectionView.dataSource = self
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
        headlineCollectionView.reloadData()
        everythingCollectionView.reloadData()
    }
}

extension HomeViewController {
    func setupSubviews() {
        secondaryHStack.addArrangedSubview(secondaryNewsLabel)
        
        view.addSubview(headlineCollectionView)
        view.addSubview(secondaryHStack)
        view.addSubview(everythingCollectionView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            headlineCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headlineCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headlineCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headlineCollectionView.heightAnchor.constraint(equalToConstant: 300),
            
            secondaryHStack.topAnchor.constraint(equalTo: headlineCollectionView.bottomAnchor, constant: 20),
            secondaryHStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            secondaryHStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            everythingCollectionView.topAnchor.constraint(equalTo: secondaryHStack.bottomAnchor, constant: 20),
            everythingCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            everythingCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            everythingCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if headlineCollectionView == headlineCollectionView {
            return networkManager.headlineFeed.count
        }
        return networkManager.everythingFeed.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == headlineCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeadlineCollectionViewCell.identifier, for: indexPath) as? HeadlineCollectionViewCell else { return UICollectionViewCell() }
            
            let newArticle = networkManager.headlineFeed[indexPath.item]
            cell.article = newArticle
            
            guard let url = newArticle.urlToImage else { return UICollectionViewCell() }
            networkManager.fetchImage(imageURL: url) { (data) in
                guard let newImage = UIImage(data: data) else { return }
                cell.headlineImage.image = newImage
                self.images.append(newImage)
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EverythingCollectionViewCell.identifier, for: indexPath) as? EverythingCollectionViewCell else { return UICollectionViewCell() }
            cell.backgroundColor = .blue
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc: ArticleDetailViewController = ArticleDetailViewController()
        let selectedArticle = networkManager.headlineFeed[indexPath.item]
        
        guard let url = selectedArticle.urlToImage else { return }
        let data = try? Data(contentsOf: url)
        vc.articleTitle.text = selectedArticle.title
        vc.articleDate.text = selectedArticle.formattedDate
        vc.articleDetail.text = selectedArticle.content ?? "No Content"
//        vc.articleAuthorName.text = "By \(selectedArticle.author ?? "No Author")"
        vc.articleAuthorPaper.text = "@\(selectedArticle.source.name ?? "No Source")"
        vc.topViewBackgroundImage.image = UIImage(data: data!)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}
