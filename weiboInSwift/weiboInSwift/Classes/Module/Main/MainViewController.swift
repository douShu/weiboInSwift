//
//      MainViewController.swift
//  weiboInSwift
//
//  Created by 逗叔 on 15/9/6.
//  Copyright © 2015年 逗叔. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 添加子控制器
        addChildViewControllers()
    }

    /**
    设置加号按钮
    */
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        // 设置按钮的frame
        let w = tabBar.bounds.width / CGFloat(childViewControllers.count)
        let rect = CGRect(x: w * 2 , y: 0, width: w, height: tabBar.bounds.height)
        composedButton.frame = rect
        
    }
    
    /**
    添加子控制器
    */
    func addChildViewControllers() {
        
        addChildViewController(HomeTableViewController(), title: "首页", imgName: "tabbar_home")
        addChildViewController(MessageTableViewController(), title: "消息", imgName: "tabbar_message_center")
        addChildViewController(UIViewController())
        addChildViewController(DiscoverTableViewController(), title: "发现", imgName: "tabbar_discover")
        addChildViewController(ProfileTableViewController(), title: "我", imgName: "tabbar_profile")
    }
    
    /**
    添加自控制函数抽取
    
    - parameter vc     : 控制器
    - parameter title  : 标题
    - parameter imgName: 图片名字
    */
    private func addChildViewController(vc: UIViewController, title: String, imgName: String) {
        
        // 创建nav控制器
        let nav = UINavigationController(rootViewController: vc)
        
        // 设置控制器属性
        vc.title = title
        vc.tabBarItem.image = UIImage(named: imgName)
        
        addChildViewController(nav)
    }
    
    /**
    懒加载加号按钮
    */
    lazy var composedButton: UIButton = {
        
        let btn = UIButton()
        
        btn.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: UIControlState.Normal)
        
        self.tabBar.addSubview(btn)
        
        btn.addTarget(self, action: "clickComposeButton", forControlEvents: UIControlEvents.TouchUpInside)
        
        return btn
    }()
    
    func clickComposeButton() {
    
        print(__FUNCTION__)
    }
}
