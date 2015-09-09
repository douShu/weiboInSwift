//
//  AppDelegate.swift
//  weiboInSwift
//
//  Created by 逗叔 on 15/9/6.
//  Copyright © 2015年 逗叔. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        // 设置nav和tab控制器的属性
        setupItem()
        
        // 创建window
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        
        // 设置根控制器
        window?.rootViewController = MainViewController()
        
        // 设置为主窗口
        window?.makeKeyAndVisible()
        
        
        return true
    }
    
    // 设置nav和tab控制器的属性
    func setupItem() {
        
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        
        UITabBar.appearance().tintColor = UIColor.orangeColor()
    }
}

