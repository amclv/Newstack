//
//  BookmarkViewController.swift
//  Newstack
//
//  Created by Aaron Cleveland on 6/25/20.
//

import UIKit
import CoreData
import WebKit

class BookmarkViewController: UIViewController {
    
    // NSFetchedResultsController - In charge of managing the results of a Core Data fetch request and displaying the data to the user.
    private var fetchedArticle: NSFetchedResultsController<Article>!
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let networkManager = NetworkingManager()
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        configureTableView()
        setupNavigationController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let request = Article.fetchRequest() as NSFetchRequest<Article>
        let sort = NSSortDescriptor(key: #keyPath(Article.title), ascending: true)
        request.sortDescriptors = [sort]
        do {
            fetchedArticle = NSFetchedResultsController(fetchRequest: request,
                                                        managedObjectContext: context,
                                                        sectionNameKeyPath: nil,
                                                        cacheName: nil)
            try fetchedArticle.performFetch()
            fetchedArticle.delegate = self
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func setupNavigationController() {
        self.navigationItem.title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        setTableViewDelegates()
        tableView.register(BookmarkTableViewCell.self, forCellReuseIdentifier: BookmarkTableViewCell.identifier)
        tableView.rowHeight = 100
        tableView.addConstraintsToFillView(view)
    }
    
    func setTableViewDelegates() {
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension BookmarkViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let articles = fetchedArticle.fetchedObjects else { return 0 }
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BookmarkTableViewCell.identifier, for: indexPath) as! BookmarkTableViewCell
        
        let article = fetchedArticle.object(at: indexPath)
        cell.articleTitle.text = article.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ArticleDetailViewController()
        let article = fetchedArticle.object(at: indexPath)
        
        vc.articleTitle.text = article.title
        vc.articleDate.text = article.publishedAt
        vc.articleDetail.text = article.content
        vc.articleAuthorPaper.text = article.author
        vc.articleURL = article.url
        
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let article = fetchedArticle.object(at: indexPath)
            context.delete(article)
            appDelegate.saveContext()
            tableView.reloadData()
        }
    }
}

extension BookmarkViewController: NSFetchedResultsControllerDelegate {
    // controller is the method to notify the receiver that a fetchd object has been changed due to an add, remove, move or update.
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        // indexpath represents the idnex path of the changed object.
        // newindexpath represents the destination path for the object for insertions or moves.
        let index = indexPath ?? (newIndexPath ?? nil)
        guard let cellIndex = index else { return }
        switch type {
        case .insert:
            tableView.insertRows(at: [cellIndex], with: .fade)
        default:
            break
        }
    }
}
