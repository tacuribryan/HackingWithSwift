//
//  ViewController.swift
//  Project4
//
//  Created by Bryan Tacuri on 6/24/19.
//  Copyright © 2019 Bryan Tacuri. All rights reserved.
//

import UIKit
import WebKit // bring the WebKit and UI framework

class ViewController: UIViewController , WKNavigationDelegate{
    var webView: WKWebView!
    var progressView: UIProgressView!
    var websites = ["hackingwithswift.com", "apple.com"]
    
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self  //When any webpage is loaded please tell me the current ViewController
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        // UIBarButtonItem that creates a flexible space
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        //calls the reload method of our webView
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        progressView = UIProgressView(progressViewStyle: .default) //Creates a new UIProgressView instance giving a default value
        progressView.sizeToFit()    //Takes as much space as needed to show the progress bar
        let progressButton = UIBarButtonItem(customView: progressView)  //wraps up our progressView in a barButtonItem so it can go in our toolbar
        let backButton = UIBarButtonItem(title: " ⟵ ", style: .plain, target: webView, action: #selector(webView.goBack))
        let forwardButton = UIBarButtonItem(title: " ⟶ ", style: .plain, target: webView, action: #selector(webView.goForward))
        
        //creates an aray for our flexible space and our refresh
        toolbarItems = [progressButton, spacer, refresh]
        toolbarItems = [progressButton, spacer, backButton, forwardButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        let url = URL(string: "https://" + websites[0])! //stores the URL location
        webView.load(URLRequest(url: url))      //Wraps a url into a URLRequest
        webView.allowsBackForwardNavigationGestures = true  //allows you to move backward or forward on a website
    }
    @objc func openTapped(){
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        for website in websites {
        ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem //Important for iPads. It tells where this actionsheet should be anchored
        present(ac, animated: true)
    }
    
    //takes UIAlerAction selected by the user
    func openPage(action: UIAlertAction){
        guard let actionTitle = action.title else { return }
        guard let url = URL(string: "https://" + actionTitle) else { return } //takes the title of our action with https:// to create a new url
        webView.load(URLRequest(url: url)) //wraps URLRequest into our webview
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    func displayUnauthorizedSiteAlert() {
        let alertController = UIAlertController(
            title: "Caution",
            message: "Pages outside the host page are not allow",
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alertController, animated: true)
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url?.host{
            for website in websites {
                if host.contains(website){
                    decisionHandler(.allow)
                    return
                }
            }
        }
        decisionHandler(.cancel)
        displayUnauthorizedSiteAlert()
    }

}

