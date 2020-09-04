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
    var articleURL: URL?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchURL()
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    // MARK: - Helpers
    func fetchURL() {
        guard let url = articleURL else { return }
        let myRequest = URLRequest(url: url)
        webView.load(myRequest)
    }
}
