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
    let secondaryNewsLabel = CustomLabel(style: .description, text: "Everything")
    
    let contentStack = CustomStackView(style: .contentStack, distribution: .fill, alignment: .fill)
    
    var picker = UIPickerView()
    var toolBar = UIToolbar()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.delaysContentTouches = false
        scrollView.bounces = false
        return scrollView
    }()
    
    let firstHStack = CustomStackView(style: .horizontal, distribution: .fill, alignment: .fill)
    
    let secondaryHStack: UIStackView = {
        let secondHStack = UIStackView()
        secondHStack.translatesAutoresizingMaskIntoConstraints = false
        secondHStack.axis = .horizontal
        return secondHStack
    }()
    
    let headlineCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 300, height: 250)
        layout.minimumLineSpacing = 20
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(HeadlineCollectionViewCell.self, forCellWithReuseIdentifier: HeadlineCollectionViewCell.identifier)
        cv.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    let catergoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Background")
        
        headlineCollectionView.delegate = self
        headlineCollectionView.dataSource = self
        
        networkManager.fetchHeadlines(sources: "bbc-news") {
            self.updateViews()
        }
        setupNavigationController()
        setupSubviews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        networkManager.fetchSources {
            print("\(self.networkManager.sourcesFeed.count)")
            self.updateViews()
        }
    }
    
    func configureTableView() {
        catergoryTableView.dataSource = self
        catergoryTableView.delegate = self
    }
    
    func setupNavigationController() {
        self.navigationItem.title = "Overview"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func updateViews() {
        headlineCollectionView.reloadData()
    }
}

extension HomeViewController {
    func setupSubviews() {
        secondaryHStack.addArrangedSubview(secondaryNewsLabel)
        
        scrollView.addSubview(firstHStack)
        scrollView.addSubview(headlineCollectionView)
        scrollView.addSubview(secondaryHStack)
        scrollView.addSubview(catergoryTableView)
        view.addSubview(scrollView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            headlineCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headlineCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headlineCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headlineCollectionView.heightAnchor.constraint(equalToConstant: 300),
            
            secondaryHStack.topAnchor.constraint(equalTo: headlineCollectionView.bottomAnchor, constant: 10),
            secondaryHStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            secondaryHStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            catergoryTableView.topAnchor.constraint(equalTo: secondaryHStack.bottomAnchor),
            catergoryTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            catergoryTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            catergoryTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == headlineCollectionView {
            return networkManager.headlineFeed.count
        }
        return networkManager.everythingFeed.count
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
        
        if collectionView == headlineCollectionView {
            let selectedArticle = networkManager.headlineFeed[indexPath.item]
            vc.article = selectedArticle
        } else {
            let selectedArticle = networkManager.everythingFeed[indexPath.item]
            vc.article = selectedArticle
        }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
