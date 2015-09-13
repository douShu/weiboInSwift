//
//  Status.swift
//  weiboInSwift
//
//  Created by 逗叔 on 15/9/10.
//  Copyright © 2015年 逗叔. All rights reserved.
//

import UIKit
import SDWebImage

class Status: NSObject {
    
    
    // MARK: - ----------------------------- 属性 -----------------------------
    
    /// 转发cell
    var retweeted_status: Status?
    
    /// 微博创建时间
    var created_at: String?
    
    /// 微博ID
    var id: Int = 0
    
    /// 微博信息内容
    var text: String?
    
    /// 微博来源
    var source: String?
    
    /// 配图数组
    var pic_urls: [[String: AnyObject]]? {
    
        didSet {
            
            if pic_urls?.count == 0  {
            
                return
            }
            
            // 实例化数组
            pictURLs = [NSURL]()
            
            // 遍历字典
            for dict in pic_urls! {
            
                if let stringURl = dict["thumbnail_pic"] as? String {
                
                    pictURLs?.append(NSURL(string: stringURl)!)
                }
            }
        }
    }
    
    /// 保存配图的URL数组
    private var pictURLs: [NSURL]?
    
    /// 配图的URL的数组
    var pictureURls: [NSURL]? {
    
        return retweeted_status == nil ? pictURLs : retweeted_status?.pictURLs
    }
    
    /// 用户
    var user: User?
    
    var rowHeight: CGFloat?
    
    
    // MARK: - ----------------------------- 构造方法 -----------------------------
    init(dict: [String: AnyObject]) {
        
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    
    // MARK: - ----------------------------- KVC方法 -----------------------------
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
    }
    
    override func setValue(value: AnyObject?, forKey key: String) {
        
        if key == "user" {
            
            if let dict = value as? [String: AnyObject] {
            
                 user = User(dict: dict)
            }
            return
        }
        
        if key == "retweeted_status" {
        
            if let dict = value as? [String : AnyObject]  {
            
                retweeted_status = Status(dict: dict)
            }
            return
        }
        
        super.setValue(value, forKey: key)
    }
    
    // MARK: - ----------------------------- 字典转模型 -----------------------------
    class func loadLists(finished: (lists: [Status]?, error: NSError?) -> ()) {
    
        NetworkTool.sharedNetworkTool.loadStatus { (result, error) -> () in
            
            if error != nil {
            
                finished(lists: nil, error: error)
                return
            }
            
            if let dict = result {
                
                let array = dict["statuses"] as! NSArray
                
                var lists = [Status]()
                
                // 遍历数组
                for dict2 in array {
                    
                    let status = Status(dict: dict2 as! [String : AnyObject])
                    
                    lists.append(status)
                }
                
                // 缓存图片
                cacheWebimage(lists, finished: finished)
            } else{
            
                finished(lists: nil, error: nil)
            }
        }
    }
    
    private class func cacheWebimage(lists: [Status], finished: (lists: [Status]?, error: NSError?) -> ()) {
    
        // 创建调度组
        let group = dispatch_group_create()
        var imageLength = 0
        
        // 遍历循环lists
        for status in lists {
        
            guard let urls = status.pictureURls else {
            
                continue
            }
            
            
            for url in urls {
            
                // 入组
                dispatch_group_enter(group)
                SDWebImageManager.sharedManager().downloadImageWithURL(url, options: SDWebImageOptions(rawValue: 0), progress: nil, completed: { (image, _, _, _ , _ ) -> Void in
                    
                   // 将图片转化为二进制
                    let data = UIImagePNGRepresentation(image)
                    imageLength += data!.length
                    
                    dispatch_group_leave(group)
                })
            }
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
            
            print("缓存图片大小: \(imageLength / 1024)")
            
            finished(lists: lists, error: nil)
        }
    }
    
    override var description: String {
        
        let keys = ["created_at", "id", "text", "source", "pic_urls"]
        
        return "\(dictionaryWithValuesForKeys(keys))"
    }

}
