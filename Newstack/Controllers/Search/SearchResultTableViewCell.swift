//
//  SearchResultTableViewCell.swift
//  Newstack
//
//  Created by Aaron Cleveland on 7/15/20.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    
    let articleTitle = CustomLabel(style: .title, text: "")

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
        contentView.addSubview(articleTitle)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            articleTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            articleTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            articleTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
    }
}
