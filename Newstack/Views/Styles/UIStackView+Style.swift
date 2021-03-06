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
        //ArticleDetailViewController
        case contentStack, articleDetailVStack, authorDetailHStack, authorHStack, topButtons, topRightButtons
        
        //EverythingCollectionViewCell
        case articleVStack
        
        //SearchViewController
        case searchHStack
        
        //OnboardingViewController
        case onboardContentVStack, onboardInfoVStack, onboardSignUpHStack, onboardSocialHStack
        
        //SignUpViewController
        case signUpVStack
        
        //LoginViewController
        case loginVStack
    }
    
    enum Distribution {
        case fill, equalSpacing, equalCentering, fillEqually, fillProportionally, `nil`
    }
    
    enum Alignment {
        case top, bottom, trailing, leading, lastBaseline, firstBaseline, fill, center, `nil`
    }
    
    let style: Style
    
    init(style: Style, distribution: UIStackView.Distribution, alignment: UIStackView.Alignment) {
        self.style = style
        super.init(frame: .zero)
        self.distribution = distribution
        self.alignment = alignment
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
        
        //ArticleDetailViewController
        case .contentStack:
            axis = .vertical
            spacing = 20
        case .articleDetailVStack:
            axis = .vertical
            spacing = 10
        case .authorDetailHStack:
            axis = .horizontal
            spacing = 0
        case .authorHStack:
            axis = .horizontal
        case .topButtons:
            axis = .horizontal
            spacing = 0
        case .topRightButtons:
            axis = .horizontal
            spacing = 10
            
        //EverythingCollectionViewCell
        case .articleVStack:
            axis = .vertical
            spacing = 8
            
        case .searchHStack:
            axis = .horizontal
            
        //OnboardingViewController
        case .onboardContentVStack:
            axis = .vertical
            spacing = 18
            
        case .onboardInfoVStack:
            axis = .vertical
            spacing = 16
            
        case .onboardSignUpHStack:
            axis = .horizontal
            spacing = 32
            
        case .onboardSocialHStack:
            axis = .horizontal
            spacing = 0
            
            //SignUpVStack
        case .signUpVStack:
            axis = .vertical
            spacing = 16
            
        case .loginVStack:
            axis = .vertical
            spacing = 16
        default:
            break
        }
    }
}
