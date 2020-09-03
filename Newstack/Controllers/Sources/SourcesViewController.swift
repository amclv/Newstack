//
//  SourcesViewController.swift
//  Newstack
//
//  Created by Aaron Cleveland on 9/1/20.
//

import UIKit

class SourcesViewController: UIViewController {
    
    private let networkManager = NetworkingManager()
    
    let sourcesTableView: UITableView = {
        let sourcesTV = UITableView()
        sourcesTV.translatesAutoresizingMaskIntoConstraints = false
        sourcesTV.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return sourcesTV
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationController()
        sourcesTableView.delegate = self
        sourcesTableView.dataSource = self
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(sourcesTableView)
        sourcesTableView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                leading: view.leadingAnchor,
                                trailing: view.trailingAnchor,
                                anchorLeading: 20,
                                anchorTrailing: -20)
    }
    
    func configureNavigationController() {
        self.navigationItem.title = "Sources"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension SourcesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return networkManager.sourcesFeed.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = networkManager.sourcesFeed[indexPath.row].name
        return cell
    }
    
    
}
