//
//  UILabel+Style.swift
//  Newstack
//
//  Created by Aaron Cleveland on 6/25/20.
//

import Foundation
import UIKit

class CustomLabel: UILabel {
    enum Style {
        // homeView
        case header, description, title, dates, author
        // articleDetailView
        case detailTitle, detailDate, detailAuthor, detailPaper, detailContent
        //collectionView
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
        fatalError("LABEL | init(coder:) has not been implemented")
    }

    private func setupStyling() {
        translatesAutoresizingMaskIntoConstraints = false
        numberOfLines = 0
        textColor = .label

        switch style {
        case .header:
            font = .systemFont(ofSize: 20, weight: .bold)
        case .title:
            font = .systemFont(ofSize: 14, weight: .semibold)
        case .description:
            font = .systemFont(ofSize: 16, weight: .light)
        case .dates:
            font = .systemFont(ofSize: 12, weight: .medium)
        case .author:
            font = .systemFont(ofSize: 16, weight: .regular)
            
            // article detail
        case .detailTitle:
            font = .systemFont(ofSize: 26, weight: .semibold)
        case .detailDate:
            font = .systemFont(ofSize: 12, weight: .medium)
        case .detailAuthor:
            font = .systemFont(ofSize: 16, weight: .regular)
        case .detailPaper:
            font = .systemFont(ofSize: 12, weight: .light)
        case .detailContent:
            font = .systemFont(ofSize: 16, weight: .light)
            
            // collectionView
        case .collectionTitle:
            font = .systemFont(ofSize: 14, weight: .semibold)
            textColor = .white
        case .collectionAuthor:
            font = .systemFont(ofSize: 12, weight: .light)
            textColor = .white
        default:
            break
        }
    }
}
