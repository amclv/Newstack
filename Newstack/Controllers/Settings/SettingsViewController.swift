//
//  SettingsViewController.swift
//  Newstack
//
//  Created by Aaron Cleveland on 6/25/20.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {
    
    var user: User?
    
    let signOutButton: UIButton = {
        let signOut = UIButton()
        signOut.translatesAutoresizingMaskIntoConstraints = false
        signOut.setTitle("Sign Out", for: .normal)
        signOut.setTitleColor(.black, for: .normal)
        signOut.backgroundColor = .init(red: 51/255, green: 153/255, blue: 255/255, alpha: 1.0)
        signOut.layer.cornerRadius = 15
        signOut.addTarget(self, action: #selector(signOutTapped), for: .touchUpInside)
        return signOut
    }()
    
    let blueView: UIView = {
        let bView = UIView()
        bView.translatesAutoresizingMaskIntoConstraints = false
        bView.backgroundColor = .init(red: 51/255, green: 153/255, blue: 255/255, alpha: 1.0)
        return bView
    }()
    
    lazy var circleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemRed
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1
        imageView.frame = CGRect(x: 0, y: 0, width: view.bounds.width / 3, height: 0)
        imageView.frame.size.height = imageView.frame.width
        imageView.layer.cornerRadius = (imageView.frame.size.height)/2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let fullNameLabel: UILabel = {
        let fnLabel = UILabel()
        fnLabel.translatesAutoresizingMaskIntoConstraints = false
        fnLabel.textColor = .black
        return fnLabel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getUserProfile()
    }
    
    func getUserProfile() {
        if let user = Auth.auth().currentUser {
            // getting users properties:
            let uid = user.uid
            let email = user.email
            
            // getting custom properties created if you need them:
            print("user", uid, email!)
        }
    }
    
    @objc func signOutTapped() {
        let vc: OnboardingViewController = OnboardingViewController()
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
            print("Signed out of apple id")
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

extension SettingsViewController {
    func setupSubviews() {
        blueView.addSubview(circleImageView)
        view.addSubview(fullNameLabel)
        view.addSubview(blueView)
        view.addSubview(signOutButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            blueView.topAnchor.constraint(equalTo: view.topAnchor, constant: 250),
            blueView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blueView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blueView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            signOutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            signOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            signOutButton.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            
            fullNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            fullNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
        ])
        
        circleImageView.center.x = view.center.x
        circleImageView.center.y = blueView.layoutMargins.top
    }
}
