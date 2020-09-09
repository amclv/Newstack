//
//  ArticleDetailViewController.swift
//  Newstack
//
//  Created by Aaron Cleveland on 6/25/20.
//

import Foundation
import UIKit
import WebKit

class ArticleDetailViewController: UIViewController {
    
    var gradientView = CAGradientLayer()
    var activityViewController: UIActivityViewController?
    let networkManager = NetworkingManager()
    var articleController: ArticleController?
    
    var article: ArticleRepresentation? {
        didSet {
            updateViews()
        }
    }
    
    var articleSave: Article?
    
    var articleURL = UILabel()
    let articleDate = CustomLabel(style: .detailDate, text: "")
    let articleTitle = CustomLabel(style: .detailTitle, text: "")
    let articleDetail = CustomLabel(style: .detailContent, text: "")
    let articleAuthorName = CustomLabel(style: .detailAuthor, text: "")
    let articleAuthorPaper = CustomLabel(style: .detailPaper, text: "")
    let contentStack = CustomStackView(style: .contentStack, distribution: .fill, alignment: .fill)
    let articleDetailVStack = CustomStackView(style: .articleDetailVStack, distribution: .fill, alignment: .fill)
    let authorDetailHStack = CustomStackView(style: .authorDetailHStack, distribution: .equalCentering, alignment: .leading)
    let authorHStack = CustomStackView(style: .authorHStack, distribution: .fill, alignment: .fill)
    let topButtons = CustomStackView(style: .topButtons, distribution: .equalSpacing, alignment: .fill)
    let topRightButtons = CustomStackView(style: .topRightButtons, distribution: .equalSpacing, alignment: .fill)

    let topView: UIView = {
        var topView = UIView()
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.contentMode = .scaleAspectFill
        topView.clipsToBounds = true
        topView.layer.cornerRadius = 10
        return topView
    }()
    
    let topViewBackgroundImage: UIImageView = {
        let topImage = UIImageView()
        topImage.translatesAutoresizingMaskIntoConstraints = false
        topImage.contentMode = .scaleAspectFill
        topImage.image = UIImage(named: "")
        return topImage
    }()
    
