//
//  BookmarkViewController.swift
//  Newstack
//
//  Created by Aaron Cleveland on 6/25/20.
//

import UIKit

class BookmarkViewController: UIViewController {
    
    let bookmarkTableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    func setupTableView() {
        bookmarkTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bookmarkTableView)
        NSLayoutConstraint.activate([
            bookmarkTableView.topAnchor.constraint(equalTo: view.topAnchor),
            bookmarkTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bookmarkTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bookmarkTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
