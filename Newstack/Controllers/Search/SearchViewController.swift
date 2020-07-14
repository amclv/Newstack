//
//  SearchViewController.swift
//  Newstack
//
//  Created by Aaron Cleveland on 7/11/20.
//

import UIKit

class SearchViewController: UIViewController {
    
    var originalArr = [[String:Any]]()
    var searchArr = [[String:Any]]()
    var searching: Bool = false
    
    let searchHStack = CustomStackView(style: .searchHStack, distribution: .equalSpacing, alignment: .fill)
    
    lazy var textFieldSearchBar: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Search me BITCH! 🖕🏽"
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.font = UIFont.systemFont(ofSize: 13)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.layer.cornerRadius = 15
        textField.clipsToBounds = true
        textField.layer.borderWidth = 0.2
        textField.layer.borderColor = UIColor.black.cgColor
        return textField
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
        tb.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tb
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        textFieldSearchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        setupSubviews()
        setupConstraints()
        
        originalArr =   [
            ["name": "abdul", "number": "+8800000001"],
            ["name": "abdin", "number": "+8800000002"],
            ["name": "Enamul", "number": "+8800000003"],
            ["name": "enam", "number": "+8800000004"],
            ["name": "Rafi", "number": "+8800000005"],
            ["name": "Ehaque", "number": "+8800000006"],
            ["name": "ab", "number": "+8800000007"],
            ["name": "Emon", "number": "+8800000008"],
            ["name": "enamu1", "number": "+8800000009"],
            ["name": "rafi", "number": "+88000000010"],
            ["name": "karim", "number": "+88000000011"],
            ["name": "radev", "number": "+88000000012"],
            ["name": "da", "number": "+88000000013"],
            ["name": "aa", "number": "+88000000014"],
            ["name": "rafi", "number": "+88000000010"],
            ["name": "karim", "number": "+88000000011"],
            ["name": "radev", "number": "+88000000012"],
            ["name": "da", "number": "+88000000013"],
            ["name": "aa", "number": "+88000000014"]
           ]
    }
    
    @objc func sortButtonTapped() {
        print("SORT BUTTON TAPPED!")
    }
}

extension SearchViewController {
    private func setupSubviews() {
        searchHStack.addArrangedSubview(textFieldSearchBar)
        searchHStack.addArrangedSubview(sortButton)
        
        view.addSubview(tableView)
        view.addSubview(searchHStack)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchHStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchHStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchHStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            textFieldSearchBar.trailingAnchor.constraint(greaterThanOrEqualTo: sortButton.leadingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchHStack.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let searchText = textField.text! + string
        searchArr = self.originalArr.filter({(($0["name"] as! String).localizedCaseInsensitiveContains(searchText))})
        
        if (searchArr.count == 0) {
            searching = false
        } else {
            searching = true
        }
        self.tableView.reloadData()
        return true
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searching == true) {
            return searchArr.count
        } else {
            return originalArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if (searching == true) {
            let dict = searchArr[indexPath.row]
            cell.textLabel?.text = dict["name"] as? String
        } else {
            let dict = originalArr[indexPath.row]
            cell.textLabel?.text = dict["name"] as? String
        }
        return cell
    }
    
    
}
