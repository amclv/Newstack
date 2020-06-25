//
//  UIButton+Style.swift
//  Newstack
//
//  Created by Aaron Cleveland on 6/25/20.
//

import Foundation
import UIKit

class CustomButton: UIButton {
    enum Style {
        case socialMedia, primaryButton, backButton, bookButton
        case navButtons
    }

    let style: Style

    init(style: Style) {
        self.style = style
        super.init(frame: .zero)
        setupStyling()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupStyling() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor(red: 233, green: 233, blue: 233)
        
        switch style {
        case .primaryButton:
            titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
            setTitleColor(.black, for: .normal)
            layer.cornerRadius = 12
        case .socialMedia:
            tintColor = .black
            layer.cornerRadius = 15
        case .backButton:
            backgroundColor = .clear
        case .bookButton:
            backgroundColor = .clear
        case .navButtons:
            setTitleColor(.black, for: .normal)
            setTitleColor(.gray, for: .highlighted)
            titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            frame = CGRect(x: 0, y: 0, width: 100, height: 25)
            layer.cornerRadius = 12
        default:
            break;
        }
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255

        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}
