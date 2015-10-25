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
        let url = NSURL(string: "https://sublevel.net/")
        let requested = NSURLRequest(URL: url!)
        webView.loadRequest(requested)
        webView.allowsBackForwardNavigationGestures = true
        
        // Add refreshControl subView
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("handleRefresh:"), forControlEvents: UIControlEvents.ValueChanged)
        webView.scrollView.addSubview(refreshControl)
        
        // Inset progressView subView
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        let screen = UIScreen.mainScreen().bounds
        progressView.frame.size.width = screen.size.width
        progressView.trackTintColor = UIColor.clearColor()
        self.view.insertSubview(progressView, aboveSubview: webView)
    }
    
    func handleRefresh(refresh: UIRefreshControl) {
        // Instead of webView?.reload()
        let url = webView.URL
        let requested = NSURLRequest(URL: url!)
        webView.loadRequest(requested)
        refresh.endRefreshing()
    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if (keyPath == "estimatedProgress") {
            progressView.hidden = webView.estimatedProgress == 1
            let size = 1 - Float(webView.estimatedProgress)
            progressView.setProgress(size, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

