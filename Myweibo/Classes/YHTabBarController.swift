//
//  YHTabBarController.swift
//  Myweibo
//
//  Created by mposthh on 15/10/26.
//  Copyright © 2015年 mposhh. All rights reserved.
//

import UIKit

class YHTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 添加四个子控制器
        addChildViews()
        
    }

    /// 添加四个子控制器
    private func addChildViews() {
        // 设置颜色
        tabBar.tintColor = UIColor.orangeColor()
        
        // 首页
        let homeVC = YHHomeController()
        addChildViewController(homeVC, title: "首页", imageName: "tabbar_home")
        
        // 消息
        let messageVC = YHMessageController()
        addChildViewController(messageVC, title: "消息", imageName: "tabbar_message_center")
        
        // 占位的按钮
        addChildViewController(UIViewController(), title: "", imageName: "")
        
        // 发现
        let discoverVC = YHDiscoverController()
        addChildViewController(discoverVC, title: "发现", imageName: "tabbar_discover")
        
        // 我
        let profileVC = YHProfileController()
        addChildViewController(profileVC, title: "我", imageName: "tabbar_profile")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // 添加撰写按钮
        let width = tabBar.bounds.width / 5
        composeButton.frame = CGRect(x: width * 2, y: 0, width: width, height: tabBar.bounds.height)
        tabBar.addSubview(composeButton)
    }
    
    /// 设置子控制器
    private func addChildViewController(controller: UIViewController, title: String, imageName: String) {
        
        controller.title = title
        controller.tabBarItem.image = UIImage(named: imageName)
        let nav = UINavigationController(rootViewController: controller)
        addChildViewController(nav)
    }
    
    
    // MARK: - 懒加载
    lazy var composeButton: UIButton = {
        
        let button = UIButton()
        
        // 设置图片
        button.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: UIControlState.Normal)
        button.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        
        // 设置背景图片
        button.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        
        return button
        
    }()

}
