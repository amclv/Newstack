//
//  EverythingCollectionViewCell.swift
//  Newstack
//
//  Created by Aaron Cleveland on 7/11/20.
//

import UIKit

class EverythingCollectionViewCell: UICollectionViewCell {
    static var identifier: String = "everythingCell"
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupCellSubviews()
        setupCellConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCellSubviews() {
        
    }
    
    private func setupCellConstraints() {
        
    }
}
