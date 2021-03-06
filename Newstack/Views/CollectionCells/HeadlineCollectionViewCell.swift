//
//  HeadlineCollectionViewCell.swift
//  Newstack
//
//  Created by Aaron Cleveland on 6/25/20.
//

import UIKit

class HeadlineCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String = "headlineCell"
    
    var headlineArticle: ArticleRepresentation? {
        didSet {
            updateViews()
        }
    }
    
    var gradient = CAGradientLayer()
    
    let headlineTitle = CustomLabel(style: .collectionTitle, text: "")
    let headlineAuthor = CustomLabel(style: .collectionAuthor, text: "")
    
    let headlineImage: UIImageView = {
        let hImage = UIImageView()
        hImage.translatesAutoresizingMaskIntoConstraints = false
        hImage.contentMode = .scaleAspectFill
        hImage.layer.cornerRadius = 25
        hImage.clipsToBounds = true
        return hImage
    }()
    
    let headlineVStack: UIStackView = {
        let headlineVStack = UIStackView()
        headlineVStack.translatesAutoresizingMaskIntoConstraints = false
        headlineVStack.axis = .vertical
        headlineVStack.spacing = 8
        return headlineVStack
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupCellSubviews()
        setupCellConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addGradient()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addGradient() {
        gradient.frame = headlineImage.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        headlineImage.layer.insertSublayer(gradient, at: 0)
    }
    
    func updateViews() {
        self.headlineTitle.text = headlineArticle?.title ?? "No Title"
        self.headlineAuthor.text = headlineArticle?.source.name ?? "No Source Name"
    }
}

extension HeadlineCollectionViewCell {
    private func setupCellSubviews() {
        headlineVStack.addArrangedSubview(headlineTitle)
        headlineVStack.addArrangedSubview(headlineAuthor)
        contentView.addSubview(headlineImage)
        contentView.addSubview(headlineVStack)
    }

    private func setupCellConstraints() {
        NSLayoutConstraint.activate([
            headlineImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            headlineImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headlineImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            headlineImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            headlineVStack.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor),
            headlineVStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            headlineVStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            headlineVStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -20),
        ])
    }
}
