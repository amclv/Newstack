//
//  OnboardingViewController.swift
//  Newstack
//
//  Created by Aaron Cleveland on 7/21/20.
//

import UIKit
import Firebase

class OnboardingViewController: ShiftableViewController {
    
    let backgroundImage: UIImageView = {
        let bg = UIImageView()
        bg.translatesAutoresizingMaskIntoConstraints = false
        bg.image = UIImage(named: "oliver3")
        bg.contentMode = .scaleAspectFill
        return bg
    }()
    
    let contentVStack = CustomStackView(style: .onboardContentVStack, distribution: .fill, alignment: .fill)
    
    let helloLabel = CustomLabel(style: .helloLabel, text: "Hello!")
    let subLabel = CustomLabel(style: .subLabel, text: "Daily UI is a series of daily design challenges design inspiration.")
    
    let socialHStack: UIStackView = {
        let sHStack = UIStackView()
        sHStack.translatesAutoresizingMaskIntoConstraints = false
        sHStack.axis = .horizontal
        sHStack.distribution = .fill
        sHStack.alignment = .fill
        return sHStack
    }()
    
    let appleButtonLogin: UIButton = {
        let appleButton = UIButton()
        
        return appleButton
    }()
    
    let facebookButton: UIButton = {
        let fb = UIButton()
        let fbImage = UIImage(named: "facebook")?.scaled(to: 50)
        fb.setImage(fbImage, for: .normal)
        return fb
    }()
    
    let twitterButton: UIButton = {
        let tb = UIButton()
        let tbImage = UIImage(named: "twitter")?.scaled(to: 50)
        tb.setImage(tbImage, for: .normal)
        return tb
    }()
    
    let googleButton: UIButton = {
        let gb = UIButton()
        let gbImage = UIImage(named: "google")?.scaled(to: 50)
        gb.setImage(gbImage, for: .normal)
        return gb
    }()
    
    let infoVStack = CustomStackView(style: .onboardInfoVStack, distribution: .fill, alignment: .fill)
    
    let fullNameLabel = CustomLabel(style: .fullNameLabel, text: "Full Name")
    
    let fullNameTextField: UITextField = {
        let fnTextField = UITextField()
        fnTextField.textColor = UIColor.white
        return fnTextField
    }()
    
    let emailLabel = CustomLabel(style: .emailLabel, text: "Email Address")
    
    let emailTextField: UITextField = {
        let emailTextField = UITextField()
        emailTextField.textColor = UIColor.white
        return emailTextField
    }()
    
    let passwordLabel = CustomLabel(style: .emailLabel, text: "Password")
    
    let passwordTextField: UITextField = {
        let passwordTextField = UITextField()
        passwordTextField.textColor = UIColor.white
        return passwordTextField
    }()
    
    let signUpHStack = CustomStackView(style: .onboardSignUpHStack, distribution: .fill, alignment: .fill)
    
    let signUpButton: UIButton = {
        let suButton = UIButton()
        suButton.translatesAutoresizingMaskIntoConstraints = false
        suButton.setTitle("Sign Up", for: .normal)
        suButton.backgroundColor = UIColor.systemOrange
        suButton.layer.cornerRadius = 15
        suButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        return suButton
    }()
    
    let termsPrivacyLabel = CustomLabel(style: .termsPrivacyLabel, text: "By clicking Sign Up, you agree to our Terms and Privacy")
    
    let loginButton: UIButton = {
        let loginButton = UIButton()
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Login", for: .normal)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return loginButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        subviews()
        constraints()
        emailTextField.delegate = self
        fullNameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @objc func signUpButtonTapped() {
        if let name = fullNameTextField.text,
            !name.isEmpty,
            let email = emailTextField.text,
            !email.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty {
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                let vc: OnboardingViewController = OnboardingViewController()
                if error == nil {
                    self.present(vc, animated: true, completion: nil)
                } else {
                    Alert.showBasic(title: "Error", message: error!.localizedDescription, vc: self)
                }
            }
            let vc: TabbarViewController = TabbarViewController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
        Alert.showBasic(title: "Oops!", message: "You didn't fill out a required field", vc: self)
    }
    
    @objc func loginButtonTapped() {
        let vc: TabbarViewController = TabbarViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}

extension OnboardingViewController {
    private func subviews() {
        contentVStack.addArrangedSubview(helloLabel)
        contentVStack.addArrangedSubview(subLabel)
        
        contentVStack.addArrangedSubview(socialHStack)
        socialHStack.addArrangedSubview(appleButtonLogin)
        
        contentVStack.addArrangedSubview(infoVStack)
        infoVStack.addArrangedSubview(fullNameLabel)
        infoVStack.addArrangedSubview(fullNameTextField)
        infoVStack.addArrangedSubview(emailLabel)
        infoVStack.addArrangedSubview(emailTextField)
        infoVStack.addArrangedSubview(passwordLabel)
        infoVStack.addArrangedSubview(passwordTextField)
        
        contentVStack.addArrangedSubview(signUpHStack)
        signUpHStack.addArrangedSubview(signUpButton)
        
        contentVStack.addArrangedSubview(loginButton)
        
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
