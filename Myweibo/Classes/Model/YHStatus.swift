//
//  YHStatus.swift
//  Myweibo
//
//  Created by mposthh on 15/10/31.
//  Copyright © 2015年 mposhh. All rights reserved.
//

import UIKit
import SDWebImage

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
    var pic_urls: [[String: AnyObject]]? {
        didSet {
            // 判断pic_urls是否有值,没有值直接返回
            let count = pic_urls?.count ?? 0
            if count == 0 {
                return
            }
            
            // 有值,遍历将pic_urls 里的string转成NSURL存放在pictureURLs数组里面
            storePictureURLs = [NSURL]()
            for dict in pic_urls! {
                let value = dict["thumbnail_pic"] as! String
                storePictureURLs?.append(NSURL(string: value)!)
            }
        }
    }
    /// 存储型属性,存储的是pic_urls里面对应的URL
    var pictureURLs: [NSURL]? {
        // 原创微博返回:storePictureURLs
        // 转发微博返回:retweeted_status.storePictureURLs
        return retweeted_status == nil ? storePictureURLs : retweeted_status!.storePictureURLs
    }
    
    /// 存储型属性,存储的是原创微博图片的URL
    var storePictureURLs: [NSURL]?
    
    /// 用户模型
    var user: YHUser?
    
    
    
    /// 行高属性
    var rowHeight: CGFloat?
    
    /// 被转发的微博
    var retweeted_status: YHStatus?
    
    // MARK: - 构造方法
    /// 字典转模型
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC赋值
        setValuesForKeysWithDictionary(dict)
    }
    
    // 处理字典的key在模型中没有对应的属性
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    /// KVC赋值时
    override func setValue(value: AnyObject?, forKey key: String) {
        // 对user属性特殊处理
        if key == "user" {
            if let dict = value as? [String: AnyObject] {
                // 字典转模型
                user = YHUser(dict: dict)
            }
            return
        }
        
        // 对retweeted_status属性特殊处理
        if key == "retweeted_status" {
            if let dict = value as? [String: AnyObject] {
                retweeted_status = YHStatus(dict: dict)
            }
            return
        }
        super.setValue(value, forKey: key)
    }
    
    // 打印对象
    override var description: String {
        let porperties = ["id", "created_at", "source", "text", "pic_urls","user"]
        
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
//                finshed(list: list, error: nil)
                // 先缓存图片,在调用闭包
                cacheWebImage(list, finshed: finshed)
                
            } else {
                // 没有加载到数据
                finshed(list: nil, error: nil)
            }
        }
    }
    
    class func cacheWebImage(lists: [YHStatus],finshed:(list: [YHStatus]?,error: NSError?) -> ()) {
        
        // 定义任务组
        let group = dispatch_group_create()
        // 记录下载图片的大小
        var length = 0
        
        // 遍历模型数组
        for status in lists {
            // 获取模型里面的配图url
            guard let urls = status.pictureURLs else {
                // 如果没有图片,遍历下一个模型
                continue
            }
            
            // 缓存单张图片
            if urls.count == 1 {
                // 获得单张图片的url
                let url = urls[0]
                
                // 进入任务组
                dispatch_group_enter(group)
                // 使用SDWebImage下载图片
                SDWebImageManager.sharedManager().downloadImageWithURL(url, options: SDWebImageOptions(rawValue: 0), progress: nil, completed: { (image, error, _, _, _) -> Void in
                    
                    // 离开任务组
                    dispatch_group_leave(group)
                    
                    // 判断是否出错
                    if error != nil {
                        print("下载图片出错")
                        return
                    }
                    
                    // 下载没有出错
                    print("下载完成:\(url)")
                    // 计算下载图片的大小
                    if let data = UIImagePNGRepresentation(image) {
                        length += data.length
                    }
                 })
            }
        }
        // 全部图片下载完成后,通知调用者
        dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
            print("所有图片下载完成:\(length / 1024)k")
            // 返回数据
            finshed(list: lists, error: nil)
        }
        
    }
    
    // MARK: - 外部调用方法
    /// 返回cell的重用id
    func cellID() -> String {
        return retweeted_status == nil ? YHStatusCellReuseIdentifier.NormalCell.rawValue : YHStatusCellReuseIdentifier.ForwarCell.rawValue
    }
    
}







