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
        setupAppearance()
        // 创建window
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        window?.rootViewController = defaultController()
        
        // 设置为主窗口
        window?.makeKeyAndVisible()
        return true
    }
    
    private func defaultController() -> UIViewController {
        if !YHUserAccount.userLogin() {
            return YHTabBarController()
        }
        
        // 判断是否为最新版本
        return isNewVersion() ? YHNewFeatureViewController() : YHWelconeViewController()
    }
    
    
    /// 判断是否为新版本
    private func isNewVersion() -> Bool {
        // 获得当前版本号
        let versionString = NSBundle.mainBundle().infoDictionary! ["CFBundleShortVersionString"] as! String
        let currentVersion = Double(versionString)!
        print("currentVersion:\(currentVersion)")
        
        // 获取之前的版本号
        let sandboxVersionKey = "sandboxVersionKey"
        let sandboxVersion = NSUserDefaults.standardUserDefaults().doubleForKey(sandboxVersionKey)
        print("sandboxVersion:\(sandboxVersion)")
        
        // 保存当前版本号
        NSUserDefaults.standardUserDefaults().setDouble(currentVersion, forKey: sandboxVersionKey)
        
        // 对比
        return currentVersion > sandboxVersion
    }
    
    /**
    切换根控制器
    - parameter isMain: isMain : true 切换到MainController; false:切换到welcomeController
    */
    func switchRootController(isMain: Bool) {
        window?.rootViewController = isMain ? YHTabBarController() : YHWelconeViewController()
    }

    /// 设置全局外观
    private func setupAppearance() {
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        UITabBar.appearance().tintColor = UIColor.orangeColor()
    }

}

