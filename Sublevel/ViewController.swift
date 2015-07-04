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
    
    override func loadView() {
        self.webView = WKWebView()
        self.view = self.webView!
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
    }
    
    func handleRefresh(refresh: UIRefreshControl) {
        //webView?.reload()
        let url = webView?.URL
        let requested = NSURLRequest(URL: url!)
        webView!.loadRequest(requested)
        refresh.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

