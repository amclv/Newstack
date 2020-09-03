//
//  SourcesViewController.swift
//  Newstack
//
//  Created by Aaron Cleveland on 9/1/20.
//

import UIKit

class SourcesViewController: UIViewController {
    
    // MARK: - Properties
    private let networkManager = NetworkingManager()
    let tableView = UITableView()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureTableView()
        configureNavigationController()
        networkManager.fetchSources {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Helpers
    func configureTableView() {
        view.addSubview(tableView)
        setTableViewDelegates()
        tableView.rowHeight = 50
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.addConstraintsToFillView(view)
    }
    
    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func configureNavigationController() {
        self.navigationItem.title = "Sources"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

// MARK: - UITableViewDelegate / UITableViewDataSource
extension SourcesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return networkManager.sourcesFeed.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = networkManager.sourcesFeed[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(networkManager.sourcesFeed[indexPath.row].name)
    }
}
