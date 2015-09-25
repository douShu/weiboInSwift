//
//  SQLiteManager.swift
//  14-测试FMDB
//
//  Created by 逗叔 on 15/9/23.
//  Copyright © 2015年 逗叔. All rights reserved.
//

import Foundation

/// 默认的数据库文件名, 如果以 db 为结尾, 容易被发现
/// SQLite 公开的版本不支持加密, 如果需要加口令, 可以去 gitHub 找一个扩展
private let dbName = "status.db"

class SQLiteManager {
    
    static let sharedManager = SQLiteManager()
    
    /// 能够保证线程安全, 内部有一个串行队列!
    let queue: FMDatabaseQueue
    
    /// 1> 在构造函数中, 建立数据库队列
    /// private 修饰符可以禁止外部实例化对象, 保证所有的访问都是通过 sharedManager 来调用的
    private init() {
    
        let path = (NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last! as NSString).stringByAppendingPathComponent(dbName)
    
        print(path)
        
        /// 创建数据库队列
        /// 如果数据库不存在, 会新建数据库, 否则会直接打开
        /// 后续所有根数据库的操作, 都通过 queue 来调用
        queue = FMDatabaseQueue(path: path)
        
        createTable()
    }
    
    /// 创建数据表
    private func createTable() {
    
        let path = NSBundle.mainBundle().pathForResource("tables.sql", ofType: nil)!
        let sql = try! String(contentsOfFile: path)
        
        /// executeStatements 执行很多 sql
        /// executeQuery 执行查询
        /// executeUpdate 执行单条 SQL, 插入/更新/删除, 除了 select 都可以用这个函数
        queue.inTransaction { (db, rollback) -> Void in
        
            if db.executeStatements(sql) {
            
                print("创建数据表成功")
            } else {
            
                print("创建数据表失败")
            }
        }
    }
}