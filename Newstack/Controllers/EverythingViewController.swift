//
//  EverythingViewController.swift
//  Newstack
//
//  Created by Aaron Cleveland on 9/3/20.
//

import UIKit

class EverythingViewController: UIViewController {
    
    let networkManager = NetworkingManager()
    
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
        networkManager.fetchEverything(sources: "bbc-news") {
            self.everythingCollectionView.reloadData()
        }
    }
    
    func configureCollectionView() {
        view.addSubview(everythingCollectionView)
        everythingCollectionView.addConstraintsToFillView(view)
    }
    
    func setCollectionDelegate() {
        everythingCollectionView.delegate = self
        everythingCollectionView.dataSource = self
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
    
    
}
