//
//  BookmarkCollectionViewCell.swift
//  Newstack
//
//  Created by Aaron Cleveland on 8/13/20.
//

import UIKit

class BookmarkCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String = "bookmarkCell"
    
    let articleImage = UIImageView()
    let articleTitle = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
//        configureArticleImage()
        configureArticleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureArticleLabel() {
        articleTitle.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(articleTitle)
        articleTitle.anchor(top: contentView.topAnchor,
                            bottom: contentView.bottomAnchor,
                            leading: contentView.leadingAnchor,
                            trailing: contentView.trailingAnchor)
    }
}
