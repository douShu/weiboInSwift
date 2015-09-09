//
//  AppDelegate.swift
//  weiboInSwift
//
//  Created by 逗叔 on 15/9/6.
//  Copyright © 2015年 逗叔. All rights reserved.
//

import UIKit

/// 更改根控制器的通知
let DSUIWindowDidChangeRootControllerNotification: String = "DSUIWindowDidChangeRootControllerNotification"
var isMainVC = true

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let sandBoxVersionKey = "sandBoxVersionKey"

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        // 接收通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeRootVC:", name: DSUIWindowDidChangeRootControllerNotification, object: nil)
        
        // 设置nav和tab控制器的属性
        setupItem()
        
        // 创建window
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        
        // 设置根控制器
        window?.rootViewController = defaultVC()
        
        // 确定是否版本升级
        
        
        // 设置为主窗口
        window?.makeKeyAndVisible()
        
        
        return true
    }
    
    private func defaultVC() -> UIViewController{
    
        // 判断用户是否登录
        if UserAccount.loadUserAccount() == nil {
        
            return MainViewController()
        }
        
        // 判断是否有新版本
        return updateVersion() == true ? NewfeatureCollectionViewController() : WelcomeViewController()
    }
    
    /// 判断是否有新版本
    private func updateVersion() -> Bool{
    
        // info.plist的版本号
        let infoVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        
        // 沙盒中的版本号
        let sandBoxVersion: String? = NSUserDefaults.standardUserDefaults().objectForKey(sandBoxVersionKey) as? String
        
        if sandBoxVersion == nil {
        
            NSUserDefaults.standardUserDefaults().setObject(infoVersion, forKey: sandBoxVersionKey)

            return false
        }
        
        if infoVersion.compare(sandBoxVersion!) == NSComparisonResult.OrderedDescending {
        
            NSUserDefaults.standardUserDefaults().setObject(infoVersion, forKey: sandBoxVersionKey)
            
            return true
        }
        return false
    }
    
    /// 更改根控制器
    func changeRootVC(n: NSNotification)  {
    
        if n.object as! Bool == isMainVC {
        
            window?.rootViewController = MainViewController()
        } else {
        
            window?.rootViewController = WelcomeViewController()
        }
    }
    
    /// 设置nav和tab控制器的属性
    func setupItem() {
        
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        
        UITabBar.appearance().tintColor = UIColor.orangeColor()
    }
    
    deinit{
    
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

