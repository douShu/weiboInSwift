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
    /// 友好显示名称
    var name: String?
    
    /// 用户头像地址（大图），180×180像素
    var avatar_large: String?
    
    /// 用于调用access_token，接口获取授权后的access token
    var access_token: String?
    
    /// 过期日期
    private var expiresDate: NSDate?
    
    /// 当前授权用户的UID
    var uid: String?
    
    /// 归档路径
    private static let accountPath: String = (NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last?.stringByAppendingPathComponent("/account.plist"))!
    
    /// access_token的生命周期，单位是秒数 - 准确的数据类型是`数值`
    var expires_in: NSTimeInterval = 0 {
        /// 设置过期日期
        didSet {
            
            expiresDate = NSDate(timeIntervalSinceNow: expires_in)
        }
    }
    
    /// 用户账号属性<---->外部调用方法
    static private var userAccount: UserAccount?
    class var sharedUserAccount: UserAccount? {
    
        /// 判断账号信息是否存在
        if userAccount == nil {
        
            /// 解档
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
        
        // 保存token等数据
        saveUserAccount()
        
        UserAccount.userAccount = self
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
    }
    
    // 描述对象
    override var description: String {
    
        let properties = ["access_token", "avatar_large", "uid", "expires_in"]
        
        return "\(dictionaryWithValuesForKeys(properties))"
    }
    
    
    // MARK: /**************************** 从服务器获取用户信息并保存 ****************************/
    func loadUserInfoThenSave(finished: (error: NSError?) -> ()) {
    
        NetworkTool.sharedNetworkTool.loadUserInfo { (result, error) -> () in
            
            if error != nil {
            
                // 错误传递
                finished(error: error)
                return
            }
            
            // 存储用户信息
            UserAccount.userAccount!.name = result!["name"] as? String
            UserAccount.userAccount!.avatar_large = result!["avatar_large"] as? String
            
            self.saveUserAccount()
            
            finished(error: nil)
        }
    }
    
    // MARK:  /**************************** 存储模型数据至document ****************************/
    /// 归档
    func saveUserAccount() {
    
        NSKeyedArchiver.archiveRootObject(self, toFile: UserAccount.accountPath)
    }
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeDouble(expires_in, forKey: "expires_in")
        aCoder.encodeObject(expiresDate, forKey: "expiresDate")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
    }
    
    /// 解档
    required init?(coder aDecoder: NSCoder) {
        
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expires_in = aDecoder.decodeDoubleForKey("expires_in")
        expiresDate = aDecoder.decodeObjectForKey("expiresDate") as? NSDate
        uid = aDecoder.decodeObjectForKey("uid") as? String
        name = aDecoder.decodeObjectForKey("name") as? String
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
    }
    
    // MARK: [---------------------- name ----------------------
    
    
}
