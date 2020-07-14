//
//  ArticleDetailViewController.swift
//  Newstack
//
//  Created by Aaron Cleveland on 6/25/20.
//

import Foundation
import UIKit

class ArticleDetailViewController: UIViewController {
    
    var gradientView = CAGradientLayer()
    var activityViewController: UIActivityViewController?
    
    var article: NewsSource.Article? {
        didSet {
            updateViews()
        }
    }
    
    let articleDate = CustomLabel(style: .detailDate, text: "")
    let articleTitle = CustomLabel(style: .detailTitle, text: "")
    let articleDetail = CustomLabel(style: .detailContent, text: "")
    let articleAuthorName = CustomLabel(style: .detailAuthor, text: "")
    let articleAuthorPaper = CustomLabel(style: .detailPaper, text: "")
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.delaysContentTouches = false
        scrollView.bounces = false
        return scrollView
    }()
    
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
//        topView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        return topView
    }()
    
    let topViewBackgroundImage: UIImageView = {
        let topImage = UIImageView()
        topImage.translatesAutoresizingMaskIntoConstraints = false
        topImage.contentMode = .scaleAspectFill
        topImage.image = UIImage(named: "")
        topImage.backgroundColor = .blue
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
        UIApplication.shared.open(url)
    }
    
    private func addGradientDetail() {
        gradientView.frame = topViewBackgroundImage.bounds
        gradientView.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        topViewBackgroundImage.layer.insertSublayer(gradientView, at: 0)
    }

    private func updateViews() {
        guard let article = article,
              let url = article.urlToImage else { return }
        let data = try? Data(contentsOf: url)
        articleTitle.text = article.title
        articleDate.text = article.formattedDate
        articleDetail.text = article.content ?? "No Content"
        articleAuthorPaper.text = "@\(article.source.name ?? "No Source")"
        topViewBackgroundImage.image = UIImage(data: data!)
    }
}

private extension UIImage {
    func scaled(to maxSize: CGFloat) -> UIImage? {
        let aspectRatio: CGFloat = min(maxSize / size.width, maxSize / size.height)
        let newSize = CGSize(width: size.width * aspectRatio, height: size.height * aspectRatio)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { context in
            draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        }
    }
}

extension ArticleDetailViewController {
    func setupSubviews() {
        articleDetailVStack.addArrangedSubview(articleTitle)
        articleDetailVStack.addArrangedSubview(articleDate)
        articleDetailVStack.addArrangedSubview(authorHStack)
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
        scrollView.addSubview(readMoreButton)
        scrollView.addSubview(contentStack)
        view.addSubview(scrollView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            topButtons.topAnchor.constraint(equalTo: contentStack.topAnchor, constant: 20),
            topButtons.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            topButtons.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),

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
            
            line.topAnchor.constraint(equalTo: authorHStack.bottomAnchor, constant: 20),
            line.leadingAnchor.constraint(equalTo: contentStack.leadingAnchor, constant: 20),
            line.trailingAnchor.constraint(equalTo: contentStack.trailingAnchor, constant: view.bounds.width * -0.75),
            line.heightAnchor.constraint(equalToConstant: 4),
            
            readMoreButton.topAnchor.constraint(greaterThanOrEqualTo: contentStack.bottomAnchor),
            readMoreButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            readMoreButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            readMoreButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            readMoreButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}
