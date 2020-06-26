//
//  SettingsViewController.swift
//  Newstack
//
//  Created by Aaron Cleveland on 6/25/20.
//

import UIKit

class SettingsViewController: UIViewController {
    
    let blueView: CurvedView = {
        let bView = CurvedView()
        bView.translatesAutoresizingMaskIntoConstraints = false
        bView.backgroundColor = .white
        return bView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        view.addSubview(blueView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            blueView.topAnchor.constraint(equalTo: view.topAnchor, constant: 250),
            blueView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blueView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blueView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
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
