//
//  SettingsViewController.swift
//  Newstack
//
//  Created by Aaron Cleveland on 6/25/20.
//

import UIKit

class SettingsViewController: UIViewController {
    
    let signOutButton: UIButton = {
        let signOut = UIButton()
        signOut.translatesAutoresizingMaskIntoConstraints = false
        signOut.setTitle("Sign Out", for: .normal)
        signOut.tintColor = .black
        signOut.addTarget(self, action: #selector(signOutTapped), for: .touchUpInside)
        return signOut
    }()
    
    let blueView: CurvedView = {
        let bView = CurvedView()
        bView.translatesAutoresizingMaskIntoConstraints = false
        bView.backgroundColor = .white
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviews()
        setupConstraints()
    }
    
    @objc func signOutTapped() {
        let vc: OnboardingViewController = OnboardingViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    
}

extension SettingsViewController {
    func setupSubviews() {
        blueView.addSubview(circleImageView)
        view.addSubview(blueView)
        view.addSubview(signOutButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            blueView.topAnchor.constraint(equalTo: view.topAnchor, constant: 250),
            blueView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blueView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blueView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            signOutButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            signOutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        circleImageView.center.x = view.center.x
        circleImageView.center.y = blueView.layoutMargins.top + 20
    }
}

class CurvedView: UIView {
    override func draw(_ rect: CGRect) {
        let y:CGFloat = 40
        let curveTo:CGFloat = 0
        let myBezier = UIBezierPath()
        myBezier.move(to: CGPoint(x: 0, y: y))
        myBezier.addQuadCurve(to: CGPoint(x: rect.width, y: y), controlPoint: CGPoint(x: rect.width / 2, y: curveTo))
        myBezier.addLine(to: CGPoint(x: rect.width, y: rect.height))
        myBezier.addLine(to: CGPoint(x: 0, y: rect.height))
        myBezier.close()
        let context = UIGraphicsGetCurrentContext()!
        context.setLineWidth(4.0)
        UIColor.systemBlue.setFill()
        myBezier.fill()
    }
}
