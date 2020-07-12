//
//  ArticleDetailViewController.swift
//  Newstack
//
//  Created by Aaron Cleveland on 6/25/20.
//

import Foundation
import UIKit

class ArticleDetailViewController: UIViewController {
    
    var socialMediaButtons: CGFloat = 30
    var gradientView = CAGradientLayer()
    var activityViewController: UIActivityViewController?
    
    let articleDate = CustomLabel(style: .detailDate, text: "")
    let articleTitle = CustomLabel(style: .detailTitle, text: "")
    let articleDetail = CustomLabel(style: .detailContent, text: "")
    let articleAuthorName = CustomLabel(style: .detailAuthor, text: "")
    let articleAuthorPaper = CustomLabel(style: .detailPaper, text: "")
    var articleURL: [URL] = []
    
    let shareButton: CustomButton = {
        let shareButton = CustomButton(style: .socialMedia)
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up")?.scaled(to: 15), for: .normal)
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        return shareButton
    }()
    
    let topButtons: UIStackView = {
        let topButton = UIStackView()
        topButton.translatesAutoresizingMaskIntoConstraints = false
        topButton.axis = .horizontal
        topButton.spacing = 300
        return topButton
    }()
    
    let backButton: CustomButton = {
        let backButton = CustomButton(style: .backButton)
        backButton.setImage(UIImage(systemName: "arrow.left")?.scaled(to: 35)?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return backButton
    }()
    
    let bookmarkButton: CustomButton = {
        let bookButton = CustomButton(style: .bookButton)
        bookButton.setImage(UIImage(systemName: "bookmark")?.scaled(to: 35)?.withTintColor(.clear, renderingMode: .alwaysOriginal), for: .normal)
        bookButton.addTarget(self, action: #selector(bookmarkArticleTapped), for: .touchUpInside)
        return bookButton
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.delaysContentTouches = false
        scrollView.bounces = false
        return scrollView
    }()

    // ContentStack that controls everything on UI.
    let contentStack: UIStackView = {
        let contentStack = UIStackView()
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .vertical
        contentStack.spacing = 20
        return contentStack
    }()

    // FormContentStack that controls everything besides the image at the top.
    let formContentStack: UIStackView = {
        let formContentStack = UIStackView()
        formContentStack.translatesAutoresizingMaskIntoConstraints = false
        formContentStack.axis = .vertical
        formContentStack.spacing = 20
        formContentStack.isLayoutMarginsRelativeArrangement = true
        return formContentStack
    }()

    let topView: UIView = {
        var topView = UIView()
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.contentMode = .scaleAspectFit
        topView.clipsToBounds = true
        topView.layer.cornerRadius = 10
        topView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
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

    let socialMediaHStack: UIStackView = {
        let socialMediaHStack = UIStackView()
        socialMediaHStack.translatesAutoresizingMaskIntoConstraints = false
        socialMediaHStack.axis = .horizontal
        socialMediaHStack.distribution = .fill
        socialMediaHStack.alignment = .fill
        socialMediaHStack.spacing = 10
        return socialMediaHStack
    }()

    let blankView: UIView = {
        let bv = UIView()
        bv.translatesAutoresizingMaskIntoConstraints = false
        return bv
    }()

    let articleDetailVStack: UIStackView = {
        let articleDetailVStack = UIStackView()
        articleDetailVStack.translatesAutoresizingMaskIntoConstraints = false
        articleDetailVStack.axis = .vertical
        articleDetailVStack.distribution = .fill
        articleDetailVStack.alignment = .fill
        articleDetailVStack.spacing = 10
        return articleDetailVStack
    }()

    let authorDetailHStack: UIStackView = {
        let authorHStack = UIStackView()
        authorHStack.translatesAutoresizingMaskIntoConstraints = false
        authorHStack.axis = .horizontal
        authorHStack.distribution = .fill
        authorHStack.alignment = .leading
        authorHStack.spacing = 10
        return authorHStack
    }()

    let authorVStack: UIStackView = {
        let authorVStack = UIStackView()
        authorVStack.translatesAutoresizingMaskIntoConstraints = false
        authorVStack.axis = .vertical
        authorVStack.distribution = .fill
        authorVStack.alignment = .fill
        return authorVStack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupSubviews()
        setupConstraints()
    }
    
    override func viewWillLayoutSubviews() {
        super .viewWillLayoutSubviews()
        addGradientDetail()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func bookmarkArticleTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func shareButtonTapped() {
        activityViewController = UIActivityViewController(activityItems: [], applicationActivities: nil)
        present(activityViewController!, animated: true, completion: nil)
    }
    
    private func addGradientDetail() {
        gradientView.frame = topViewBackgroundImage.bounds
        gradientView.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        topViewBackgroundImage.layer.insertSublayer(gradientView, at: 0)
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
        articleDetailVStack.addArrangedSubview(articleDate)
        articleDetailVStack.addArrangedSubview(articleTitle)
        articleDetailVStack.addArrangedSubview(authorDetailHStack)

        authorVStack.addArrangedSubview(articleAuthorName)
        authorVStack.addArrangedSubview(articleAuthorPaper)

        topButtons.addArrangedSubview(backButton)
        topButtons.addArrangedSubview(bookmarkButton)
        
        authorDetailHStack.addArrangedSubview(authorVStack)
        topView.addSubview(topViewBackgroundImage)
        topView.addSubview(topButtons)
        topView.addSubview(articleDetailVStack)

        socialMediaHStack.addArrangedSubview(shareButton)
        socialMediaHStack.addArrangedSubview(blankView)

        formContentStack.addArrangedSubview(socialMediaHStack)
        formContentStack.addArrangedSubview(articleDetail)

        contentStack.addArrangedSubview(topView)
        contentStack.addArrangedSubview(formContentStack)
        scrollView.addSubview(contentStack)
        view.addSubview(scrollView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: view.widthAnchor),

            topView.topAnchor.constraint(equalTo: contentStack.topAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 400),
            
            topViewBackgroundImage.topAnchor.constraint(equalTo: topView.topAnchor),
            topViewBackgroundImage.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            topViewBackgroundImage.bottomAnchor.constraint(equalTo: topView.bottomAnchor),
            topViewBackgroundImage.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            
            topButtons.topAnchor.constraint(equalTo: topView.topAnchor, constant: 60),
            topButtons.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 20),
            topButtons.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -20),

            articleDetailVStack.topAnchor.constraint(greaterThanOrEqualTo: topView.topAnchor),
            articleDetailVStack.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 20),
            articleDetailVStack.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -20),
            articleDetailVStack.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -20),

