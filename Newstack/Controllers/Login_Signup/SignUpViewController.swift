//
//  SignUpViewController.swift
//  Newstack
//
//  Created by Aaron Cleveland on 8/15/20.
//

import UIKit
import Firebase

class SignUpViewController: ShiftableViewController {
    
    let fullNameLabel = CustomLabel(style: .infoLabel, text: "Full Name")
    let emailLabel = CustomLabel(style: .infoLabel, text: "Email Address")
    let passwordLabel = CustomLabel(style: .infoLabel, text: "Password")
    
    let signUpVStack = CustomStackView(style: .vertical, distribution: .fill, alignment: .fill)
    
    // MARK: - TextField -
    let fullNameTextField: UITextField = {
        let fnTextField = UITextField()
        fnTextField.textColor = UIColor.white
        fnTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        fnTextField.translatesAutoresizingMaskIntoConstraints = false
        return fnTextField
    }()
    
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
    
    let signUpButton: UIButton = {
        let suButton = UIButton()
        suButton.translatesAutoresizingMaskIntoConstraints = false
        suButton.setTitle("Sign Up", for: .normal)
        suButton.backgroundColor = .init(red: 51/255, green: 153/255, blue: 255/255, alpha: 1.0)
        suButton.layer.cornerRadius = 22
        suButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        suButton.heightAnchor.constraint(equalToConstant: 46).isActive = true
        return suButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        emailTextField.delegate = self
        fullNameTextField.delegate = self
        passwordTextField.delegate = self
        subviews()
        constraints()
    }
    
    override func viewWillLayoutSubviews() {
        fullNameTextField.setBottomBorder(withColor: .lightGray)
        emailTextField.setBottomBorder(withColor: .lightGray)
        passwordTextField.setBottomBorder(withColor: .lightGray)
    }
    
    @objc func signUpButtonTapped() {
        if let name = fullNameTextField.text,
            !name.isEmpty,
            let email = emailTextField.text,
            !email.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty {
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if let error = error {
                    Alert.showBasic(title: "Error", message: error.localizedDescription, vc: self)
                } else {
                    let userData = [
                        "fullName": self.fullNameTextField.text! as String,
                        "email": self.emailTextField.text! as String
                    ]
//                    self.ref.child("users").child(user!.user.uid).setValue(userData)
                    print("Sign Up Successful!")
                    self.presentTabbarPage()
                }
            }
            self.presentTabbarPage()
        }
        self.presentTabbarPage()
//        Alert.showBasic(title: "Oops!", message: "You didn't fill out a required field", vc: self)
    }
    
    func presentTabbarPage() {
        let vc: TabbarViewController = TabbarViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}

extension SignUpViewController {
    private func subviews() {
        signUpVStack.addArrangedSubview(emailLabel)
        signUpVStack.addArrangedSubview(emailTextField)
        signUpVStack.addArrangedSubview(passwordLabel)
        signUpVStack.addArrangedSubview(passwordTextField)
        signUpVStack.addArrangedSubview(signUpButton)
//        view.addSubview(backgroundImage)
        view.addSubview(signUpVStack)
    }
    
    private func constraints() {
        NSLayoutConstraint.activate([
//            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
//            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            signUpVStack.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor),
            signUpVStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            signUpVStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            signUpVStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
    }
}
