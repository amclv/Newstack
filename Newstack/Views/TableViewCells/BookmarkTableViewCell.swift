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
    
    var article: Article? {
        didSet {
            updateViews()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureArticleImage()
        configureArticleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateViews() {
        guard let article = article,
            let urlToImage = article.urlToImage else { return }
        
        let imageURL = URL(string: urlToImage)!
        articleTitle.text = article.title
        articleImage.image = try? UIImage(withContentsOfUrl: imageURL)
    }
    
    func configureArticleLabel() {
        articleTitle.translatesAutoresizingMaskIntoConstraints = false
        articleTitle.numberOfLines = 0
        contentView.addSubview(articleTitle)
        articleTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        articleTitle.anchor(leading: articleImage.trailingAnchor,
                            trailing: contentView.trailingAnchor,
                            anchorLeading: 20,
                            anchorTrailing: -20)
    }
    
    func configureArticleImage() {
        articleImage.translatesAutoresizingMaskIntoConstraints = false
        articleImage.contentMode = .scaleAspectFill
        articleImage.layer.cornerRadius = 25
        articleImage.clipsToBounds = true
        contentView.addSubview(articleImage)
        articleImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        articleImage.setDimensions(width: 100, height: 100)
        articleImage.anchor(leading: leadingAnchor,
                            anchorLeading: 20)
    }

}

extension UIImage {

    convenience init?(withContentsOfUrl url: URL) throws {
        let imageData = try Data(contentsOf: url)
    
        self.init(data: imageData)
    }

}
