//
//  HomeViewController.swift
//  Newstack
//
//  Created by Aaron Cleveland on 6/25/20.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {
    
    var articles = [NewsSource.Article]()
    var headlineArticle = [NewsSource.Article]()
    var selectedArticle: NewsSource.Article?
    
    //=======================
    // MARK: - Properties
    let mainNewsTitle = CustomLabel(style: .header, text: "Headlines")
    let secondNewsTitle = CustomLabel(style: .header, text: "Trump")

    //=======================
    // MARK: - Computed Propties
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        headlineCollectionView.delegate = self
        headlineCollectionView.dataSource = self
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
    func setupSubviews() {
        secondHStack.addArrangedSubview(secondNewsTitle)
        
        view.addSubview(headlineCollectionView)
        view.addSubview(secondHStack)
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
        ])
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return headlineArticle.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "headlineCell", for: indexPath) as! HeadlineCollectionViewCell
        let article = headlineArticle[indexPath.item]
        cell.headlineTitle.text = article.title
        cell.headlineAuthor.text = article.author
        
        let url = URL(string: "\(article.urlToImage!)")
        let data = try? Data(contentsOf: url!)
        cell.headlineImage.image = UIImage(data: data!)
        cell.layoutIfNeeded()
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc: ArticleDetailViewController = ArticleDetailViewController()
        selectedArticle = headlineArticle[indexPath.item]
        guard let url = selectedArticle?.urlToImage else { return }
        let data = try? Data(contentsOf: url)
        vc.articleTitle.text = selectedArticle?.title
        vc.articleDate.text = selectedArticle?.formattedDate
        vc.articleDetail.text = selectedArticle?.content ?? "No Content"
        vc.articleAuthorName.text = selectedArticle?.author ?? "No Author"
        vc.articleAuthorPaper.text = selectedArticle?.source.name ?? "No Source"
        vc.topViewBackgroundImage.image = UIImage(data: data!)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 250, height: 150)
    }
}

extension HomeViewController {
    
    func fetchEverything() {
        let everythingURL = AF.request("https://newsapi.org/v2/everything?q=trump&apiKey=569bbdc4ab8c42af93e505b90149e026")
            .validate()
        everythingURL.responseDecodable(of: NewsSource.self) { (response) in
            guard let articles = response.value else { return }
            self.articles = articles.articles
            self.headlineCollectionView.reloadData()
        }
    }
    
    func fetchHeadlines() {
        let headlineURL = AF.request("https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=569bbdc4ab8c42af93e505b90149e026")
            .validate()
        headlineURL.responseDecodable(of: NewsSource.self) { (response) in
            guard let headlineArticles = response.value else { return }
            self.headlineArticle = headlineArticles.articles
            self.headlineCollectionView.reloadData()
        }
    }
}
