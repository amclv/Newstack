//
//  BookmarkViewController.swift
//  Newstack
//
//  Created by Aaron Cleveland on 6/25/20.
//

import UIKit

class BookmarkViewController: UIViewController {
    
    lazy var bookmarkCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize.width = view.bounds.width
        layout.itemSize.height = 100
        layout.minimumLineSpacing = 1
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "bookmarkCell")
        cv.backgroundColor = .systemBackground
        cv.showsVerticalScrollIndicator = false
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        bookmarkCollectionView.dataSource = self
        bookmarkCollectionView.delegate = self
        setupCollectionView()
    }
    
    func setupNavigationController() {
        self.navigationItem.title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupCollectionView() {
        view.addSubview(bookmarkCollectionView)
        NSLayoutConstraint.activate([
            bookmarkCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            bookmarkCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bookmarkCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bookmarkCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension BookmarkViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bookmarkCell", for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
    
    
}
