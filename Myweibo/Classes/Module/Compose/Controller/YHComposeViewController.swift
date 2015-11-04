//
//  YHComposeViewController.swift
//  Myweibo
//
//  Created by mposthh on 15/11/4.
//  Copyright © 2015年 mposhh. All rights reserved.
//

import UIKit

class YHComposeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置背景色
        view.backgroundColor = UIColor.whiteColor()
        
        prepareUI()
    }
    
    // MARK: - 准备UI
    private func prepareUI() {
        // 设置导航栏
        setupNavigationBar()
        // 设置toolBar
        setupToolBar()
        // 设置textView
        setupTextView()
    }
    
    
    /// 设置导航栏
    private func setupNavigationBar() {
        // 左边导航栏
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: "close")
        
        // 右边导航栏
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: UIBarButtonItemStyle.Plain, target: self, action: "sendStatus")
        // 发送不可用
        navigationItem.rightBarButtonItem?.enabled = false
        
        // 设置导航栏标题
        setupNavTitle()
        
    }
    /// 设置导航栏标题
    private func setupNavTitle() {
        
        // 前缀
        let prefix = "发微博"
        
        // 判断是否有用户名称
        if let name = YHUserAccount.loadAccount()?.name {
            // 拼接用户名称
            let titleText = prefix + "\n" + name
            
            // 创建label
            let label = UILabel()
            
            // 换行
            label.numberOfLines = 0
            // 居中
            label.textAlignment = NSTextAlignment.Center
            
            // 创建属性文本
            let attrString = NSMutableAttributedString(string: titleText)
            
            // 添加属性
            // 发微博三个字
            let range = (titleText as NSString).rangeOfString(prefix)
            attrString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(14), range: range)
            
            // 名字属性
            let nameRange = (titleText as NSString).rangeOfString(name)
            attrString.addAttributes([NSFontAttributeName: UIFont.systemFontOfSize(11),NSForegroundColorAttributeName: UIColor.lightGrayColor()], range: nameRange)
            
            // 设置文本
            label.attributedText = attrString
            
            label.sizeToFit()
            navigationItem.titleView = label
            
        } else {
            // 没有用户名称,直接显示发微博
            navigationItem.title = prefix
        }
    }
    
    /// 设置ToolBar
    private func setupToolBar() {
        // 添加子控件
        view.addSubview(toolBar)
        
        // 添加约束
        toolBar.ff_AlignInner(type: ff_AlignType.BottomLeft, referView: view, size: CGSize(width: UIScreen.width(), height: 44))
        
        // 创建toolBar上的items
        var items = [UIBarButtonItem]()
        
        // 每个item对应的图片名称
        let itemSettings = [["imageName": "compose_toolbar_picture", "action": "picture"],
            ["imageName": "compose_trendbutton_background", "action": "trend"],
            ["imageName": "compose_mentionbutton_background", "action": "mention"],
            ["imageName": "compose_emoticonbutton_background", "action": "emoticon"],
            ["imageName": "compose_addbutton_background", "action": "add"]]
        
        // 遍历itemSettings 创建UIBarButtonItem
        for dict in itemSettings {
            // 获得图片名称
            let imageName = dict["imageName"]!
            // 获取点击事件的名称
            let action = dict["action"]!
            // 创建item
            let item = UIBarButtonItem(imageName: imageName)
            
            // 添加事件
            let button = item.customView as! UIButton
            button.addTarget(self, action: Selector(action), forControlEvents: UIControlEvents.TouchUpInside)
            
            // 添加到数组
            items.append(item)
            
            // 添加弹簧
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
        }
        // 移除最后一根弹簧
        items.removeLast()
        
        toolBar.items = items
    }
    
    /// 设置textView
    private func setupTextView() {
        // 添加子控件
        view.addSubview(textView)
        
        // 添加约束
        textView.ff_AlignInner(type: ff_AlignType.TopLeft, referView: view, size: nil)
        textView.ff_AlignVertical(type: ff_AlignType.TopRight, referView: toolBar, size: nil)
    }
    
    
    
    // MARK: - 懒加载
    private lazy var toolBar: UIToolbar = {
       
        let toolBar = UIToolbar()
        
        // 设置背景
        toolBar.backgroundColor = UIColor(white: 0.8, alpha: 1)
        
        return toolBar
    }()
    
    private lazy var textView: UITextView = {
        // 创建
        let textView = UITextView()
        // 设置背景
        textView.backgroundColor = UIColor.brownColor()
        // 设置contentInset
        textView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        textView.alwaysBounceVertical = true
        textView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        return textView
        
    }()
    
    // MARK: - 按钮点击事件
    // toolBar点击事件
    func picture() {
        print("图片")
    }
    func trend() {
        print("#")
    }
    func mention() {
        print("@")
    }
    func emoticon() {
        print("表情")
    }
    func add() {
        print("加号")
    }
    
    // 导航栏按钮点击事件
    // 取消
    @objc private func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    // 发送
    @objc private func sendStatus() {
        print(__FUNCTION__)
    }
}
