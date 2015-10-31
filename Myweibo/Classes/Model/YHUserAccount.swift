//
//  YHUserAccount.swift
//  Myweibo
//
//  Created by mposthh on 15/10/29.
//  Copyright © 2015年 mposhh. All rights reserved.
//

import UIKit

class YHUserAccount: NSObject, NSCoding {

    // MARK: 属性
    /// 接口授权后获取的access_token
    var access_token: String?
    /// 当前授权用户的uid
    var uid: String?
    /// 过期日期
    var expiresDate: NSDate?
    /// access_token的生命周期，单位是秒
    var expires_in:NSTimeInterval = 0 {
        didSet {
            self.expiresDate = NSDate(timeIntervalSinceNow: expires_in)
        }
    }
    /// 友好显示名称
    var name: String?
    /// 用户头像地址180*180
    var avatar_large: String?
    
    override var description: String {
        let properties = ["access_token", "expires_in", "expiresDate", "uid","name","avatar_large"]
        return "\(dictionaryWithValuesForKeys(properties))"
    }
    /// 返回是否有账号
    class func userLogin() -> Bool {
        return YHUserAccount.loadAccount() != nil
    }
    
    // MARK: - 构造方法
    /// 字典转模型
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    
    
    // 当字典的key在模型中没有找到对应的属性时
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    
    // MARK: - 保存对象和加载对象
    /// 归档路径 定义成static类方法才能访问
    static let accountPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last! + "/Account.plist"
    /// 保存对象
    func saveAccount() {
        NSKeyedArchiver.archiveRootObject(self, toFile: YHUserAccount.accountPath)
        print(YHUserAccount.accountPath)
    }
    
    // 静态属性
    private static var userAccount: YHUserAccount?
    /// 加载对象
    class func loadAccount() -> YHUserAccount? {
//        if let account = NSKeyedUnarchiver.unarchiveObjectWithFile(accountPath) as? YHUserAccount {
//            // 判断数据是否过期
//            if account.expiresDate?.compare(NSDate()) == NSComparisonResult.OrderedDescending {
//                // 没有过期
//                return account
//            }
//        }
        if userAccount == nil {
            // 不存在，解档，但是仍然可能为空
            userAccount = NSKeyedUnarchiver.unarchiveObjectWithFile(accountPath) as? YHUserAccount
        }
        if userAccount != nil && userAccount?.expiresDate?.compare(NSDate()) == NSComparisonResult.OrderedDescending {
//            print("有效账户")
            return userAccount
        }
        
        // 数据已过期，返回nil
        return nil
    }
    
    // MARK: - 加载用户信息
    // https://api.weibo.com/2/users/show.json?access_token=2.00A4b3DCr1h95E9f4640c35b_G5BVC&uid=1881981542
    // 加载和处理用户信息
    func loadUeserInfo(finshed:(erroe: NSError?) -> ()) {
        Networktools.shareInstance.loadUserInfo { (result, error) -> () in
            // 加载失败
            if error != nil || result == nil {
                finshed(erroe: error)
                return
            }
            // 加载成功
            self.name = result!["name"] as? String
            self.avatar_large = result!["avatar_large"] as? String
            // 保存数据
            self.saveAccount()
            
            // 同步到内存
            YHUserAccount.userAccount = self
            
            finshed(erroe: nil)
            
        }
    }
    
    
    
    
    // MARK: - 归档和解档
    /// 归档
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(expiresDate, forKey: "expiresDate")
        aCoder.encodeDouble(expires_in, forKey: "expires_in")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
    }
    
    /// 解档
    required init?(coder aDecoder: NSCoder) {
        access_token = (aDecoder.decodeObjectForKey("access_token") as! String)
        uid = (aDecoder.decodeObjectForKey("uid") as! String)
        expiresDate = (aDecoder.decodeObjectForKey("expiresDate") as! NSDate)
        expires_in = aDecoder.decodeDoubleForKey("expires_in")
        name = aDecoder.decodeObjectForKey("name") as? String
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
    }
}
