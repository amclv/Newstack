//
//  EverythingViewController.swift
//  Newstack
//
//  Created by Aaron Cleveland on 9/3/20.
//

import UIKit

class EverythingViewController: UIViewController {
    
    let networkManager = NetworkingManager()
    let vc = ArticleDetailViewController()
    let sources = SourcesViewController()
    let home = HomeViewController()
    
    var id: String?
    var category: String?
    var name: String?
    
    let everythingCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 375, height: 110)
        layout.minimumLineSpacing = 20
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(EverythingCollectionViewCell.self, forCellWithReuseIdentifier: EverythingCollectionViewCell.identifier)
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        configureCollectionView()
        configureNavigationController()
        fetchData()
    }
    
    func fetchData() {
        guard let id = id,
              let category = category else { return }
        networkManager.fetchEverything(sources: id, category: nil) {
            self.everythingCollectionView.reloadData()
        }
        networkManager.fetchEverything(sources: nil, category: category) {
            self.everythingCollectionView.reloadData()
        }
    }
    
    func configureCollectionView() {
        setCollectionDelegate()
        view.addSubview(everythingCollectionView)
        everythingCollectionView.addConstraintsToFillView(view)
    }
    
    func setCollectionDelegate() {
        everythingCollectionView.delegate = self
        everythingCollectionView.dataSource = self
    }
    
    func configureNavigationController() {
        guard let name = name else { return }
        self.navigationItem.title = name 
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension EverythingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return networkManager.everythingFeed.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EverythingCollectionViewCell.identifier, for: indexPath) as! EverythingCollectionViewCell
        
        let everyArticle = networkManager.everythingFeed[indexPath.item]
        
        cell.everythingArticle = everyArticle
        
        if let url = everyArticle.urlToImage {
            networkManager.fetchImage(imageURL: url) { (data) in
                guard let newImage = UIImage(data: data) else { return }
                cell.articleImage.image = newImage
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedArticle = networkManager.everythingFeed[indexPath.item]
        vc.article = selectedArticle
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
}
