
//
//  UIColor + Extension.swift
//  weiboInSwift
//
//  Created by 逗叔 on 15/9/18.
//  Copyright © 2015年 逗叔. All rights reserved.
//

import UIKit

extension UIColor {

    class func randomColor() -> UIColor {
    
        return UIColor(colorLiteralRed: randomValue(), green: randomValue(), blue: randomValue(), alpha: 1.0)
    }
    
    private class func randomValue() -> Float {
    
        let value = arc4random_uniform(256)
        
        return Float(value) / 255
    }
}
