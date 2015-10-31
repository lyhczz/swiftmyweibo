//
//  YHStatus.swift
//  Myweibo
//
//  Created by mposthh on 15/10/31.
//  Copyright © 2015年 mposhh. All rights reserved.
//

import UIKit

class YHStatus: NSObject {

    // MARK: - 属性
    /// 微博创建时间
    var created_at: String?
    
    /// 微博ID
    var id: Int = 0
    
    /// 微博信息内容
    var text: String?
    
    /// 微博来源
    var source: String?
    
    /// 图片地址数组
    var pic_urls: [[String: AnyObject]]?
    
    /// 字典转模型
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC赋值
        setValuesForKeysWithDictionary(dict)
    }
    
    // 处理字典的key在模型中没有对应的属性
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    // 打印对象
    override var description: String {
        let porperties = ["id", "created_at", "source", "text", "pic_urls"]
        
        return "\(dictionaryWithValuesForKeys(porperties))"
    }
    
    // MARK: - 加载模型数据
    /// 加载模型数据
    class func loadStatus(finshed:(list: [YHStatus]?,error: NSError?) -> ())  {
    
        // 利用网络工具类下载数据
        Networktools.shareInstance.loadStatus { (result, error) -> () in
            // 判断是否出错
            if error != nil {
                print("加载微博数据出错..\(error)")
                finshed(list: nil, error: error)
                return
            }
            
            // 没出错，获取数据
            if let array = result?["statuses"] as? [[String: AnyObject]] {
                // 创建模型数组
                var list = [YHStatus]()
                
                // 字典转模型
                for dict in array {
                    list.append(YHStatus(dict: dict))
                }
                // 返回数据
                finshed(list: list, error: nil)
            } else {
                // 没有加载到数据
                finshed(list: nil, error: nil)
            }
        }
    }
    
    
}






