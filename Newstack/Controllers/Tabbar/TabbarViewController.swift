//
//  TabbarViewController.swift
//  Newstack
//
//  Created by Aaron Cleveland on 7/22/20.
//


//            let bookmark = BookmarkViewController()
//            bookmark.tabBarItem.image = UIImage(systemName: "bookmark")

import UIKit

class TabbarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.barTintColor = .systemBackground
        setupTabBar()
    }
    
    private func setupTabBar() {
        let home = UINavigationController(rootViewController: HomeViewController())
        home.tabBarItem.image = UIImage(systemName: "house")
        
        let search = SearchViewController()
        search.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        
        let settings = SettingsViewController()
        settings.tabBarItem.image = UIImage(systemName: "person.circle")
        
        viewControllers = [home, search, settings]
    }
}
