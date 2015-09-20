
//
//  NSDate + Extension.swift
//  weiboInSwift
//
//  Created by 逗叔 on 15/9/20.
//  Copyright © 2015年 逗叔. All rights reserved.
//

import Foundation

extension NSDate {

    
    // MARK: - ----------------------------- 将日期字符转换成日期 -----------------------------
    class func sinaDate(string: String) -> NSDate? {
    
        let df = NSDateFormatter()
        
        /// 英国时区
        df.locale = NSLocale(localeIdentifier: "en")
        
        df.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
        
        return df.dateFromString(string)
    }
    
    var dateDesctiption: String {
    
        /// 1> 取出当前日历
        let cal = NSCalendar.currentCalendar()
        
        /// 2> 判断是否是今天
        if cal.isDateInToday(self) {
        
            let delta = Int(NSDate().timeIntervalSinceDate(self))
            
            if delta < 60 {
            
                return "刚刚"
            }
            if delta < 3600 {
            
                return "\(delta / 60) 分钟前"
            }
            
            return "\(delta / 3600) 小时前"
        }
        
        /// 3> 判断是否是昨天
        var fmtString = " HH:mm"
        
        if cal.isDateInYesterday(self) {
        
            /// 昨天
            fmtString = "昨天" + fmtString
        } else {
        
            /// 今年
            fmtString = "MM-dd" + fmtString
            
            let coms = cal.components(NSCalendarUnit.Year, fromDate: self, toDate: NSDate(), options: NSCalendarOptions(rawValue: 0))
            
            if coms.year > 0 {
            
                /// 去年
                fmtString = "yyyy-" + fmtString
            }
        }
        
        let df = NSDateFormatter()
        df.locale = NSLocale(localeIdentifier: "en")
        df.dateFormat = fmtString
        return df.stringFromDate(self)
    }
}