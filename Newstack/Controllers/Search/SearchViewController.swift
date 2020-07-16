//
//  SearchViewController.swift
//  Newstack
//
//  Created by Aaron Cleveland on 7/11/20.
//

import UIKit

class SearchViewController: UIViewController {
    
    let networkManager = NetworkingManager()
    
    let searchHStack = CustomStackView(style: .searchHStack, distribution: .equalSpacing, alignment: .fill)
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.barStyle = .default
        return sb
    }()
    
    let sortButton: UIButton = {
        let sort = UIButton()
        sort.translatesAutoresizingMaskIntoConstraints = false
        sort.setImage(UIImage(systemName: "arrow.up.arrow.down"), for: .normal)
        sort.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        return sort
    }()
    
    let tableView: UITableView = {
        let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.register(SearchResultTableViewCell.self, forCellReuseIdentifier: "cell")
        return tb
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        setupSubviews()
        setupConstraints()
    }
    
    @objc func sortButtonTapped() {
        print("SORT BUTTON TAPPED!")
    }
}

extension SearchViewController {
    private func setupSubviews() {
        searchHStack.addArrangedSubview(searchBar)
        searchHStack.addArrangedSubview(sortButton)
        
        view.addSubview(tableView)
        view.addSubview(searchHStack)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchHStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchHStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchHStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            searchBar.trailingAnchor.constraint(greaterThanOrEqualTo: sortButton.leadingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchHStack.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBar = searchBar.text, searchBar != "" else { return }
        
        networkManager.performSearch(searchTerm: searchBar) { (error) in
            if let error = error {
                print("Error: \(error)")
            } else {
                print(self.networkManager.searchResult)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return networkManager.searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SearchResultTableViewCell else {
            return UITableViewCell()
        }
        
        let result = networkManager.searchResult[indexPath.row]
        cell.results = result
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc: ArticleDetailViewController = ArticleDetailViewController()
        
        let selectedArticle = networkManager.searchResult[indexPath.row]
        vc.article = selectedArticle
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}
