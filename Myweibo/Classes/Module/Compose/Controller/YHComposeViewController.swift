//
//  YHComposeViewController.swift
//  Myweibo
//
//  Created by mposthh on 15/11/4.
//  Copyright © 2015年 mposhh. All rights reserved.
//

import UIKit
import SVProgressHUD

class YHComposeViewController: UIViewController {

    // MARK: - 属性
    /// toolBar顶部约束
    var toolBarBottomCons: NSLayoutConstraint?
    /// 微博文本最大长度
    private let statusMaxLength = 20
    /// 照片选择器的底部约束
    private var photoSelectorViewBottomCons:NSLayoutConstraint?
    
    
    // MARK: - 控制器方法
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置背景色
        view.backgroundColor = UIColor.whiteColor()
        
        prepareUI()
        
        // 添加键盘frame改变的通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "KeyboardWillChangeFrame:", name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // 判断照片选择器是否正在显示
        if photoSelectorViewBottomCons != 0 {
            // 主动弹出键盘
            textView.becomeFirstResponder()
        }
    }
    
    // 注销通知
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - 准备UI
    private func prepareUI() {
        // 添加子控件
        view.addSubview(textView)
        view.addSubview(photoSelectorVC.view)
        view.addSubview(toolBar)
        
        // 设置导航栏
        setupNavigationBar()
        // 设置textView
        setupTextView()
        // 照片选择视图
        preparePhotoSelectorView()
        // 设置toolBar
        setupToolBar()
        // 微博剩余长度label
        prepareLengthTipLabel()
        
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
        
        
        // 添加约束
        let cons = toolBar.ff_AlignInner(type: ff_AlignType.BottomLeft, referView: view, size: CGSize(width: UIScreen.width(), height: 44))
        // 获得底部约束
        toolBarBottomCons = toolBar.ff_Constraint(cons, attribute: NSLayoutAttribute.Bottom)
        
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
        
        
        // 添加约束
        textView.ff_AlignInner(type: ff_AlignType.TopLeft, referView: view, size: nil)
        textView.ff_AlignVertical(type: ff_AlignType.TopRight, referView: toolBar, size: nil)
    }
    
    /// 设置微博内容长度label
    private func prepareLengthTipLabel() {
        // 添加子控件
        view.addSubview(lengthTipLabel)
        
        // 添加约束
        lengthTipLabel.ff_AlignVertical(type: ff_AlignType.TopRight, referView: toolBar, size: nil, offset: CGPoint(x: -8, y: -8))
        // 设置内容
        lengthTipLabel.text = "\(statusMaxLength)"
    }
    
    /// 准备照片选择器视图
    private func preparePhotoSelectorView() {
        
        let photoSelectorView = photoSelectorVC.view
        // 添加约束
        photoSelectorView.translatesAutoresizingMaskIntoConstraints = false
        let viewDict = ["psv": photoSelectorView]
        
        // 左右与父控件重合
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[psv]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        // 底部与父控件重合
        let photoSelectorBottomCons = NSLayoutConstraint(item: photoSelectorView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: UIScreen.height() * 0.6)
        view.addConstraint(photoSelectorBottomCons)
        self.photoSelectorViewBottomCons = photoSelectorBottomCons
        
        // 高度
        view.addConstraint(NSLayoutConstraint(item: photoSelectorView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Height, multiplier: 0.6, constant: 0))
        
    }
    
    // MARK: - 键盘frame改变的方法
    func KeyboardWillChangeFrame(notifiction: NSNotification) {
        // 获取键盘的最终frame
        let endFrame = notifiction.userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue
        toolBarBottomCons?.constant = -(UIScreen.height() - endFrame.origin.y)
        
        // 获取动画时间
        let duration = notifiction.userInfo![UIKeyboardAnimationDurationUserInfoKey]!.doubleValue
        // 动画弹出
        UIView.animateWithDuration(duration) { () -> Void in
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    // MARK: - 懒加载
    /// toolBar
    private lazy var toolBar: UIToolbar = {
       
        let toolBar = UIToolbar()
        // 设置背景
        toolBar.backgroundColor = UIColor(white: 0.8, alpha: 1)
        return toolBar
    }()
    
    /// textView
    private lazy var textView: YHPlaceholderTextView = {
        // 创建
        let textView = YHPlaceholderTextView()
        // 设置contentInset
//        textView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        textView.alwaysBounceVertical = true
        textView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        textView.font = UIFont.systemFontOfSize(16)
        textView.placeholder = "分享新鲜事..."
        
        textView.delegate = self
        
        return textView
    }()
    
    /// 表情输入键盘控制器
    private lazy var emoticonVC: EmoticonViewController = {
       
        let vc = EmoticonViewController()
        self.addChildViewController(vc)
        vc.textView = self.textView
        return vc
    }()
    
    /// 照片选择器
    private lazy var photoSelectorVC: YHPhotoSelectorViewController = {
        let vc = YHPhotoSelectorViewController()
        self.addChildViewController(vc)
        return vc
    }()
    
    /// 剩余微博文本长度标签
    private lazy var lengthTipLabel = UILabel(textColor: UIColor.lightGrayColor(), fontSize: 12)
    
    
    // MARK: - 按钮点击事件
    // toolBar点击事件
    func picture() {
        print("图片")
        
        // 显示照片选择器
        self.photoSelectorViewBottomCons?.constant = 0
        // 隐藏键盘
        textView.resignFirstResponder()
        // 动画
        UIView.animateWithDuration(0.25) { () -> Void in
            self.view.layoutIfNeeded()
        }
    }
    func trend() {
        print("#")
    }
    func mention() {
        print("@")
    }
    func emoticon() {
        print("表情")
        // 先让键盘退回去
        textView.resignFirstResponder()
        
        // 延迟0.25s
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(250 * USEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in
            // 切换键盘
            self.textView.inputView = self.textView.inputView == nil ? self.emoticonVC.view : nil
            // 再让键盘回来
            self.textView.becomeFirstResponder()
        }
    }
    func add() {
        print("加号")
    }
    
    // 导航栏按钮点击事件
    // 取消
    @objc private func close() {
        textView.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    // 发送
    @objc private func sendStatus() {
        print(__FUNCTION__)
        // 获取textView的文本内容
        let status = textView.emoticonText()
        
        // 判断如果文字超过最大长度,提示用户
        if status.characters.count > statusMaxLength {
            SVProgressHUD.showErrorWithStatus("微博内容超出长度", maskType: SVProgressHUDMaskType.Black)
            return
        }
        
        // 显示正在发送
        SVProgressHUD.showWithStatus("正在发送微博", maskType: SVProgressHUDMaskType.Black)
        
        // 调用网络工具类发送微博
        Networktools.shareInstance.sendStatus(status) { (result, error) -> () in
            if error != nil {
                print("error:\(error)")
                SVProgressHUD.showErrorWithStatus("网络繁忙,发送失败", maskType: SVProgressHUDMaskType.Black)
                return
            }
            // 关闭提示
            SVProgressHUD.dismiss()
            // 提示成功
            SVProgressHUD.showSuccessWithStatus("发送成功")
            // 关闭
            self.close()
        }
    }
}

// MARK: - 扩展实现UITextViewDelegate方法
extension YHComposeViewController: UITextViewDelegate {
    // 文字改变代理方法
    func textViewDidChange(textView: UITextView) {
        navigationItem.rightBarButtonItem?.enabled = true
        
        // 计算剩余文本长度
        let text = textView.emoticonText()
        
        let length = statusMaxLength - text.characters.count
        
        // 改变文本内容
        lengthTipLabel.text = "\(length)"
        
        // 改变颜色
        lengthTipLabel.textColor = length < 0 ? UIColor.redColor() : UIColor.lightGrayColor()
    }
}
