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
        
        
        window?.rootViewController = YHTabBarController()
        
        // 设置为主窗口
        window?.makeKeyAndVisible()
        return true
    }



}

