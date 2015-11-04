//
//  YHHomeController.swift
//  Myweibo
//
//  Created by mposthh on 15/10/26.
//  Copyright © 2015年 mposhh. All rights reserved.
//

import UIKit
import SVProgressHUD

// 枚举,管理cell的重用标示
enum YHStatusCellReuseIdentifier: String {
    case NormalCell = "NormalCell"
    case ForwarCell = "ForwarCell"
}

class YHHomeController: YHBaseController {

    // MARK: - 属性
    /// 模型数组
    var statuses: [YHStatus]? {
        didSet {
            tableView.reloadData()
            
        }
    }
    // cell的重用标识
//    private let homeCellReuseIdentifier = "homeCellReuseIdentifier"
    
    
    /// 加载微博数据
    @objc private func loadStatus() {
        print("开始加载微博数据")
        
        let since_id = statuses?.first?.id ?? 0
        let max_id = 0
        
        YHStatus.loadStatus(since_id, max_id: max_id) { (list, error) -> () in
            // 判断是否加载成功
            if error != nil {
                SVProgressHUD.showErrorWithStatus("加载微博数据出错", maskType: SVProgressHUDMaskType.Black)
                return
            }
            if since_id > 0 {
                // 如果是下拉刷新,将加载到的数据添加到现有数据的前面
                self.statuses = list! + self.statuses!
            } else {
                // 如果是第一次加载,将数据赋值给模型数组
                self.statuses = list
            }
            
            self.refreshControl?.endRefreshing()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置NavigationBar
        setNavigationBar()
        // 设置标题
        navigationItem.titleView = titleButton
        
        // 设置tableview相关属性
        prepareTableView()
        
        // 加载微博数据
//        loadStatus()
        
        // 添加下拉刷新事件
        refreshControl?.addTarget(self, action: "loadStatus", forControlEvents: UIControlEvents.ValueChanged)
        
        // 刚进入首页时调用刷新
        refreshControl?.sendActionsForControlEvents(UIControlEvents.ValueChanged)
    }
    
    /// 设置tableview相关属性
    func prepareTableView() {
        // 注册可重用的cell
        tableView.registerClass(YHStatusNormalCell.self, forCellReuseIdentifier: YHStatusCellReuseIdentifier.NormalCell.rawValue)
        tableView.registerClass(YHStatusForwardCell.self, forCellReuseIdentifier: YHStatusCellReuseIdentifier.ForwarCell.rawValue)
        
        // 取消分割线
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        // 设置菊花
        refreshControl = YHRefreshContro()
        
    }
    
    // MARK: - tableView数据源和代理方法
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // 获得模型
        let status = statuses?[indexPath.row]
        // 创建cell
        let cell = tableView.dequeueReusableCellWithIdentifier(status!.cellID(), forIndexPath: indexPath) as! YHStatusCell
        
        cell.status = status
        
        return cell
    }
    
    // 返回cell的高度
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // 获取status
        let status = statuses?[indexPath.row]
        
        // 判断模型是否有缓存的行高
        if let rowHeight = status?.rowHeight {
            // 如果有行高,直接返回
//            print("使用缓存行高")
            return rowHeight
        }
        // 获取cell
        let cell = tableView.dequeueReusableCellWithIdentifier(status!.cellID()) as! YHStatusCell
        // 使用cell计算行高
        let rowHeight = cell.rowHeight(status!)
//        print("计算行高: \(indexPath)")
        // 缓存行高
        status!.rowHeight = rowHeight
        
        return rowHeight
    }
    // 预估行高
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 300
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
