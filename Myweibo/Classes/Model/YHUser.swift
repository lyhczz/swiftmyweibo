//
//  YHUser.swift
//  Myweibo
//
//  Created by mposthh on 15/10/31.
//  Copyright © 2015年 mposhh. All rights reserved.
//

import UIKit

class YHUser: NSObject {

    // MARK: - 属性
    
    
    /// 用户UID
    var id: Int = 0
    
    /// 友好显示名称
    var name: String?
    
    /// 用户头像地址（中图），50×50像素
    var profile_image_url: String?
    
    /// 是否是微博认证用户，即加V用户，true：是，false：否
    var verified: Bool = false
    
    /// verified_type -1:没有认证 0:认证用户 2,3,5: 企业认证，220: 达人
    var verified_type: Int = -1
    /// 认证类型图片
    var verifiedTyperImage: UIImage? {
        // 认证图标
            switch verified_type {
            case 0:
               return UIImage(named: "avatar_vip")
            case 2,3,5:
               return UIImage(named: "avatar_enterprise_vip")
            case 220:
                return UIImage(named: "avatar_grassroot")
            default:
                return nil
            }
    }
    
    /// 会员等级 1-6
    var mbrank: Int = 0
    /// 会员等级图片
    var mbrankImage: UIImage? {
        if mbrank > 0 && mbrank <= 6 {
            return UIImage(named: "common_icon_membership_level\(mbrank)")
        }
        return nil
    }
    
    // MARK: - 字典转模型
    init(dict: [String: AnyObject]) {
        super.init()
        
        // kvc赋值
        setValuesForKeysWithDictionary(dict)
    }
    // 字典的key找不到属性时调用
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    // 打印对象
    override var description: String {
        let properties = ["id", "name", "profile_image_url", "verified_type", "mbrank"]
        return "\n\t\t:用户模型:\(dictionaryWithValuesForKeys(properties))\n"
    }
    
    
}
