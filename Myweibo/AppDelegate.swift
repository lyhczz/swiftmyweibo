//
//  AppDelegate.swift
//  Myweibo
//
//  Created by mposthh on 15/10/26.
//  Copyright © 2015年 mposhh. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // 创建window
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        
//        window?.rootViewController = YHTabBarController()
//        window?.rootViewController = YHWelconeViewController()
        window?.rootViewController = YHNewFeatureViewController()

        
        setupAppearance()
        
        // 设置为主窗口
        window?.makeKeyAndVisible()
        return true
    }

    /// 设置全局外观
    private func setupAppearance() {
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        UITabBar.appearance().tintColor = UIColor.orangeColor()
    }

}

