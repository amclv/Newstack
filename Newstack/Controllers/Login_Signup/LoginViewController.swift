//
//  LoginViewController.swift
//  Newstack
//
//  Created by Aaron Cleveland on 7/25/20.
//

import UIKit
import Firebase

class LoginViewController: ShiftableViewController {
    
    let loginInfoVStack = CustomStackView(style: .loginVStack, distribution: .fill, alignment: .fill)
    let emailLabel = CustomLabel(style: .infoLabel, text: "Email Address")
    let passwordLabel = CustomLabel(style: .infoLabel, text: "Password")
    
    let emailTextField: UITextField = {
        let emailTextField = UITextField()
        emailTextField.textColor = UIColor.white
        emailTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return emailTextField
    }()
    
    let passwordTextField: UITextField = {
        let passwordTextField = UITextField()
        passwordTextField.textColor = UIColor.white
        passwordTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return passwordTextField
    }()
    
    let loginButton: UIButton = {
        let loginButton = UIButton()
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = .init(red: 51/255, green: 153/255, blue: 255/255, alpha: 1.0)
        loginButton.layer.cornerRadius = 15
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        loginButton.heightAnchor.constraint(equalToConstant: 46).isActive = true
        return loginButton
    }()
    
    let backgroundImage: UIImageView = {
        let bg = UIImageView()
        bg.translatesAutoresizingMaskIntoConstraints = false
        bg.image = UIImage(named: "oliver1")
        bg.contentMode = .scaleAspectFill
        return bg
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        subviews()
        constraints()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        loginInfoVStack.spacing = 16
    }
    
    override func viewWillLayoutSubviews() {
        emailTextField.setBottomBorder(withColor: .lightGray)
        passwordTextField.setBottomBorder(withColor: .lightGray)
    }
    
    @objc func loginButtonTapped() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            if let error = error {
                print("There was an error", error)
                Alert.showBasic(title: "Oops!", message: "Looks like either you didn't fill in the fields or you did them wrong you idiot or simply you just don't have an account", vc: self!)
            } else {
                let vc: TabbarViewController = TabbarViewController()
                vc.modalPresentationStyle = .fullScreen
                self!.present(vc, animated: true, completion: nil)
            }
        }
    }
}

extension LoginViewController {
    private func subviews() {
        loginInfoVStack.addArrangedSubview(emailLabel)
        loginInfoVStack.addArrangedSubview(emailTextField)
        loginInfoVStack.addArrangedSubview(passwordLabel)
        loginInfoVStack.addArrangedSubview(passwordTextField)
        loginInfoVStack.addArrangedSubview(loginButton)
        view.addSubview(backgroundImage)
        view.addSubview(loginInfoVStack)
    }
    
    private func constraints() {
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loginInfoVStack.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor),
            loginInfoVStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            loginInfoVStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            loginInfoVStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
    }
}
