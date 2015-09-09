//
//  oauthViewController.swift
//  weiboInSwift
//
//  Created by 逗叔 on 15/9/7.
//  Copyright © 2015年 逗叔. All rights reserved.
//

import UIKit
import SVProgressHUD

class oauthViewController: UIViewController, UIWebViewDelegate {

    private let webView: UIWebView = UIWebView()
    override func loadView() {
    
        view = webView
        
        webView.delegate = self
        
        title = "新浪微博"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Plain, target: self, action: "close")
    }
    
    override func viewDidLoad() {
        
        // 访问授权地址
        webView.loadRequest(NSURLRequest(URL: NetworkTool.sharedNetworkTool.oauthURL()))
    }
    
    // MARK:  监听关闭item
    func close() {
    
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK:  webView的代理方法
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
       
        let stringURL = request.URL!.absoluteString
        
        // 判断是否包含回传地址
        if !stringURL.hasPrefix(NetworkTool.sharedNetworkTool.redirect_uri) {
        
            return true
        }
        
        // 截取code
        if let query: String = request.URL!.query where query.hasPrefix("code=") {
        
            // 拿到服务器返回的code
            let code = query.substringFromIndex(advance(query.startIndex, "code=".characters.count))
            
            print("code->\(code)")
            
            // 拿到授权
            loadToken(code)
        } else {
        
            // 返回登录界面
            close()
        }
        
        return false
    }
    
    private func loadToken(code: String) {
    
        NetworkTool.sharedNetworkTool.loadToken(code) { (result, error) -> () in
            
            if error != nil || result == nil {
                
                // 提示用户
                SVProgressHUD.showInfoWithStatus("您的网络不给力")
                
                // 延迟一秒
                let when = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC))
                
                dispatch_after(when, dispatch_get_main_queue(), { () -> Void in
                    
                    self.close()
                })
                
                return
            }
            
            print("即将拿到token")
            
            /// 字典转模型
            let account = UserAccount(dict: result!)
            /// 归档: 用户信息
            account.saveUserAccount()
            /// 加载用户信息
            NetworkTool.sharedNetworkTool.loadUserInfo({ (result, error) -> () in
                
                print(result)
            })
        }
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        SVProgressHUD.dismiss()
    }
}
