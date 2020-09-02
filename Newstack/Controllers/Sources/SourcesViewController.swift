//
//  SourcesViewController.swift
//  Newstack
//
//  Created by Aaron Cleveland on 9/1/20.
//

import UIKit

class SourcesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationController()
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
    }
    
    func configureNavigationController() {
        self.navigationItem.title = "Sources"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
}
