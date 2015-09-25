//
//  WebViewController.swift
//  weiboInSwift
//
//  Created by 逗叔 on 15/9/21.
//  Copyright © 2015年 逗叔. All rights reserved.
//

import UIKit
import SVProgressHUD

class WebViewController: UIViewController, UIWebViewDelegate {

    var url: NSURL?
    
    lazy var webView: UIWebView = UIWebView()
    
    override func loadView() {
        
        view = webView
        
        webView.delegate = self
    }
    
    override func viewDidLoad() {
        
        title = "网页"
        
        if url != nil {
        
            webView.loadRequest(NSURLRequest(URL: url!))
        }
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        SVProgressHUD.dismiss()
    }
    

}
