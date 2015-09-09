//
//  UserAccount.swift
//  weiboInSwift
//
//  Created by 逗叔 on 15/9/8.
//  Copyright © 2015年 逗叔. All rights reserved.
//

import UIKit

class UserAccount: NSObject, NSCoding {
    
    
    // MARK: /**************************** 属性 ****************************/
    /// 用于调用access_token，接口获取授权后的access token
    var access_token: String?
    
    /// access_token的生命周期，单位是秒数 - 准确的数据类型是`数值`
    private var expires_in: NSTimeInterval = 0 {
    /// 设置过期日期
        didSet {
            
            expiresDate = NSDate(timeIntervalSinceNow: expires_in)
        }
    }
    
    /// 过期日期
    private var expiresDate: NSDate?
    
    /// 当前授权用户的UID
    var uid: String?
    
    /// 归档路径
    private static let accountPath: String = (NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last?.stringByAppendingPathComponent("/account.plist"))!
    
    /// 用户账号属性<---->外部调用方法
    static private var userAccount: UserAccount?
    class func loadUserAccount() -> UserAccount? {
    
        /// 判断账号信息是否存在
        if userAccount == nil {
        
            /// 解档
            /// 但是: 第一次解档之后userAccount也可能是nil
            userAccount = NSKeyedUnarchiver.unarchiveObjectWithFile(accountPath) as? UserAccount
        }
        
        /// 判断用户信息是否过期
        if let date = userAccount?.expiresDate where date.compare(NSDate()) == NSComparisonResult.OrderedAscending {
        
            /// 过期, 需要清零
            userAccount = nil
        }
        return userAccount
    }
    
    
    // MARK: /**************************** 初始化方法 ****************************/
    init(dict: [String: AnyObject]) {
        
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
    }
    
    // 描述对象
    override var description: String {
    
        let properties = ["access_token", "expires_in", "uid"]
        
        return "\(dictionaryWithValuesForKeys(properties))"
    }
    
    
    // MARK: /**************************** 存储模型数据至document ****************************/
    /// 归档
    func saveUserAccount() {
    
        NSKeyedArchiver.archiveRootObject(self, toFile: UserAccount.accountPath)
    }
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeDouble(expires_in, forKey: "expires_in")
        aCoder.encodeObject(expiresDate, forKey: "expiresDate")
        aCoder.encodeObject(uid, forKey: "uid")
        
    }
    
    /// 解档
    required init?(coder aDecoder: NSCoder) {
        
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expires_in = aDecoder.decodeDoubleForKey("expires_in")
        expiresDate = aDecoder.decodeObjectForKey("expiresDate") as? NSDate
        uid = aDecoder.decodeObjectForKey("uid") as? String
    }
    
}