    let line: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = .systemGray
        line.layer.cornerRadius = 2
        return line
    }()
    
    let shareButton: CustomButton = {
        let shareButton = CustomButton(style: .socialMedia)
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up")?.scaled(to: 25)?.withTintColor(.label, renderingMode: .alwaysOriginal), for: .normal)
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        return shareButton
    }()
    
    let backButton: CustomButton = {
        let backButton = CustomButton(style: .backButton)
        backButton.setImage(UIImage(systemName: "arrow.left")?.scaled(to: 25)?.withTintColor(.label, renderingMode: .alwaysOriginal), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return backButton
    }()
    
    let bookmarkButton: CustomButton = {
        let bookButton = CustomButton(style: .bookmarkButton)
        bookButton.setImage(UIImage(systemName: "bookmark")?.scaled(to: 25)?.withTintColor(.label, renderingMode: .alwaysOriginal), for: .normal)
        bookButton.addTarget(self, action: #selector(bookmarkArticleTapped), for: .touchUpInside)
        return bookButton
    }()
    
    let readMoreButton: UIButton = {
        let readMoreButton = UIButton()
        readMoreButton.translatesAutoresizingMaskIntoConstraints = false
        readMoreButton.backgroundColor = .systemBlue
        readMoreButton.layer.cornerRadius = 10
        readMoreButton.setTitle("Read More", for: .normal)
        readMoreButton.addTarget(self, action: #selector(readMoreButtonTapped), for: .touchUpInside)
        return readMoreButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Background")
        setupSubviews()
        setupConstraints()
    }
    
    override func viewWillLayoutSubviews() {
        super .viewWillLayoutSubviews()
        // adding gradient
//        addGradientDetail()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    @objc func backButtonTapped() {
        print("BACK BUTTON PRESSED")
        dismiss(animated: true, completion: nil)
    }
    
    @objc func bookmarkArticleTapped() {
        print("BOOKMARKED ARTICLE PRESSED")
        if let article = article {
            guard let author = articleAuthorPaper.text,
                let content = articleDetail.text,
                let publishedAt = articleDate.text,
                let title = articleTitle.text,
                let url = article.url?.absoluteString,
                let urlToImage = article.urlToImage?.absoluteString else { return }
            _ = Article(author: author,
                                  content: content,
                                  publishedAt: publishedAt,
                                  title: title,
                                  url: url,
                                  urlToImage: urlToImage,
                                  context: CoreDataStack.shared.mainContext)
            do {
                try? CoreDataStack.shared.mainContext.save()
            } catch {
                print("Error Saving data")
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func shareButtonTapped() {
        print("SHARED ARTICLE BUTTON PRESSED")
        activityViewController = UIActivityViewController(activityItems: [article!.url!], applicationActivities: nil)
        present(activityViewController!, animated: true, completion: nil)
    }
    
    @objc func readMoreButtonTapped() {
        print("READ MORE BUTTON TAPPED")
        guard let url = article?.url else { return }
        let vc = WebViewController()
        vc.articleURL = url
        present(vc, animated: true, completion: nil)
    }
    
    private func addGradientDetail() {
        gradientView.frame = topViewBackgroundImage.bounds
        gradientView.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        topViewBackgroundImage.layer.insertSublayer(gradientView, at: 0)
    }

    private func updateViews() {
        guard let article = article,
            let urlToImage = article.urlToImage else { return }
        let data = try? UIImage(withContentsOfUrl: urlToImage)
        articleTitle.text = article.title
        articleDate.text = article.formattedDate
        articleDetail.text = article.content ?? "No Content"
        articleAuthorPaper.text = "@\(article.source.name ?? "No Source")"
        topViewBackgroundImage.image = data ?? UIImage(systemName: "xmark.octagon.fill")?.scaled(to: 100)?.withTintColor(.label)
    }
}

extension ArticleDetailViewController {
    func setupSubviews() {
        articleDetailVStack.addArrangedSubview(articleTitle)
        articleDetailVStack.addArrangedSubview(authorHStack)
        articleDetailVStack.addArrangedSubview(articleDate)
        articleDetailVStack.addArrangedSubview(line)
        articleDetailVStack.addArrangedSubview(articleDetail)
        
        authorHStack.addArrangedSubview(articleAuthorPaper)
        
        topView.addSubview(topViewBackgroundImage)
        topRightButtons.addArrangedSubview(bookmarkButton)
        topRightButtons.addArrangedSubview(shareButton)
        
        topButtons.addArrangedSubview(backButton)
        topButtons.addArrangedSubview(topRightButtons)
        topButtons.alignment = .center

        contentStack.addArrangedSubview(topButtons)
        contentStack.addArrangedSubview(topView)
        contentStack.addArrangedSubview(articleDetailVStack)
        view.addSubview(readMoreButton)
        view.addSubview(contentStack)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentStack.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            topButtons.topAnchor.constraint(equalTo: contentStack.topAnchor, constant: 20),
            topButtons.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            topButtons.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            topView.topAnchor.constraint(equalTo: topRightButtons.bottomAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            topView.heightAnchor.constraint(equalToConstant: 250),
            
            topViewBackgroundImage.topAnchor.constraint(equalTo: topView.topAnchor),
            topViewBackgroundImage.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            topViewBackgroundImage.bottomAnchor.constraint(equalTo: topView.bottomAnchor),
            topViewBackgroundImage.trailingAnchor.constraint(equalTo: topView.trailingAnchor),

            articleDetailVStack.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 20),
            articleDetailVStack.leadingAnchor.constraint(equalTo: contentStack.leadingAnchor, constant: 20),
            articleDetailVStack.trailingAnchor.constraint(equalTo: contentStack.trailingAnchor, constant: -20),
            
            line.topAnchor.constraint(equalTo: articleDate.bottomAnchor, constant: 20),
            line.leadingAnchor.constraint(equalTo: contentStack.leadingAnchor, constant: 20),
            line.trailingAnchor.constraint(equalTo: contentStack.trailingAnchor, constant: view.bounds.width * -0.75),
            line.heightAnchor.constraint(equalToConstant: 4),
            
            readMoreButton.topAnchor.constraint(greaterThanOrEqualTo: contentStack.bottomAnchor),
            readMoreButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            readMoreButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            readMoreButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            readMoreButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}
