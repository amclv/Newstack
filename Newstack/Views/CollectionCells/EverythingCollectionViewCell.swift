//
//  EverythingCollectionCell.swift
//  Newstack
//
//  Created by Aaron Cleveland on 6/25/20.
//

import Foundation
import UIKit

class EverythingCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String = "everythingCell"
    
    var everyArticle: [NewsSource.ArticleRepresentation] = []
    var gradient = CAGradientLayer()

    let articleImage: UIImageView = {
        let articleImage = UIImageView()
        articleImage.translatesAutoresizingMaskIntoConstraints = false
        articleImage.contentMode = .scaleAspectFill
        articleImage.layer.cornerRadius = 15
        articleImage.clipsToBounds = true
        return articleImage
    }()

    let articleTitle: UILabel = {
        let articleTitle = UILabel()
        articleTitle.translatesAutoresizingMaskIntoConstraints = false
        articleTitle.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        articleTitle.textColor = .white
        articleTitle.numberOfLines = 0
        return articleTitle
    }()
    
    let articleDate: UILabel = {
        let articleDate = UILabel()
        articleDate.translatesAutoresizingMaskIntoConstraints = false
        articleDate.font = UIFont.systemFont(ofSize: 12, weight: .light)
        articleDate.textColor = .white
        return articleDate
    }()
    
    let everyArticleVStack: UIStackView = {
        let everyArticleVStack = UIStackView()
        everyArticleVStack.translatesAutoresizingMaskIntoConstraints = false
        everyArticleVStack.axis = .vertical
        everyArticleVStack.spacing = 8
        return everyArticleVStack
    }()


    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupSubviews()
        setupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addGradient()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addGradient() {
        gradient.frame = articleImage.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        articleImage.layer.insertSublayer(gradient, at: 0)
    }
}

extension EverythingCollectionViewCell {
    func setupSubviews() {
        everyArticleVStack.addArrangedSubview(articleTitle)
        everyArticleVStack.addArrangedSubview(articleDate)
        contentView.addSubview(articleImage)
        contentView.addSubview(everyArticleVStack)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            articleImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            articleImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            articleImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            articleImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            everyArticleVStack.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor),
            everyArticleVStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            everyArticleVStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            everyArticleVStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -20),
        ])
    }
}
