//
//  SearchViewController.swift
//  Newstack
//
//  Created by Aaron Cleveland on 7/11/20.
//

import UIKit

class SearchViewController: UIViewController {
    
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
    
    let tableView: UITableView = {
        let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        return tb
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupSubviews()
        setupConstraints()
    }
    
    private func setupSubviews() {
        view.addSubview(tableView)
        view.addSubview(textFieldSearchBar)
    }
    
    private func setupConstraints() {
        textFieldSearchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        textFieldSearchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        textFieldSearchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        tableView.topAnchor.constraint(equalTo: textFieldSearchBar.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
