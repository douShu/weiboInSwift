
//
//  String + Extension.swift
//  weiboInSwift
//
//  Created by 逗叔 on 15/9/20.
//  Copyright © 2015年 逗叔. All rights reserved.
//

import Foundation

extension String {

    
    // MARK: - 提取字符串中的 href 链接内容
    func hrefLink() -> (link: String?, text: String?) {
    
        let pattern = "<a href=\"(.*?)\".*?>(.*?)</a>"
        
        let regex = try! NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.DotMatchesLineSeparators)
        
        /// 开始匹配
        if let result = regex.firstMatchInString(self, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) {
        
            let r1 = result.rangeAtIndex(1)
            let r2 = result.rangeAtIndex(2)
            
            let link = (self as NSString).substringWithRange(r1)
            let text = (self as NSString).substringWithRange(r2)
            
            return (link, text)
        }
        return (nil, nil)
    }
}