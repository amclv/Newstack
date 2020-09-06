//
//  BookmarkTableViewCell.swift
//  Newstack
//
//  Created by Aaron Cleveland on 9/6/20.
//

import UIKit

class BookmarkTableViewCell: UITableViewCell {
    
    static var identifier: String = "bookmarkCell"

    let articleTitle = UILabel()
    let articleImage = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureArticleLabel() {
        articleTitle.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(articleTitle)
        articleTitle.addConstraintsToFillView(contentView)
    }

}
