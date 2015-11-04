//
//  Networktools.swift
//  Myweibo
//
//  Created by mposthh on 15/10/28.
//  Copyright © 2015年 mposhh. All rights reserved.
//

import UIKit
import AFNetworking

// MARK: - 网络错误枚举
enum YHNetWorkError: Int {
    case emptyToken = -1
    case emptyUid = -2
    
    var description: String {
        
        // 根据枚举的类型返回对应的错误
        get {
            switch self {
            case YHNetWorkError.emptyToken:
                return "access token 为空"
            case YHNetWorkError.emptyUid:
                return "uid 为空"
            }
        }
    }
    func error() -> NSError {
        return NSError(domain: "cn.czz.error.network", code: rawValue, userInfo: ["errorDescription" : description])
    }
}


class Networktools: NSObject {

    
    // MARK: - 属性
    /// AFN 
    private var afManager: AFHTTPSessionManager
    // 实现单例
    static let shareInstance: Networktools = Networktools()
    
    override init() {
        let baseURL = NSURL(string: "https://api.weibo.com/")
        afManager = AFHTTPSessionManager(baseURL: baseURL)
        // 设置反序列化数据格式集合(不然服务器会返回错误，因为AFN不支持text/plain)
        afManager.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json", "text/json", "text/javascript", "text/plain") as Set<NSObject>
        super.init()

    }
    
    
//    https://api.weibo.com/oauth2/authorize?client_id=4026003161&redirect_uri=https://www.baidu.com/
    //:MARK Oauth授权
    private let client_id = "4026003161"
    private let client_secret = "b4cabed58eda0e8fcc60b4c6e769ef07"
    let redirect_uri = "https://www.baidu.com/"
    let grant_type = "authorization_code"
    
    /// 授权的url
    func oauthUrl() -> NSURL {
        let str = "https://api.weibo.com/oauth2/authorize?client_id=\(client_id)&redirect_uri=\(redirect_uri)"
        
        return NSURL(string: str)!
    }
    
    // MARK: - 加载Access token
    /// 加载Access token
    func loadAccessToken(code: String,finshed: NetworkFinishedCallback) {
        let URLString = "oauth2/access_token"
        let parameters = [
            "client_id": client_id,
            "client_secret": client_secret,
            "redirect_uri": redirect_uri,
            "grant_type": grant_type,
            "code": code
        ]
        // 发送请求
        afManager.POST(URLString, parameters: parameters, success: { (_, result) -> Void in
            // 回调
            finshed(result: result as? [String: AnyObject], error: nil)
            
            }) { (result, error) -> Void in
                
                finshed(result: nil, error: error)
                print(result)
        }
    }
    
    
    // MARK: - 加载用户数据
    /// 加载用户数据，负责获取数据
    func loadUserInfo(finshed: NetworkFinishedCallback) {
        // 判断access.token是否存在
        guard var parameters = tokenDict() else {
            // 将错误告诉调用者
            let error = YHNetWorkError.emptyToken.error()
            finshed(result: nil, error: error)
            return
        }
        // 判断uid是否存在
        if YHUserAccount.loadAccount()?.uid == nil {
            // 将错误告诉调用者
            let error = YHNetWorkError.emptyUid.error()
            finshed(result: nil, error: error)
            return
        }
        // url
        let urlString = "2/users/show.json"
        // 参数
        parameters = ["uid": YHUserAccount.loadAccount()!.uid!]
        // 用GET发送请求
        requestGET(urlString, parameters: parameters, finshed: finshed)
    }
    
    
    // MARK: - 加载微博数据
    /**
    加载微博数据
    - parameter since_id: 加载大于since_id大的微博, 默认为0
    - parameter max_id:   加载小于或等于max_id的微博, 默认为0
    - parameter finished: 回调闭包
    */
    func loadStatus(since_id: Int, max_id: Int, finshed:NetworkFinishedCallback) {
        // 判断access.token是否存在
        guard var parameters = tokenDict() else {
            // 将错误告诉调用者
            let error = YHNetWorkError.emptyToken.error()
            finshed(result: nil, error: error)
            return
        }
        
        // 判断是否有since_id
        if since_id > 0 {
            parameters["since_id"] = since_id
        } else if max_id > 0 {
             // 判断是否传入 max_id
            parameters["max_id"] = max_id - 1
        }
        
        
        // url地址
        let urlString = "2/statuses/home_timeline.json"
        // 发送请求
        requestGET(urlString, parameters: parameters, finshed: finshed)
    }
    
    // MARK: - 封装AFN GET方法
    func requestGET(URLString: String, parameters: AnyObject?,finshed:NetworkFinishedCallback) {
        afManager.GET(URLString, parameters: parameters, success: { (_, result) -> Void in
            finshed(result: result as? [String : AnyObject], error: nil)
            }) { (_, error) -> Void in
               finshed(result: nil, error: error)
        }
    }
    
    /// 判断access token是否有值,没有值返回nil,如果有值生成一个字典
    func tokenDict() -> [String: AnyObject]? {
        if YHUserAccount.loadAccount()?.access_token == nil {
            return nil
        }
        
        return ["access_token": YHUserAccount.loadAccount()!.access_token!]
    }
    // 类型别名
    typealias NetworkFinishedCallback = (result: [String: AnyObject]?, error: NSError?) ->()
    
}





