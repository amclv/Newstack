//
//  OnboardingViewController.swift
//  Newstack
//
//  Created by Aaron Cleveland on 7/21/20.
//

import UIKit
import AuthenticationServices
import Firebase
import CryptoKit

class OnboardingViewController: ShiftableViewController {
    
    fileprivate var currentNonce: String?
    var ref: DatabaseReference!
    
    let helloLabel = CustomLabel(style: .helloLabel, text: "Hello!")
    let subLabel = CustomLabel(style: .subLabel, text: "Even on a boat you can catch all your news from any source.")
    let fullNameLabel = CustomLabel(style: .infoLabel, text: "Full Name")
    let emailLabel = CustomLabel(style: .infoLabel, text: "Email Address")
    let passwordLabel = CustomLabel(style: .infoLabel, text: "Password")
    
    // MARK: - StackViews -
    let contentVStack = CustomStackView(style: .onboardContentVStack, distribution: .fill, alignment: .fill)
    let infoVStack = CustomStackView(style: .onboardInfoVStack, distribution: .fill, alignment: .fill)
    let signUpHStack = CustomStackView(style: .onboardSignUpHStack, distribution: .fill, alignment: .fill)
    
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
    
    // MARK: - Buttons -
    let appleButtonLogin: ASAuthorizationAppleIDButton = {
        let appleButton = ASAuthorizationAppleIDButton()
        appleButton.addTarget(self, action: #selector(appleButtonTapped), for: .touchUpInside)
        appleButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        appleButton.cornerRadius = 20
        return appleButton
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
    
    let loginButton: UIButton = {
        let loginButton = UIButton()
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Login", for: .normal)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        loginButton.heightAnchor.constraint(equalToConstant: 46).isActive = true
        return loginButton
    }()
    
    let backgroundImage: UIImageView = {
        let bg = UIImageView()
        bg.translatesAutoresizingMaskIntoConstraints = false
        bg.image = UIImage(named: "oliver3")
        bg.contentMode = .scaleAspectFill
        return bg
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        ref = Database.database().reference()
        subviews()
        constraints()
        emailTextField.delegate = self
        fullNameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewWillLayoutSubviews() {
        fullNameTextField.setBottomBorder(withColor: .lightGray)
        emailTextField.setBottomBorder(withColor: .lightGray)
        passwordTextField.setBottomBorder(withColor: .lightGray)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    func presentTabbarPage() {
        let vc: TabbarViewController = TabbarViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
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
                    self.ref.child("users").child(user!.user.uid).setValue(userData)
                    print("Sign Up Successful!")
                    self.presentTabbarPage()
                }
            }
            self.presentTabbarPage()
        }
        Alert.showBasic(title: "Oops!", message: "You didn't fill out a required field", vc: self)
    }
    
    @available(iOS 13, *)
    @objc func appleButtonTapped() {
        let nonce = randomNonceString()
        currentNonce = nonce
        
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        return hashString
    }
    
    @objc func loginButtonTapped() {
        let vc: LoginViewController = LoginViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
}

extension OnboardingViewController {
    private func subviews() {
        contentVStack.addArrangedSubview(helloLabel)
        contentVStack.addArrangedSubview(subLabel)
        
        
        contentVStack.addArrangedSubview(infoVStack)
        infoVStack.addArrangedSubview(fullNameLabel)
        infoVStack.addArrangedSubview(fullNameTextField)
        infoVStack.addArrangedSubview(emailLabel)
        infoVStack.addArrangedSubview(emailTextField)
        infoVStack.addArrangedSubview(passwordLabel)
        infoVStack.addArrangedSubview(passwordTextField)
        
        contentVStack.addArrangedSubview(signUpHStack)
        contentVStack.addArrangedSubview(signUpButton)
        contentVStack.addArrangedSubview(appleButtonLogin)
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

extension OnboardingViewController: ASAuthorizationControllerDelegate {
    // ASAuthorizationControllerDelegate function for authorization failed
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Error appleid \(error.localizedDescription)")
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid State: A login callback was received, but no longer request was sent.")
            }
            
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            //init a firebase credential
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            
            // sign in with firebase
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if error != nil {
                    print("Error signing in with apple id: \(error!.localizedDescription)")
                    return
                }
                let vc: TabbarViewController = TabbarViewController()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}

extension OnboardingViewController: ASAuthorizationControllerPresentationContextProviding {
    // for present window
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}
