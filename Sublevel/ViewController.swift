//
//  ViewController.swift
//  Sublevel
//
//  Created by lucian on 11/26/14.
//  Copyright (c) 2014 Lucian Marin. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    var webView = WKWebView()
    let progressView = UIProgressView()
    
    override func loadView() {
        self.webView = WKWebView()
        self.view = self.webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set URL for webView
        let url = URL(string: "https://sublevel.net/")
        let requested = URLRequest(url: url!)
        webView.load(requested)
        webView.allowsBackForwardNavigationGestures = true
        if #available(iOS 9.0, *) {
            webView.allowsLinkPreview = true
        }
        
        // Add refreshControl subView
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        webView.scrollView.addSubview(refreshControl)
        
        // Inset progressView subView
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        let screen = UIScreen.main.bounds
        progressView.frame.size.width = screen.size.width
        progressView.trackTintColor = UIColor.clear
        self.view.insertSubview(progressView, aboveSubview: webView)
    }
    
    func handleRefresh(_ refresh: UIRefreshControl) {
        // Instead of webView?.reload()
        let url = webView.url
        let requested = URLRequest(url: url!)
        webView.load(requested)
        refresh.endRefreshing()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "estimatedProgress") {
            var size = Float(webView.estimatedProgress)
            if (size == 1) { size = 0 }
            progressView.setProgress(size, animated: true)
        }
        if (keyPath == "loading") {
            progressView.isHidden = webView.isLoading == false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

