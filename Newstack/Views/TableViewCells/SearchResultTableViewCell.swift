//
//  SearchResultTableViewCell.swift
//  Newstack
//
//  Created by Aaron Cleveland on 7/15/20.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    
    static var identifier: String = "searchResultCell"
    
    let articleTitle = CustomLabel(style: .title, text: "")
    
    let articleImage: UIImageView = {
        let articleImage = UIImageView()
        articleImage.translatesAutoresizingMaskIntoConstraints = false
        articleImage.contentMode = .scaleAspectFill
        articleImage.layer.cornerRadius = 25
        articleImage.clipsToBounds = true
        return articleImage
    }()

    var results: NewsSource.Article? {
        didSet {
            updateViews()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateViews() {
        guard let result = results else { return }
        articleTitle.text = result.title
    }
    
    private func setupSubviews() {
        contentView.addSubview(articleImage)
        contentView.addSubview(articleTitle)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            articleImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            articleImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            articleImage.widthAnchor.constraint(equalToConstant: 100),
            articleImage.heightAnchor.constraint(equalTo: articleImage.widthAnchor),
            
            articleTitle.leadingAnchor.constraint(equalTo: articleImage.trailingAnchor, constant: 8),
            articleTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            articleTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            contentView.heightAnchor.constraint(equalToConstant: 125),
        ])
    }
}
