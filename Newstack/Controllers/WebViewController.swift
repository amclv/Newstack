//
//  WebViewController.swift
//  Newstack
//
//  Created by Aaron Cleveland on 9/3/20.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {
    
    var webView = WKWebView()
    let forwardBarItem = UIBarButtonItem(title: "Forward",
                                         style: .plain,
                                         target: self,
                                         action: #selector(fowardAction))
    let backwardBarItem = UIBarButtonItem(title: "Backward",
                                         style: .plain,
                                         target: self,
                                         action: #selector(backwardAction))

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        let dummyURL = URL(string: "https://www.apple.com")
        let myRequest = URLRequest(url: dummyURL!)
        webView.load(myRequest)
        configureNavigationBar()
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    // MARK: - Selectors
    @objc func fowardAction() {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    @objc func backwardAction() {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    // MARK: - Helpers
    func configureNavigationBar() {
        self.navigationItem.leftBarButtonItem = backwardBarItem
        self.navigationItem.rightBarButtonItem = forwardBarItem
        
        self.navigationController?.navigationBar.barTintColor = .systemBlue
        self.navigationController?.navigationBar.tintColor = .white
    }

}
