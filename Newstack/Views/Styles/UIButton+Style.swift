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
        case socialMedia, primaryButton, backButton, bookmarkButton
        case navButtons
        
        // OnboardingViewController
        case facebookButton, twitterButton, googleButton, signUpButton, appleButton
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
        
        switch style {
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
