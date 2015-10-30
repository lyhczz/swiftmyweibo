//
//  Networktools.swift
//  Myweibo
//
//  Created by mposthh on 15/10/28.
//  Copyright © 2015年 mposhh. All rights reserved.
//

import UIKit
import AFNetworking

class Networktools: AFHTTPSessionManager {

    // 实现单例
    static let shareInstance: Networktools = {
        let baseURL = NSURL(string: "https://api.weibo.com/")
        let tools = Networktools(baseURL: baseURL)
        
        // 设置反序列化数据格式集合(不然服务器会返回错误，因为AFN不支持text/plain)
        tools.responseSerializer.acceptableContentTypes?.insert("text/plain")
        return tools
    }()
    
    
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
    func loadAccessToken(code: String,finshed: (result:[String: AnyObject]?,error: NSError?) -> ()) {
        let URLString = "oauth2/access_token"
        let parameters = [
            "client_id": client_id,
            "client_secret": client_secret,
            "redirect_uri": redirect_uri,
            "grant_type": grant_type,
            "code": code
        ]
        // 发送请求
        POST(URLString, parameters: parameters, success: { (_, result) -> Void in
            // 回调
            finshed(result: result as? [String: AnyObject], error: nil)
            
            }) { (result, error) -> Void in
                
                finshed(result: nil, error: error)
                print(result)
        }
    }
    
    // MARK: - 加载用户数据
    /// 加载用户数据，负责获取数据
    func loadUserInfo(finshed:(result: [String:AnyObject]?,error: NSError?) -> ()) {
        // 判断access.token是否存在
        if YHUserAccount.loadAccount()?.access_token == nil {
            print("没有access_token")
            return
        }
        
        // 判断uid是否存在
        if YHUserAccount.loadAccount()?.uid == nil {
            print("没有UID")
            return
        }
        
        // url
        let urlString = "2/users/show.json"
        // 参数
        let parameters = ["access_token": YHUserAccount.loadAccount()!.access_token!,"uid": YHUserAccount.loadAccount()!.uid!]
        // 用GET发送请求
        GET(urlString, parameters: parameters, success: { (_, result) -> Void in
            finshed(result: result as? [String : AnyObject], error: nil)
            }) { (_, error) -> Void in
                finshed(result: nil, error: error)
        }
    }
    
}





