//  StatusDAL.swift
//  weiboInSwift
//  Created by 逗叔 on 15/9/23.
//  Copyright © 2015年 逗叔. All rights reserved.

import Foundation

private let dbCacheDateTime: NSTimeInterval = 1 * 24 * 3600

class StatusDAL {
    
    /// 清理数据缓存
    class func clearDBCache() {
    
        let date = NSDate(timeIntervalSinceNow: -dbCacheDateTime)
        
        /// 日期->字符串
        let df = NSDateFormatter()
        df.locale = NSLocale(localeIdentifier: "en")
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateSting = df.stringFromDate(date)
        
        let sql = "DELETE FROM T_status WHERE createTime < '\(dateSting)';"
        
        SQLiteManager.sharedManager.queue.inDatabase { (db) -> Void in
            
            db.executeUpdate(sql)
            print("删除成功")
        }
    }
    
    
    /// 数据访问层加载数据
    /// 从数据库&网络加载
    class func loadStatus(since_id: Int, max_id: Int, finished: (array: [[String : AnyObject]]?, error: NSError?)->()) {
    
        /// 1. 检查本地是否有缓存数据
        loadCacheData(since_id, max_id: max_id) { (array) -> () in
            
            /// 2. 如果有缓存数据, 直接返回
            if (array?.count ?? 0) > 0 {

                finished(array: array, error: nil)
                return
            }
            /// 3. 如果没有, 加载网络数据
            NetworkTool.sharedNetworkTool.loadStatus(since_id, max_id: max_id, finished: { (result, error) -> () in
                
                if let array = result?["statuses"] as? [[String : AnyObject]] {
                
                    /// 4. 加载完成后, 将数据保存至服务器
                    saveStatus(array)
                    
                    /// 5. 完成回调
                    finished(array: array, error: nil)
                } else {
                
                    finished(array: nil, error: error)
                }
            })
        }
    }
    
    /// 加载缓存数据
    /// 1. 确定参数: since_id 下拉刷下  Max_id 上拉刷新
    /// 2. 确定SQL
    /// 3. 执行SQL, 返回数据
    class func loadCacheData(since_id: Int, max_id: Int, finished: (array: [[String : AnyObject]]?) -> ()) {
    
        /// 断言: 判断用户是否登录
        assert(UserAccount.sharedUserAccount != nil, "请用户登录")
        
        let userId = UserAccount.sharedUserAccount!.uid!
        
        var sql = "SELECT statusId, status, userId FROM T_Status \n" +
        "WHERE userId = \(userId) \n"
        
        if since_id > 0 { /// 下拉刷新
        
            sql += "AND statusId > \(since_id) \n"
        } else if max_id > 0 { /// 上拉刷新
        
            sql += "AND statusId < \(max_id) \n"
        }
        
        sql += "ORDER BY statusId DESC LIMIT 20;"
        
        SQLiteManager.sharedManager.queue.inDatabase { (db) -> Void in
            
            guard let rs = db.executeQuery(sql) else {
                
                finished(array: nil)
                return
            }
            
            /// 生成查询结果内容
            var array = [[String : AnyObject]]()
            while rs.next() {
            
                let jsonString = rs.stringForColumn("status")
                
                /// 反序列化
                let dict = try! NSJSONSerialization.JSONObjectWithData(jsonString.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions(rawValue: 0)) as! [String : AnyObject]
                
                /// 将字典插入数组
                array.append(dict)
            }
            
            /// 通过回调返回数据
            finished(array: array)
        }
    }
    
    /// 将数据保存到数据库
    /// 1. 确定参数: since_id 下拉刷下  Max_id 上拉刷新
    /// 2. 确定SQL
    /// 3. 利用数据库工具, 遍历数组, 顺序插入数据
    class func saveStatus(array: [[String : AnyObject]]) {
        
        /// 判断用户是否登录
        assert(UserAccount.sharedUserAccount != nil, "请用户登录")
        
        /*
            1. 字段中一定要有主键
            2. 主键一定不是自动增长的, 如果是自动增长, INSERT的时候, 无法确定主键
        */
        let sql = "INSERT OR REPLACE INTO T_Status (statusId, status, userId) VALUES (?, ?, ?);"
        
        let userId = UserAccount.sharedUserAccount!.uid!
        
        SQLiteManager.sharedManager.queue.inTransaction { (db, rollback) -> Void in
            
            /// 1> 遍历字典
            for dict in array {
            
                /// 微博代号
                let statusId = dict["id"] as! Int
                
                /// status 是字典对应的 JSON 字符串, 序列化
                let json = try! NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions(rawValue: 0))
                let jsonString = NSString(data: json, encoding: NSUTF8StringEncoding)!
                
                /// 插入数据
                if !db.executeUpdate(sql, statusId, jsonString, userId) {
                
                    rollback.memory = true
                    break
                }
            }
            /// 2> 输出结果
            print("保存了 \(array.count) 条数据")
        }
    }
}