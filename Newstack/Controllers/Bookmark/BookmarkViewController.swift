//
//  BookmarkViewController.swift
//  Newstack
//
//  Created by Aaron Cleveland on 6/25/20.
//

import UIKit
import CoreData

class BookmarkViewController: UIViewController {
    
    let articleController = ArticleController()
    let tableView = UITableView()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Article> = {
        let fetchRequest: NSFetchRequest<Article> = Article.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: false)]
        
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "title", cacheName: nil)
        
        frc.delegate = self
        
        try! frc.performFetch()
        
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setupNavigationController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    func setupNavigationController() {
        self.navigationItem.title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        setTableViewDelegates()
        tableView.register(BookmarkTableViewCell.self, forCellReuseIdentifier: BookmarkTableViewCell.identifier)
        tableView.rowHeight = 150
        tableView.backgroundColor = UIColor(named: "Background")
        tableView.addConstraintsToFillView(view)
    }
    
    func setTableViewDelegates() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
}

extension String {
    var imageFromBase64EncodedString: UIImage? {
        if let data = NSData(base64Encoded: self, options: .ignoreUnknownCharacters) {
            return UIImage(data: data as Data)
        }
        return nil
    }
}

extension BookmarkViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookmarkTableViewCell.identifier, for: indexPath) as? BookmarkTableViewCell else { return UITableViewCell() }
        
        let article = fetchedResultsController.object(at: indexPath)
        cell.article = article
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ArticleDetailViewController()
        let fetchedArticle = fetchedResultsController.object(at: indexPath)
        
        guard let urlToImage = fetchedArticle.urlToImage,
            let url = fetchedArticle.url else { return }
        let imageURL = URL(string: urlToImage)!

        vc.articleTitle.text = fetchedArticle.title
        vc.articleDate.text = fetchedArticle.publishedAt
        vc.articleAuthorPaper.text = fetchedArticle.author
        vc.articleDetail.text = fetchedArticle.content
        vc.topViewBackgroundImage.image = try? UIImage(withContentsOfUrl: imageURL)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let article = fetchedResultsController.object(at: indexPath)
            articleController.delete(article: article)
            tableView.reloadData()
        }
    }
}

extension BookmarkViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            return
        }
    }
}
