//
//  YHUserAccount.swift
//  Myweibo
//
//  Created by mposthh on 15/10/29.
//  Copyright © 2015年 mposhh. All rights reserved.
//

import UIKit

class YHUserAccount: NSObject {

    /// 接口授权后获取的access_token
    var access_token: String?
    /// access_token的生命周期，单位是秒
    var expires_in:NSTimeInterval = 0
    /// 当前授权用户的uid
    var uid: String?
    
    /// 字典转模型
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    // 当字典的key在模型中没有找到对应的属性时
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
}
