//
//  UILabel + Extension.swift
//  weiboInSwift
//
//  Created by 逗叔 on 15/9/11.
//  Copyright © 2015年 逗叔. All rights reserved.
//

import UIKit

extension UILabel {

    convenience init(textLabelColor: UIColor, fontSize: CGFloat) {
    
        self.init()
        
        textColor = textLabelColor
        font = UIFont.systemFontOfSize(fontSize)
    }
}
