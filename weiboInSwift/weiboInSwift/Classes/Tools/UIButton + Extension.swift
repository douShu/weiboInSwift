//
//  UIButton + Extension.swift
//  weiboInSwift
//
//  Created by 逗叔 on 15/9/12.
//  Copyright © 2015年 逗叔. All rights reserved.
//

import UIKit

extension UIButton {

    convenience init(title: String, imgName: String, fontSize: CGFloat = 12, fontColor: UIColor = UIColor.darkGrayColor()) {
    
        self.init()
        
        setTitle(title, forState: UIControlState.Normal)
        setImage(UIImage(named: imgName), forState: UIControlState.Normal)
        setTitleColor(fontColor, forState: UIControlState.Normal)
        titleLabel?.font = UIFont.systemFontOfSize(fontSize)
    }
    
    convenience init(imageName: String) {
        
        self.init()
        
        setImage(imageName)
    }
    
    func setImage(imageName: String) {
        
        setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        setImage(UIImage(named: imageName + "_highlighted"), forState: UIControlState.Highlighted)
    }

    convenience init(title: String, fontSize: CGFloat = 14, fontColor: UIColor = UIColor.darkGrayColor(), backColor: UIColor = UIColor.lightGrayColor()) {
    
        self.init()
        
        setTitle(title, forState: UIControlState.Normal)
        titleLabel?.font = UIFont.systemFontOfSize(fontSize)
        setTitleColor(fontColor, forState: UIControlState.Normal)
        backgroundColor = backColor   
    }
}
