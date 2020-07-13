//
//  EverythingCollectionViewCell.swift
//  Newstack
//
//  Created by Aaron Cleveland on 7/11/20.
//

import UIKit

class EverythingCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String = "everythingCell"
    
    var everythingArticle: NewsSource.Article? {
        didSet {
            updateViews()
        }
    }
    
    let articleTitleLabel = CustomLabel(style: .title, text: "")
    let articleDateLabel = CustomLabel(style: .dates, text: "")
    
    let cellBackground: UIView = {
        let cbg = UIView()
        cbg.translatesAutoresizingMaskIntoConstraints = false
        cbg.backgroundColor = UIColor(named: "Charcoal")
        cbg.layer.cornerRadius = 15
        return cbg
    }()
    
    let articleImage: UIImageView = {
        let articleImage = UIImageView()
        articleImage.translatesAutoresizingMaskIntoConstraints = false
        articleImage.contentMode = .scaleAspectFill
        articleImage.layer.cornerRadius = 15
        articleImage.clipsToBounds = true
        return articleImage
    }()
    
    let articleVStack = CustomStackView(style: .vertical, distribution: .fill, alignment: .fill)
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupCellSubviews()
        setupCellConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateViews() {
        self.articleTitleLabel.text = everythingArticle?.title
        self.articleDateLabel.text = everythingArticle?.formattedDate
    }
    
    private func setupCellSubviews() {
        articleVStack.addArrangedSubview(articleTitleLabel)
        articleVStack.addArrangedSubview(articleDateLabel)
        
        cellBackground.addSubview(articleImage)
        cellBackground.addSubview(articleVStack)
        contentView.addSubview(cellBackground)
    }
    
    private func setupCellConstraints() {
        NSLayoutConstraint.activate([
            cellBackground.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellBackground.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellBackground.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cellBackground.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellBackground.heightAnchor.constraint(equalToConstant: 100),
            
            articleImage.topAnchor.constraint(equalTo: cellBackground.topAnchor, constant: 8),
            articleImage.leadingAnchor.constraint(equalTo: cellBackground.leadingAnchor, constant: 8),
            articleImage.bottomAnchor.constraint(equalTo: cellBackground.bottomAnchor, constant: -8),
            articleImage.trailingAnchor.constraint(equalTo: articleVStack.leadingAnchor, constant: -8),
            articleImage.widthAnchor.constraint(equalToConstant: 200),
            articleImage.heightAnchor.constraint(equalTo: articleImage.widthAnchor),
            
            articleVStack.topAnchor.constraint(equalTo: cellBackground.topAnchor, constant: 8),
            articleVStack.leadingAnchor.constraint(equalTo: cellBackground.leadingAnchor, constant: 8),
            articleVStack.bottomAnchor.constraint(equalTo: cellBackground.bottomAnchor, constant: -8),
        ])
    }
}
