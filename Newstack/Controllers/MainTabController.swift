//
//  MainTabController.swift
//  Newstack
//
//  Created by Aaron Cleveland on 9/1/20.
//

import UIKit

class MainTabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
    }
    
    private func configureViewControllers() {
        let overview = HomeViewController()
        let sources = SourcesViewController()
        let search = SearchViewController()
        let favorite = BookmarkViewController()
        let webView = EverythingViewController()
    
        let nav1 = templateNavigationController(image: UIImage(systemName: "house"), rootViewController: overview)
        let nav2 = templateNavigationController(image: UIImage(systemName: "list.bullet"), rootViewController: sources)
        let nav3 = templateNavigationController(image: UIImage(systemName: "magnifyingglass"), rootViewController: search)
        let nav4 = templateNavigationController(image: UIImage(systemName: "heart"), rootViewController: favorite)
        let nav5 = templateNavigationController(image: UIImage(systemName: "person"), rootViewController: webView)
        
        viewControllers = [nav1, nav2, nav3, nav4, nav5]
    }
    
    private func templateNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .white
        return nav
    }
}
