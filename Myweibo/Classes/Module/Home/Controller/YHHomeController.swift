//
//  YHHomeController.swift
//  Myweibo
//
//  Created by mposthh on 15/10/26.
//  Copyright © 2015年 mposhh. All rights reserved.
//

import UIKit
import SVProgressHUD

class YHHomeController: YHBaseController {

    // MARK: - 属性
    /// 模型数组
    var statuses: [YHStatus]? {
        didSet {
            tableView.reloadData()
            
        }
    }
    // cell的重用标识
    private let homeCellReuseIdentifier = "homeCellReuseIdentifier"
    
    
    /// 加载微博数据
    private func loadStatus() {
        print("开始加载微博数据")
        YHStatus.loadStatus { (list, error) -> () in
            // 判断是否加载成功
            if error != nil {
                SVProgressHUD.showErrorWithStatus("加载微博数据出错", maskType: SVProgressHUDMaskType.Black)
                return
            }
            // 将数据赋值给模型数组
            self.statuses = list
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置NavigationBar
        setNavigationBar()
        // 设置标题
        navigationItem.titleView = titleButton
        // 加载微博数据
        loadStatus()
        // 注册可重用的cell
        tableView.registerClass(YHStatusCell.self, forCellReuseIdentifier: homeCellReuseIdentifier)
        // 设置行高
        tableView.rowHeight = 100
        // 取出分割线
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
//         //设置预估行高
//        tableView.estimatedRowHeight = 300
//        // 自动计算行高
//        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    // MARK: - tableView数据源和代理方法
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(homeCellReuseIdentifier, forIndexPath: indexPath) as! YHStatusCell
        
//        cell.textLabel?.text = statuses?[indexPath.row].text
        cell.status = statuses?[indexPath.row]
        
        return cell
    }
    
    // 返回cell的高度
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // 获取status
        let status = statuses?[indexPath.row]
        
        // 判断模型是否有缓存的行高
        if let rowHeight = status?.rowHeight {
            // 如果有行高,直接返回
            print("使用缓存行高")
            return rowHeight
        }
        // 获取cell
        let cell = tableView.dequeueReusableCellWithIdentifier(homeCellReuseIdentifier) as! YHStatusCell
        // 使用cell计算行高
        let rowHeight = cell.rowHeight(status!)
        print("计算行高: \(indexPath)")
        // 缓存行高
        status!.rowHeight = rowHeight
        
        return rowHeight
    }
    // 预估行高
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
    }
    
    
    // MARK: - 设置标题栏相关方法
    // 按钮点击事件，改变箭头方向
    @objc private func titleButtonClick() {
        // 改变按钮的选中状态
        titleButton.selected = !titleButton.selected
        
        // 选中状态，使箭头朝上
        if titleButton.selected {
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                titleButton.imageView?.transform = CGAffineTransformMakeRotation(CGFloat(M_PI - 0.01))
            })
        } else {
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                titleButton.imageView?.transform = CGAffineTransformIdentity
            })
        }
    }
    
    /// 设置导航栏按钮
    private func setNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendsearch")
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop")
    }
    
    // MARK: - 懒加载控件
    lazy var titleButton: YHHomeTitleView = {
        let name = YHUserAccount.loadAccount()?.name
        let button = YHHomeTitleView(title: name)
        // 添加点击事件
        button.addTarget(self, action: "titleButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }()

}