            formContentStack.topAnchor.constraint(equalTo: topView.bottomAnchor),
            formContentStack.leadingAnchor.constraint(equalTo: contentStack.leadingAnchor, constant: 20),
            formContentStack.trailingAnchor.constraint(equalTo: contentStack.trailingAnchor, constant: -20),
            formContentStack.bottomAnchor.constraint(equalTo: contentStack.bottomAnchor),

            socialMediaHStack.topAnchor.constraint(equalTo: formContentStack.topAnchor, constant: 16),
            socialMediaHStack.leadingAnchor.constraint(equalTo: formContentStack.leadingAnchor),
            socialMediaHStack.widthAnchor.constraint(equalToConstant: 100),

            shareButton.widthAnchor.constraint(equalToConstant: socialMediaButtons),
            shareButton.heightAnchor.constraint(equalTo: shareButton.widthAnchor),

            articleDetail.topAnchor.constraint(equalTo: socialMediaHStack.bottomAnchor, constant: 20),
            articleDetail.leadingAnchor.constraint(equalTo: formContentStack.leadingAnchor),
            articleDetail.trailingAnchor.constraint(equalTo: formContentStack.trailingAnchor),
            articleDetail.bottomAnchor.constraint(equalTo: formContentStack.bottomAnchor),
        ])
    }
}
