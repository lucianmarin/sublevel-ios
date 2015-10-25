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
    
    var webView: WKWebView?
    let progressView = UIProgressView()
    
    override func loadView() {
        self.webView = WKWebView()
        self.view = self.webView!
        let screen = UIScreen.mainScreen().bounds
        progressView.frame.size.width = screen.size.width
        self.view.insertSubview(progressView, aboveSubview: webView!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let url = NSURL(string: "https://sublevel.net/")
        let requested = NSURLRequest(URL: url!)
        webView!.loadRequest(requested)
        webView!.allowsBackForwardNavigationGestures = true
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("handleRefresh:"), forControlEvents: UIControlEvents.ValueChanged)
        webView!.scrollView.addSubview(refreshControl)
        webView!.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
    }
    
    func handleRefresh(refresh: UIRefreshControl) {
        //webView?.reload()
        let url = webView?.URL
        let requested = NSURLRequest(URL: url!)
        webView!.loadRequest(requested)
        refresh.endRefreshing()
    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if (keyPath == "estimatedProgress") {
            progressView.trackTintColor = UIColor.clearColor()
            progressView.hidden = webView!.estimatedProgress == 1
            let size = 1 - Float(webView!.estimatedProgress)
            if (webView!.loading) {
                progressView.setProgress(size, animated: true)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

