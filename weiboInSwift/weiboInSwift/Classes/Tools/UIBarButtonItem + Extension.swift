//
//  UIBarButtonItem + Extension.swift
//  weiboInSwift
//
//  Created by 逗叔 on 15/9/14.
//  Copyright © 2015年 逗叔. All rights reserved.
//

import UIKit


extension UIBarButtonItem {

    convenience init(imgName: String, target: AnyObject?, action: String?) {
    
       let btn = UIButton()
        
        btn.setImage(UIImage(named: imgName), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: imgName + "_highlighted"), forState: UIControlState.Highlighted)
        
        btn.sizeToFit()
        
        // 设置监听方法
        if let actionName = action{
        
            btn.addTarget(target, action: Selector(actionName), forControlEvents: UIControlEvents.TouchUpInside)
        }
        
        self.init(customView: btn)
    }
    
        
    
}
