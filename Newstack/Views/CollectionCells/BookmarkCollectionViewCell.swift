//
//  BookmarkCollectionViewCell.swift
//  Newstack
//
//  Created by Aaron Cleveland on 8/13/20.
//

import UIKit

class BookmarkCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String = "bookmarkCell"
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupCellSubviews()
        setupCellConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BookmarkCollectionViewCell {
    private func setupCellSubviews() {
        
    }
    
    private func setupCellConstraints() {
        
    }
}
