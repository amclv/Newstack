//
//  HomeViewController.swift
//  Newstack
//
//  Created by Aaron Cleveland on 6/25/20.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {
    
    var articles = [NewsSource.ArticleRepresentation]()
    var headlineArticle = [NewsSource.ArticleRepresentation]()
    var selectedArticle: NewsSource.ArticleRepresentation?
    
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
        cv.register(EverythingCollectionViewCell.self, forCellWithReuseIdentifier: "everythingCell")
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
        setupNavigationController()
        setupSubviews()
        setupConstraints()
        fetchEverything()
        fetchHeadlines()
    }
    
    func setupNavigationController() {
        self.navigationItem.title = "Headlines"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension HomeViewController {
    func fetchEverything() {
        let everythingURL = AF.request("https://newsapi.org/v2/everything?q=a&apiKey=9eca91b2275d4214bd7f6b88f726f3df")
            .validate()
        everythingURL.responseDecodable(of: NewsSource.self) { (response) in
            guard let articles = response.value else { return }
            self.articles = articles.articles
            self.everythingCollectionView.reloadData()
        }
    }
    
    func fetchHeadlines() {
        let headlineURL = AF.request("https://newsapi.org/v2/top-headlines?country=us&apiKey=9eca91b2275d4214bd7f6b88f726f3df")
            .validate()
        headlineURL.responseDecodable(of: NewsSource.self) { (response) in
            guard let headlineArticles = response.value else { return }
            self.headlineArticle = headlineArticles.articles
            self.headlineCollectionView.reloadData()
        }
    }
    
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
        if headlineCollectionView == self.headlineCollectionView {
            return headlineArticle.count
        }
        return articles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == headlineCollectionView {
            let headlineCell = collectionView.dequeueReusableCell(withReuseIdentifier: "headlineCell", for: indexPath) as! HeadlineCollectionViewCell
            let headlineArt = headlineArticle[indexPath.item]
            headlineCell.headlineTitle.text = headlineArt.title
            headlineCell.headlineAuthor.text = headlineArt.author
            let url = URL(string: "\(headlineArt.urlToImage ?? URL.init(string: "aaroncleveland.com"))")
            if let data = try? Data(contentsOf: url!) {
                headlineCell.headlineImage.image = UIImage(data: data)
            } else {
                headlineCell.headlineImage.image = UIImage(systemName: "xmark.seal")?.withTintColor(.systemRed)
            }
            headlineCell.layoutIfNeeded()
            return headlineCell
        } else {
            let everythingCell = collectionView.dequeueReusableCell(withReuseIdentifier: "everythingCell", for: indexPath) as! EverythingCollectionViewCell
            let article = articles[indexPath.item]
            everythingCell.articleTitle.text = article.title
            everythingCell.articleDate.text = article.formattedDate
            let url = URL(string: "\(article.urlToImage!)")
            if let data = try? Data(contentsOf: url!) {
                everythingCell.articleImage.image = UIImage(data: data)
            } else {
                everythingCell.articleImage.image = UIImage(systemName: "xmark.seal")?.withTintColor(.systemRed)
            }
            everythingCell.layoutIfNeeded()
            return everythingCell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc: ArticleDetailViewController = ArticleDetailViewController()
        selectedArticle = headlineArticle[indexPath.item]
        guard let url = selectedArticle?.urlToImage else { return }
        vc.articleTitle.text = selectedArticle?.title
        vc.articleDate.text = selectedArticle?.formattedDate
        vc.articleDetail.text = selectedArticle?.content ?? "No Content"
        vc.articleAuthorName.text = selectedArticle?.author ?? "No Author"
        vc.articleAuthorPaper.text = selectedArticle?.source.name ?? "No Source"
        if let data = try? Data(contentsOf: url) {
            vc.topViewBackgroundImage.image = UIImage(data: data)
        } else {
            vc.topViewBackgroundImage.image = UIImage(systemName: "xmark.seal")?.withTintColor(.systemRed)
        }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 250, height: 150)
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}
