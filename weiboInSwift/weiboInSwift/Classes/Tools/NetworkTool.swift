//
//  NetworkTool.swift
//  weiboInSwift
//
//  Created by 逗叔 on 15/9/7.
//  Copyright © 2015年 逗叔. All rights reserved.
//

import UIKit
import AFNetworking

private let DSErrorDomainName = "com.itheima.error.network"

/// 错误枚举
private enum DSNetworkError: Int {

    // 空数据错误
    case emptyDataError = -1
    // 授权为空
    case emptyTokenError = -2
    
    /// 错误描述
    private var errorDescription: String {
    
        switch self {
        
        case .emptyDataError: return "空数据"
        case .emptyTokenError: return "没有拿到授权"
        }
    }
    
    /// 根据枚举类型, 返回对应的错误
    private func error() -> NSError {
    
        return NSError(domain: DSErrorDomainName, code: rawValue, userInfo: [DSErrorDomainName: errorDescription])
    }
    
}

/// 网络访问方法
private enum DSNetworkMethod: String {

    case GET = "GET"
    case POST = "POST"
}



class NetworkTool: AFHTTPSessionManager {
    
    // MARK: - |----------------------------- 属性 -----------------------------|
    // 授权
    private let client_id = "470245058"
    private let client_secret = "ec982ae6c58a7925d235cc97eccdd708"
    let redirect_uri = "http://www.baidu.com"
    
    
    // MARK: - |----------------------------- 初始化函数 -----------------------------|
    // 单例
    static let sharedNetworkTool: NetworkTool = {
    
        let baseURL: NSURL = NSURL(string: "https://api.weibo.com/")!
        let net = NetworkTool(baseURL: baseURL)
        
        // 添加数据解析类型
        net.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json", "text/json", "text/javascript", "text/plain") as Set<NSObject>
        
        return net
    }()
    
    
    
    // MARK: - |----------------------------- 加载微博信息 -----------------------------|
    func loadStatus(since_id: Int, max_id: Int ,finished: DSNetFinishedCallBack) {
    
        // guard 守卫
        guard var params = tokenDict(finished) else {
        
            return
        }
        
        if since_id > 0 {
        
            params["since_id"] = since_id
        }
        
        if max_id > 0 {
        
            params["max_id"] = max_id
        }
        
        let urlString = "2/statuses/home_timeline.json"
        
        request(DSNetworkMethod.GET, URLString: urlString, parameters: params, finished: finished)
    }
    
    // 检查并生成 token 字典
    private func tokenDict(finished: DSNetFinishedCallBack) -> [String: AnyObject]? {
    
        if UserAccount.sharedUserAccount?.access_token == nil {
            
            // 错误回调, token为空
            let error = DSNetworkError.emptyTokenError.error()
            print(error)
            finished(result: nil, error: error)
            return nil
        }
        
        return ["access_token": UserAccount.sharedUserAccount!.access_token!]
    }
    
    
    // MARK: - ----------------------------- 上传一条微博 -----------------------------
    func updateStatuses(statusText: String, image: UIImage?, finished: DSNetFinishedCallBack) {
        
        let URLString = "https://api.weibo.com/2/statuses/update.json"
        
        guard var param = tokenDict(finished) else {
        
            return
        }
        
        param["status"] = statusText
        
        if image == nil {
        
            request(DSNetworkMethod.POST, URLString: URLString, parameters: param, finished: finished)
        } else {
        
            uploadImage("https://upload.api.weibo.com/2/statuses/upload.json", image: image!, params: param, finished: finished)
        }
        
        
    }
    
    // MARK: - ----------------------------- 加载用户信息 -----------------------------
    func loadUserInfo(finished: DSNetFinishedCallBack) {
        
        // 判断access_token是否存在
        let uid = UserAccount.sharedUserAccount?.uid
        guard var param = tokenDict(finished) else  {
        
            return
        }
        
        let URLString = "2/users/show.json"

        param["uid"] = uid
        
        request(DSNetworkMethod.GET, URLString: URLString, parameters: param, finished: finished)
    }
    
    
    
    // MARK: - |----------------------------- 授权函数 -----------------------------|
    // 授权地址
    func oauthURL() -> NSURL {
    
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(client_id)&redirect_uri=\(redirect_uri)"
        
        print("授权地址->\(urlString)")
        
        return NSURL(string: urlString)!
    }
    // 加载token
    func loadToken(code: String, finished: (result: [String: AnyObject]?, error: NSError?) -> ()) {
    
        let urlString = "https://api.weibo.com/oauth2/access_token"
        let params = [  "client_id":        client_id,
                        "client_secret":    client_secret,
                        "grant_type":       "authorization_code",
                        "code":             code,
                        "redirect_uri":     redirect_uri]
        
        request(DSNetworkMethod.POST, URLString: urlString, parameters: params, finished: finished)
    }
    
    
    
    // MARK: - |----------------------------- 对AFN网络请求的封装 -----------------------------|
    typealias DSNetFinishedCallBack = (result: [String : AnyObject]?, error: NSError?) -> ()
    
    private func request(method: DSNetworkMethod, URLString: String, parameters: [String: AnyObject], finished: DSNetFinishedCallBack) {
        
        let successCallBack: (NSURLSessionDataTask!, AnyObject!) -> Void = {(_, JSON) -> Void in
            
            if let json = JSON as? [String : AnyObject] {
                
                // 完成回调
                finished(result: json, error: nil)
            } else {
                
                print("没有错误, 也没有结果 GETRquest \(URLString)")
                
                let error = DSNetworkError.emptyDataError.error()
                
                // 没有错误, 同时也没有结果
                finished(result: nil, error: error)
            }
            
        }
        
        let failedCallBack: (NSURLSessionDataTask!, NSError!) -> Void = {
        
            (_, error) -> Void in
            
            // 跟踪错误
            finished(result: nil, error: error)
        }
    
        switch method {
        
            case .GET:
                GET(URLString, parameters: parameters, success: successCallBack, failure: failedCallBack)
            case .POST:
                POST(URLString, parameters: parameters, success: successCallBack, failure: failedCallBack)
        }
    }
    
    /// 上传图像
    private func uploadImage(urlString: String, image: UIImage, params: [String : AnyObject], finished: DSNetFinishedCallBack) {
    
        
        let successCallBack: (NSURLSessionDataTask!, AnyObject!) -> Void = {(_, JSON) -> Void in
            
            if let json = JSON as? [String : AnyObject] {
                
                // 完成回调
                finished(result: json, error: nil)
            } else {
                
                print("没有错误, 也没有结果 GETRquest \(urlString)")
                
                let error = DSNetworkError.emptyDataError.error()
                
                // 没有错误, 同时也没有结果
                finished(result: nil, error: error)
            }
            
        }
        
        let failedCallBack: (NSURLSessionDataTask!, NSError!) -> Void = {
            
            (_, error) -> Void in
            
            // 跟踪错误
            finished(result: nil, error: error)
        }
        
        POST(urlString, parameters: params, constructingBodyWithBlock: { (formData) -> Void in
            
            let data = UIImagePNGRepresentation(image)
            
            formData.appendPartWithFileData(data!, name: "pic", fileName: "xxx", mimeType: "application/octet-stream")
            }, success: successCallBack, failure: failedCallBack)
        
    }

    
}
