//
//  TestUIStyle.swift
//  Newstack
//
//  Created by Aaron Cleveland on 6/28/20.
//

import Foundation
import UIKit

class TestUIStyle: UILabel {
    enum Style {
        /*
         I usually determine my cases based off the needs of the project.
         Let's try to get some of the details in order.
         */
        
        // HomeView
        case header, description, title, dates, author
        // ArticleDetailView
        case detailTitle, detailDate, detailAuthor, detailPaper, detailContent
        // CollectionView
        case collectionTitle, collectionAuthor
    }
    
    let style: Style
    init(style: Style, text: String) {
        self.style = style
        super.init(frame: .zero)
        self.text = text
        setupStyling()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStyling() {
        translatesAutoresizingMaskIntoConstraints = false
        numberOfLines = 0
        
        switch style {
        case .header:
            font = .systemFont(ofSize: 20, weight: .bold)
            textColor = .label
        case .title:
            font = .systemFont(ofSize: 14, weight: .light)
            textColor = .white
        default:
            font = .systemFont(ofSize: 12, weight: .regular)
            textColor = .yellow
        }
    }
}
