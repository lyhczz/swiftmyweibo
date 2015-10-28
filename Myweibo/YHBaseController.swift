//
//  YHBaseController.swift
//  Myweibo
//
//  Created by mposthh on 15/10/27.
//  Copyright © 2015年 mposhh. All rights reserved.
//

import UIKit

class YHBaseController: UITableViewController {

    var userLogin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    override func loadView() {
        
        userLogin ? super.loadView() : setupVistorView()
        
    }
    /// 设置访客视图
    private func setupVistorView() {
        let vistorView = YHVistorView()
        view = vistorView
       
        
        if self is YHHomeController {
            vistorView.startRotationAnimation()
        }else if self is YHMessageController {
            vistorView.setupInfo("visitordiscover_image_message", titlt: "登录后，别人评论你的微博，发给你的消息，都会在这里收到通知")
        } else if self is YHDiscoverController {
            vistorView.setupInfo("visitordiscover_image_message", titlt: "登录后，最新、最热微博尽在掌握，不再会与实事潮流擦肩而过")
        } else if self is YHProfileController {
            vistorView.setupInfo("visitordiscover_image_profile", titlt: "登录后，你的微博、相册、个人资料会显示在这里，展示给别人")
        }
        // 成为代理
        vistorView.vistorViewDelegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: "vistorViewWillRegister")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登陆", style: UIBarButtonItemStyle.Plain, target: self, action: "vistorViewWillLogin")
    }
}

// MARK: - CZBaseTableViewController 扩展,实现 CZVistorViewDelegate 协议
extension YHBaseController: YHVistorViewDelegate {
    
    func vistorViewWillLogin() {
        print(__FUNCTION__)
    }
    
    func vistorViewWillRegister() {
        print(__FUNCTION__)
    }
}






