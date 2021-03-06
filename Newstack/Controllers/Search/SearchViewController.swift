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
        sb.backgroundImage = UIImage()
        sb.barStyle = .default
        return sb
    }()
    
    let tableView: UITableView = {
        let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.identifier)
        tb.backgroundColor = UIColor(named: "Background")
        tb.separatorStyle = .none
        return tb
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Background")
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        setupSubviews()
        setupConstraints()
        configureNavigationController()
    }
    
    func configureNavigationController() {
        self.navigationItem.title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension SearchViewController {
    private func setupSubviews() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
        ])
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBar = searchBar.text?.lowercased(), searchBar != "" else { return }
        
        networkManager.performSearch(searchTerm: searchBar) { (error) in
            if let error = error {
                print("Error: \(error)")
            } else {
                if searchBar == "Covid".lowercased() || searchBar == "Covid-19".lowercased() || searchBar == "Coronavirus".lowercased() || searchBar == "Covid19".lowercased() || searchBar == "19".lowercased() {
                    DispatchQueue.main.async {
                        Alert.showBasic(title: "Oops!", message: "Can't display Covid related information", vc: self)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.tableView.keyboardDismissMode = .onDrag
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            networkManager.searchResult.removeAll()
            tableView.reloadData()
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return networkManager.searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier, for: indexPath) as! SearchResultTableViewCell
        
        let result = networkManager.searchResult[indexPath.row]
        cell.results = result
        cell.backgroundColor = UIColor(named: "Background")
        guard let urlImage = result.urlToImage else { return UITableViewCell() }
        networkManager.fetchImage(imageURL: urlImage) { (data) in
            guard let newImage = UIImage(data: data) else { return }
            cell.articleImage.image = newImage
        }
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
