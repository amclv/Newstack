//
//  HomeViewController.swift
//  Newstack
//
//  Created by Aaron Cleveland on 6/25/20.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let networkManager = NetworkingManager()
    private let articleDetailVC = ArticleDetailViewController()
    
    //=======================
    // MARK: - Stored Properties
    let mainNewsTitle = CustomLabel(style: .header, text: "Headlines")
    let secondaryNewsLabel = CustomLabel(style: .header, text: "Everything")
    
    let contentStack = CustomStackView(style: .contentStack, distribution: .fill, alignment: .fill)
    
    var picker = UIPickerView()
    var toolBar = UIToolbar()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.delaysContentTouches = false
        scrollView.bounces = false
        return scrollView
    }()
    
    let secondaryHStack: UIStackView = {
        let secondHStack = UIStackView()
        secondHStack.translatesAutoresizingMaskIntoConstraints = false
        secondHStack.axis = .horizontal
        return secondHStack
    }()
    
    let headlineCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 300, height: 250)
        layout.minimumLineSpacing = 20
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(HeadlineCollectionViewCell.self, forCellWithReuseIdentifier: HeadlineCollectionViewCell.identifier)
        cv.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    let everythingCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 375, height: 110)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(EverythingCollectionViewCell.self, forCellWithReuseIdentifier: EverythingCollectionViewCell.identifier)
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Background")
        headlineCollectionView.delegate = self
        headlineCollectionView.dataSource = self
        everythingCollectionView.delegate = self
        everythingCollectionView.dataSource = self
//        networkManager.fetchHeadlines {
//            self.updateViews()
//        }
        networkManager.fetchHeadlines(sources: "") {
            self.updateViews()
        }
        networkManager.fetchEverything {
            self.updateViews()
        }
        networkManager.fetchSources {
            print("TEST THIS BITCH::::::::::\(self.networkManager.sourcesFeed.count)")
            self.updateViews()
        }
        setupNavigationController()
        setupSubviews()
        setupConstraints()
    }
    let sArray: [String:String] = [:]
    
    func setupNavigationController() {
        self.navigationItem.title = "Newstack"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "newspaper"), style: .plain, target: self, action: #selector(menuButtonTapped))
        
    }
    
    func updateViews() {
        headlineCollectionView.reloadData()
        everythingCollectionView.reloadData()
        picker.reloadAllComponents()
    }
    
    @objc func menuButtonTapped() {
        picker = UIPickerView.init()
        picker.delegate = self
        picker.backgroundColor = UIColor(named: "Background")
        picker.setValue(UIColor.label, forKey: "textColor")
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 350, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(picker)
        
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 350, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .default
        toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
        self.view.addSubview(toolBar)
    }
    
    @objc func onDoneButtonTapped() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }
}

extension HomeViewController {
    func setupSubviews() {
        secondaryHStack.addArrangedSubview(secondaryNewsLabel)
        
        scrollView.addSubview(headlineCollectionView)
        scrollView.addSubview(secondaryHStack)
        scrollView.addSubview(everythingCollectionView)
        view.addSubview(scrollView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            headlineCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headlineCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headlineCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headlineCollectionView.heightAnchor.constraint(equalToConstant: 300),
            
            secondaryHStack.topAnchor.constraint(equalTo: headlineCollectionView.bottomAnchor, constant: 10),
            secondaryHStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            secondaryHStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            everythingCollectionView.topAnchor.constraint(equalTo: secondaryHStack.bottomAnchor, constant: 10),
            everythingCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            everythingCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            everythingCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == headlineCollectionView {
            return networkManager.headlineFeed.count
        }
        return networkManager.everythingFeed.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == headlineCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeadlineCollectionViewCell.identifier, for: indexPath) as? HeadlineCollectionViewCell else { return UICollectionViewCell() }
            
            let newArticle = networkManager.headlineFeed[indexPath.item]
            cell.headlineArticle = newArticle
            
            guard let url = newArticle.urlToImage else { return UICollectionViewCell() }
            networkManager.fetchImage(imageURL: url) { (data) in
                guard let newImage = UIImage(data: data) else { return }
                cell.headlineImage.image = newImage
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EverythingCollectionViewCell.identifier, for: indexPath) as? EverythingCollectionViewCell else { return UICollectionViewCell() }
            
            let everyArticle = networkManager.everythingFeed[indexPath.item]
            cell.everythingArticle = everyArticle
            
            guard let url = everyArticle.urlToImage else { return UICollectionViewCell() }
            networkManager.fetchImage(imageURL: url) { (data) in
                guard let newImage = UIImage(data: data) else { return }
                cell.articleImage.image = newImage
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc: ArticleDetailViewController = ArticleDetailViewController()
        
        // TODO: ADD IF STATEMENT FOR EACH FEED
        if collectionView == headlineCollectionView {
            let selectedArticle = networkManager.headlineFeed[indexPath.item]
            vc.article = selectedArticle
        } else {
            let selectedArticle = networkManager.everythingFeed[indexPath.item]
            vc.article = selectedArticle
        }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}

extension HomeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return networkManager.sourcesFeed.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        #warning("Base off categories of sources")
        return networkManager.sourcesFeed[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(networkManager.sourcesFeed[row])
        guard let id = networkManager.sourcesFeed[row].id else { return }
        DispatchQueue.main.async {
            self.networkManager.fetchHeadlines(sources: id) {
                self.updateViews()
            }
        }
    }
}
