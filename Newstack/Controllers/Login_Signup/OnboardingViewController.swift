//
//  OnboardingViewController.swift
//  Newstack
//
//  Created by Aaron Cleveland on 7/21/20.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    let backgroundImage: UIImageView = {
        let bg = UIImageView()
        bg.translatesAutoresizingMaskIntoConstraints = false
        bg.image = UIImage(named: "oliver3")
        bg.contentMode = .scaleAspectFill
        return bg
    }()
    
    let contentVStack = CustomStackView(style: .onboardContentVStack, distribution: .fillEqually, alignment: .fill)
    
    let helloLabel = CustomLabel(style: .helloLabel, text: "Hello!")
    let subLabel = CustomLabel(style: .subLabel, text: "Daily UI is a series of daily design challenges design inspiration.")
    
    let socialHStack = CustomStackView(style: .horizontal, distribution: .fill, alignment: .leading)
    
    let facebookButton: UIButton = {
        let fb = UIButton()
        let fbImage = UIImage(named: "facebook")?.scaled(to: 50)
        fb.translatesAutoresizingMaskIntoConstraints = false
        fb.setImage(fbImage, for: .normal)
        return fb
    }()
    
    let twitterButton: UIButton = {
        let tb = UIButton()
        let tbImage = UIImage(named: "twitter")?.scaled(to: 50)
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.setImage(tbImage, for: .normal)
        return tb
    }()
    
    let googleButton: UIButton = {
        let gb = UIButton()
        let gbImage = UIImage(named: "google")?.scaled(to: 50)
        gb.translatesAutoresizingMaskIntoConstraints = false
        gb.setImage(gbImage, for: .normal)
        return gb
    }()
    
    let infoVStack = CustomStackView(style: .onboardInfoVStack, distribution: .fill, alignment: .fill)
    
    let fullNameLabel = CustomLabel(style: .fullNameLabel, text: "Full Name")
    
    let fullNameTextField: UITextField = {
        let fnTextField = UITextField()
        fnTextField.translatesAutoresizingMaskIntoConstraints = false
        return fnTextField
    }()
    
    let emailLabel = CustomLabel(style: .emailLabel, text: "Email Address")
    
    let emailTextField: UITextField = {
        let emailTextField = UITextField()
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        return emailTextField
    }()
    
    let signUpHStack = CustomStackView(style: .horizontal, distribution: .fill, alignment: .fill)
    
    let signUpButton: UIButton = {
        let suButton = UIButton()
        suButton.translatesAutoresizingMaskIntoConstraints = false
        suButton.setTitle("Sign Up", for: .normal)
        suButton.backgroundColor = UIColor.systemOrange
        suButton.layer.cornerRadius = 15
        return suButton
    }()
    
    let termsPrivacyLabel = CustomLabel(style: .termsPrivacyLabel, text: "By clicking Sign Up, you agree to our Terms and Privacy")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        subviews()
        constraints()
        emailTextField.delegate = self
        fullNameTextField.delegate = self
    }
}

extension OnboardingViewController {
    private func subviews() {
        contentVStack.addArrangedSubview(helloLabel)
        contentVStack.addArrangedSubview(subLabel)
        
        contentVStack.addArrangedSubview(socialHStack)
        socialHStack.addArrangedSubview(facebookButton)
        socialHStack.addArrangedSubview(twitterButton)
        socialHStack.addArrangedSubview(googleButton)
        
        contentVStack.addArrangedSubview(infoVStack)
        infoVStack.addArrangedSubview(fullNameLabel)
        infoVStack.addArrangedSubview(fullNameTextField)
        infoVStack.addArrangedSubview(emailLabel)
        infoVStack.addArrangedSubview(emailTextField)
        
        contentVStack.addArrangedSubview(signUpHStack)
        signUpHStack.addArrangedSubview(signUpButton)
        signUpHStack.addArrangedSubview(termsPrivacyLabel)
        
        view.addSubview(backgroundImage)
        view.addSubview(contentVStack)
    }
    
    private func constraints() {
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentVStack.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor),
            contentVStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            contentVStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            contentVStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ])
    }
}

extension OnboardingViewController: UITextFieldDelegate {
    
}
