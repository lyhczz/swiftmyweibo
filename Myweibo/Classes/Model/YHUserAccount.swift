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
    
    // MARK: - 构造方法
    /// 字典转模型
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override var description: String {
        let properties = ["access_token", "expires_in", "expiresDate", "uid"]
        return "\(dictionaryWithValuesForKeys(properties))"
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
    
    /// 加载对象
    class func loadAccount() -> YHUserAccount? {
        
        if let account = NSKeyedUnarchiver.unarchiveObjectWithFile(accountPath) as? YHUserAccount {
            // 判断数据是否过期
            if account.expiresDate?.compare(NSDate()) == NSComparisonResult.OrderedDescending {
                // 没有过期
                return account
            }
        }
        // 数据已过期，返回nil
        return nil
        
    }
    
    // MARK: - 归档和解档
    /// 归档
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(expiresDate, forKey: "expiresDate")
        aCoder.encodeObject(expires_in, forKey: "expires_in")
    }
    
    /// 解档
    required init?(coder aDecoder: NSCoder) {
        access_token = (aDecoder.decodeObjectForKey("access_token") as! String)
        uid = (aDecoder.decodeObjectForKey("uid") as! String)
        expiresDate = (aDecoder.decodeObjectForKey("expiresDate") as! NSDate)
        expires_in = aDecoder.decodeDoubleForKey("expires_in")
    }
    
    
    
}
