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
    var isUserLoggedIn = false
    
    let fullNameLabel = CustomLabel(style: .title, text: "Aaron Cleveland")
    
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
    
    let userInfoHStack = CustomStackView(style: .vertical, distribution: .fill, alignment: .fill)
    
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
    
    let bookmarkTableView: UITableView = {
        let bmTV = UITableView()
        bmTV.translatesAutoresizingMaskIntoConstraints = false
        
        return bmTV
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        bookmarkTableView.delegate = self
        bookmarkTableView.dataSource = self
        setupSubviews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        Auth.auth().addStateDidChangeListener { (auth, user) in
            self.isUserLoggedIn = true
            print(self.isUserLoggedIn)
        }
        
        
    }
    
    @objc func signOutTapped() {
        let vc: OnboardingViewController = OnboardingViewController()
        let firebaseAuth = Auth.auth()
        
        if let providerId = firebaseAuth.currentUser?.providerData.first?.providerID,
            providerId == "apple.com" {
            // Clear saved user ID
            UserDefaults.standard.set(nil, forKey: "appleAuthorizedUserIdKey")
            print("sign out of apple", providerId)
        }
        do {
            try firebaseAuth.signOut()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
            print(self.isUserLoggedIn)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

extension SettingsViewController {
    func setupSubviews() {
        userInfoHStack.addArrangedSubview(circleImageView)
        userInfoHStack.addArrangedSubview(fullNameLabel)
        
        view.addSubview(userInfoHStack)
        view.addSubview(signOutButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            userInfoHStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            userInfoHStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            userInfoHStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            signOutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            signOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            signOutButton.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
        ])
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = bookmarkTableView.dequeueReusableCell(withIdentifier: "bookmarkCell", for: indexPath) as! UITableViewCell
        return cell
    }
}
