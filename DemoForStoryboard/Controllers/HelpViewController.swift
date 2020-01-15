//
//  HelpViewController.swift
//  NewsFeed
//
//  Created by Ravindra Sonkar on 29/09/19.
//  Copyright © 2019 Ravindra Sonkar. All rights reserved.
//

import UIKit
import WebKit

class HelpViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var webView: UIView! // To load a downloaded document like pdf,ppt,audio etc in our application.
    
    var urlString : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.groupTableViewBackground
        self.displayDataContents()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    //MARK:- Display Content Function
    /**
     This function is made for updating UI on Screen according to requirement if isDocument is true then it prepare WKWebView and load document in it.
     otherwise it show image in ImageView and make WebView Hidden.
     
     - Note: Loading Message Label Only Visible when isDocument is True as Loading message is required only in webview.
     */
    
    private func displayDataContents() {
//        DataUtils.addLoader()
        self.webView.isHidden = false
        webView.layoutIfNeeded()
        let dataWebView = WKWebView(frame: self.webView.bounds)
        dataWebView.backgroundColor = UIColor.groupTableViewBackground
        dataWebView.navigationDelegate = self
        dataWebView.load(URLRequest(url: URL(string: urlString)!))
        self.webView.addSubview(dataWebView)
    }
    
    //MARK:- WKNavigationDelegate Fucntions
    /**
     These fucntions are delegate methods of WKWebView which identifies whether the webView is finished loading the document
     1. didFinish : called when the document is successfully and fully loaded the document on screen.
     2. didFailProvisionalNavigation : Called when WkWebView Failed to load a corrupted document.
     In this fuction we display a error message on screen to notify user about error.
     
     Note - In didFinish Func we hiding the loadingMessageLabel as the document is fully loaded.
     */
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DataUtils.removeLoader()
    }
    
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        DataUtils.removeLoader()
    }
}
