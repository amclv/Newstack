//
//  UIStackView+Style.swift
//  Newstack
//
//  Created by Aaron Cleveland on 7/11/20.
//

import Foundation
import UIKit

class CustomStackView: UIStackView {
    enum Style {
        case horizontal, vertical
    }
    
    enum Distribution {
        case fill, equalSpacing, equalCentering, fillEqually, fillProportionally
    }
    
    enum Alignment {
        case top, bottom, trailing, leading, lastBaseline, firstBaseline, fill, center
    }
    
    let style: Style
    
    init(style: Style, distribution: Distribution, alignment: Alignment) {
        self.style = style
        super.init(frame: .zero)
        setupStyling()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStyling() {
        translatesAutoresizingMaskIntoConstraints = false
        
        switch style {
        case .horizontal:
            axis = .horizontal
        case .vertical:
            axis = .vertical
        default:
            break
        }
    }
}
