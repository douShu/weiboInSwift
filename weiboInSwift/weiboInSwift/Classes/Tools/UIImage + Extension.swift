//
//  UIImage + Extension.swift
//  PhotoSelected
//
//  Created by 逗叔 on 15/9/16.
//  Copyright © 2015年 逗叔. All rights reserved.
//

import UIKit

extension UIImage {

    func scaleImage(width: CGFloat) -> UIImage {
    
        if size.width < width {
        
            return self
        }
        
        let height = size.height * width / size.width
        
        let s = CGSize(width: width, height: height)
        
        /// 重绘
        UIGraphicsBeginImageContext(s)
        
        drawInRect(CGRect(origin: CGPointZero, size: s))
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return result
    }
    

}
