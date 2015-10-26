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
        addChildViewController(homeVC, title: "首页", imageName: "tabbar_home", selImageName: "tabbar_home_highlighted")
        
        // 消息
        let messageVC = YHHomeController()
        addChildViewController(messageVC, title: "消息", imageName: "tabbar_message_center", selImageName: "tabbar_message_center_highlighted")
        
        // 发现
        let discoverVC = YHHomeController()
        addChildViewController(discoverVC, title: "发现", imageName: "tabbar_discover", selImageName: "tabbar_discover_highlighted")
        
        // 我
        let profileVC = YHHomeController()
        addChildViewController(profileVC, title: "我", imageName: "tabbar_profile", selImageName: "tabbar_profile_highlighted")
        
    }
    
    /// 设置子控制器
    private func addChildViewController(controller: UIViewController, title: String, imageName: String, selImageName: String) {
        
        controller.title = title
        controller.tabBarItem.image = UIImage(named: imageName)
        controller.tabBarItem.selectedImage = UIImage(named: selImageName)
        let nav = UINavigationController(rootViewController: controller)
        addChildViewController(nav)
    }

}
