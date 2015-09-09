//
//  BaseTableViewController.swift
//  weiboInSwift
//
//  Created by 逗叔 on 15/9/6.
//  Copyright © 2015年 逗叔. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController, VisitLoginViewDelegate {

    var userLogin: Bool?
    
    // 访客视图
    var visitLoginView: VisitLoginView?
    
    override func loadView() {
        
        userLogin = userLoginWeibo()
        
        userLogin == true ? super.loadView() : setupLoginView()
    }
    
    private func userLoginWeibo() -> Bool {
        
        return UserAccount.loadUserAccount() != nil
    }
    
    // 设置登录视图
    private func setupLoginView() {
    
        visitLoginView = VisitLoginView()
        
        view = visitLoginView
        
        // 设置代理
        visitLoginView?.delegate = self
        
        // 设置navigationItem
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: "visitLoginViewWillRegist")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.Plain, target: self, action: "visitLoginViewWillLogin")
    }
    
    // MARK:  VisitLoginViewDelegate代理方法
    func visitLoginViewWillLogin() {
        print("登录")
        
        // modal 到授权控制器
        let nav = UINavigationController(rootViewController: oauthViewController())
        presentViewController(nav, animated: true, completion: nil)
    }
    
    func visitLoginViewWillRegist() {
        print("注册")
    }
}
