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
    
    
    // MARK: - 控制器相关方法
    /// 加载微博数据
    @objc private func loadStatus() {
        print("开始加载微博数据")
        
        var since_id = statuses?.first?.id ?? 0
        var max_id = 0
        
        // 菊花正在转,表示上拉加载数据
        if pullUpView.isAnimating() {
            // 清空 since_id
            since_id = 0
            
            // max_id等于最后一条微博的id
            max_id = statuses?.last?.id ?? 0
            
        }
        
        YHStatus.loadStatus(since_id, max_id: max_id) { (list, error) -> () in
            
            // 结束动画
            self.refreshControl?.endRefreshing()
            
            // 停止上拉加载的菊花
            self.pullUpView.stopAnimating()
            
            // 判断是否加载成功
            if error != nil {
                SVProgressHUD.showErrorWithStatus("加载微博数据出错", maskType: SVProgressHUDMaskType.Black)
                return
            }
            
            let count = list?.count ?? 0
            
            // 显示下拉刷新加载了多少条微博
            if since_id > 0 {
                self.showPullUpTip(count)
            }
            
            // 如果没有加载到微博,不要往下执行
            if count == 0 {
                print("没有新的微博")
                return
            }
            
            if since_id > 0 {
                // 如果是下拉刷新,将加载到的数据添加到现有数据的前面
                print("下拉刷新,加载\(count)条数据")
                self.statuses = list! + self.statuses!
            } else if max_id > 0 {
                print("上拉加载,加载\(count)条数据")
                self.statuses = self.statuses! + list!
            } else {
                // 如果是第一次加载,将数据赋值给模型数组
                self.statuses = list
            }
            
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
        
        // 注册cell的点击通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "pictureSelected:", name: YHStatusPictureViewCellSelectedPictureNotification, object: nil)
        
        // 添加下拉刷新事件
        refreshControl?.addTarget(self, action: "loadStatus", forControlEvents: UIControlEvents.ValueChanged)
        
        // 刚进入首页时调用刷新
        refreshControl?.sendActionsForControlEvents(UIControlEvents.ValueChanged)
    }
    
    deinit {
        // 注销通知
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /// cell点击的响应方法
    func pictureSelected(notification: NSNotification) {
        
        // 获取参数
        guard let urls = notification.userInfo?[YHStatusPictureViewCellSelectedPictureURLKey] as? [NSURL] else {
            print("没有urls")
            return
        }
        guard let indexPath = notification.userInfo?[YHStatusPictureViewCellSelectedPictureIndexPathKey] as? NSIndexPath else {
            print("没有indexPath")
            return
        }
        
        // 弹出照片浏览器
        let controller = YHPhotoBrowserViewController(urls: urls, indexPath: indexPath)
        
        presentViewController(controller, animated: true, completion: nil)
        
    }
    
    
    /// 设置tableview相关属性
    func prepareTableView() {
        // 注册可重用的cell
        tableView.registerClass(YHStatusNormalCell.self, forCellReuseIdentifier: YHStatusCellReuseIdentifier.NormalCell.rawValue)
        tableView.registerClass(YHStatusForwardCell.self, forCellReuseIdentifier: YHStatusCellReuseIdentifier.ForwarCell.rawValue)
        
        // 取消分割线
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        // 设置下拉刷新的菊花
        refreshControl = YHRefreshContro()
        
        // 设置上拉加载的菊花
        tableView.tableFooterView = pullUpView
    }
    
    /**
    显示加载多少条数据.只在下拉刷新数据的时候调用
    - parameter count: 条数
    */
    private func showPullUpTip(count: Int) {
        tipLabel.text = count == 0 ? "没有新的微博" : "加载了\(count)条微博"
        
        let duration = 0.75
        // 记录动画起始frame
        let srcFrame = tipLabel.frame
        // 开始动画
        UIView.animateWithDuration(duration, animations: { () -> Void in
            // 动画下来
            self.tipLabel.frame.origin.y = self.navigationController!.navigationBar.frame.size.height
            }) { (_) -> Void in
                UIView.animateWithDuration(duration, delay: 0.3, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
                    
                    self.tipLabel.frame = srcFrame
                    }, completion: { (_) -> Void in
                        
                })
        }
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
        // 设置微博模型
        cell.status = status
        
        // 当cell是最后一个时,加载更多数据
        if indexPath.row == statuses!.count - 1 && !pullUpView.isAnimating() {
            
            print("上拉加载更多数据")
            pullUpView.startAnimating()
            // 加载数据
            loadStatus()
        }
        
        
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
    /// 标题栏
    private lazy var titleButton: YHHomeTitleView = {
        let name = YHUserAccount.loadAccount()?.name
        let button = YHHomeTitleView(title: name)
        // 添加点击事件
        button.addTarget(self, action: "titleButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }()
    
    /// 上拉加载控件
    private lazy var pullUpView: UIActivityIndicatorView = {
        // 创建
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        // 设置颜色
        indicator.color = UIColor.grayColor()
        
        return indicator
    }()
    
    /// 下拉刷新提示label
    private lazy var tipLabel: UILabel = {
       
        let tipLabelHeight: CGFloat = 30
        
        let tipLabel = UILabel(frame: CGRect(x: 0, y: -20 - tipLabelHeight, width: UIScreen.width(), height: tipLabelHeight))
        tipLabel.backgroundColor = UIColor.orangeColor()
        tipLabel.textColor = UIColor.whiteColor()
        tipLabel.textAlignment = NSTextAlignment.Center
        tipLabel.font = UIFont.systemFontOfSize(15)
        tipLabel.alpha = 0.85
        self.navigationController?.navigationBar.insertSubview(tipLabel, atIndex: 0)
        
        return tipLabel
        
    }()

}
