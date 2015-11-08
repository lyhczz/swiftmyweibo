//
//  YHEmoticons.swift
//  表情键盘
//
//  Created by mposthh on 15/11/6.
//  Copyright © 2015年 mposhh. All rights reserved.
//

import UIKit


/// 表情包模型
class YHEmoticonPackage: NSObject {
    
    // MARK: - 属性
    private static let bundlePath = NSBundle.mainBundle().pathForResource("Emoticons", ofType: "bundle")!
    
    /// 表情包文件夹名称
    var id: String?
    
    /// 表情包名称
    var group_name_cn: String?
    
    /// 表情模型数组
    var emoticons: [YHEmoticon]?
    
    // 每次从磁盘加载表情包耗性能,第一次从本地加载表情包数据,保存到内存中.以后重内存中加载
    static let packages = YHEmoticonPackage.loadPackages()
    
    /// 对象打印方法
    override var description: String {
        return "表情包模型: id:\(id), group_name_cn:\(group_name_cn), emoticons:\(emoticons)"
    }
    
    /// 构造方法,通过表情包路径
    init(id: String) {
        self.id = id
        super.init()
    }
    
    
    // MARK: - 外部方法
    /**
    加载所有的表情包
    - returns: 表情包数组
    */
    class func loadPackages() -> [YHEmoticonPackage] {
        // 加载 Emoticons.bundle/emoticons.plist文件
        
        let plistPath = (bundlePath as NSString).stringByAppendingPathComponent("emoticons.plist")
        
        // 加载emoticons.plist里面的内容
        let empticonDict = NSDictionary(contentsOfFile: plistPath)!
        
        // 获取packages数组
        let packageArr = empticonDict["packages"] as! [[String: AnyObject]]
        
        // 定义表情包数组
        var packages = [YHEmoticonPackage]()
        
        // 创建 最近 表情包
        let recent = YHEmoticonPackage(id: "")
        
        // 初始化最近表情模型数组
        recent.emoticons = [YHEmoticon]()
        
        // 添加到表情包数组
        packages.append(recent)
        
        // 定义名称
        recent.group_name_cn = "最近"
        
        // 添加空白表情
        recent.appendEmptyEmoticon()
        
        // 遍历packageArr,获得每个表情包的名称
        for dict in packageArr {
            // 取出id
            let id = dict["id"] as! String
            
            // 创建表情包
            let package = YHEmoticonPackage(id: id)
            
            // 加载表情模型
            package.loadEmoticons()
            
            // 添加到数组
            packages.append(package)
        }
        
        return packages
    }
    
    /**
    加载表情包里面的所有表情模型和表情包名称
    */
    func loadEmoticons() {
        // 获取 表情包文件夹/info.plist 内容
        let infoPath = YHEmoticonPackage.bundlePath + "/" + id! + "/info.plist"
    
        // 加载info.plist
        let infoDict = NSDictionary(contentsOfFile: infoPath)!
        
        // 获取表情包名称,赋值给当前表情包模型
        group_name_cn = infoDict["group_name_cn"] as? String
        
        // 获取emticon数组
        let emoticonArr = infoDict["emoticons"] as! [[String: String]]
        
        // 创建表情模型数组
        emoticons = [YHEmoticon]()
        
        // 记录表情在当前页的序号
        var index = 0
        
        // 遍历
        for dict in emoticonArr {
            
            // 字典转模型,添加到数组中
            emoticons?.append(YHEmoticon(id: id,dict: dict))
            
            index++
            
            // 判断是否是最后一个位置
            if index == 20 {
                // 最后一个添加删除按钮
                emoticons?.append(YHEmoticon(removeEmoticon: true))
                // 重置index
                index = 0
            }
        }
        appendEmptyEmoticon()
    }
    
    /// 添加最近表情
    class func addFavorate(emoticon: YHEmoticon) {
        // 不添加删除按钮
        if emoticon.removeEmoticon {
            return
        }
        
        // 使用次数+1
        emoticon.times++
        
        // 获取最近表情包数组
        var recentEmoticonPackage = packages[0].emoticons!
        
        // 移除删除按钮
        let removeEmoticon = recentEmoticonPackage.removeLast()
        
        // 如果最近表情已经存在,不需要重复添加
        let contains = recentEmoticonPackage.contains(emoticon)
        if !contains {
            // 添加表情
            recentEmoticonPackage.append(emoticon)
        }
        
        
        // 排序
        recentEmoticonPackage = recentEmoticonPackage.sort({ (e1, e2) -> Bool in
            return e1.times > e2.times
        })
        
        // 删除一个
        if !contains {
            recentEmoticonPackage.removeLast()
        }
        // 把删除按钮添加回去
        recentEmoticonPackage.append(removeEmoticon)
        
        // 重新赋值回去
        packages[0].emoticons = recentEmoticonPackage
        
    }
    
    /// 添加空白按钮
    private func appendEmptyEmoticon() {
        // 获取最后一页的个数
        let count = emoticons!.count % 21
        
        // count > 0 表示最后一页有 count 个表情, 没满一页. 需要追加空白按钮
        if count > 0 || emoticons!.count == 0 {
            for _ in count..<20 {
                emoticons?.append(YHEmoticon(removeEmoticon: false))
            }
            // 追加删除按钮
            emoticons?.append(YHEmoticon(removeEmoticon: true))
        }
    }
    
}




/// 表情模型
class YHEmoticon: NSObject {

    // MARK: - 属性
    /// 表情名称,用于网络传输
    var chs: String?
    
    /// 表情图片名称, 在手机上显示表情图片
    var png: String?
    
    /// emoji
    var code: String? {
        didSet {
            guard let co = code else {
                // 表示code没有值
                return
            }
            
            let scanner = NSScanner(string: co)
            
            var value: UInt32 = 0
            
            scanner.scanHexInt(&value)
            
            emoji = "\(Character(UnicodeScalar(value)))"
        }
        
    }
    
    /// emoji字符串
    var emoji: String?
    
    /// 表情包文件夹名称
    var id: String?
    
    /// png的全路径
    var pngPath: String? {
        if png == nil {
            return nil
        }
        
        return YHEmoticonPackage.bundlePath + "/" + id! + "/" + png!
    }
    
    /// 是否是删除按钮, true表示删除按钮
    var removeEmoticon: Bool = false
    
    /// 使用次数
    var times = 0
    
    // MARK: - 构造函数
    /// 字典转模型
    init(id: String?, dict: [String: AnyObject]) {
        self.id = id
        super.init()
        
        // KVC
        setValuesForKeysWithDictionary(dict)
    }
    
    /// 只会给removeEmoticon属性赋值
    init(removeEmoticon: Bool) {
        self.removeEmoticon = removeEmoticon
        super.init()
    }
    
    // 字典的key在模型中找不到对应的属性
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    /// 打印对象
//    override var description: String {
//        return "\n\t\t: 表情模型:chs:\(chs), png:\(png), code:\(code)"
//    }
    
}




