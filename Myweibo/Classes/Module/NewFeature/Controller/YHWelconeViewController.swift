//
//  YHWelconeViewController.swift
//  Myweibo
//
//  Created by mposthh on 15/10/30.
//  Copyright © 2015年 mposhh. All rights reserved.
//

import UIKit
import SDWebImage

class YHWelconeViewController: UIViewController {

    // MARK: - 属性
    private var iconViewBottomCons: NSLayoutConstraint?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUI()
        
        // 设置头像图片
        if let urlString = YHUserAccount.loadAccount()?.avatar_large {
            iconView.sd_setImageWithURL(NSURL(string: urlString), placeholderImage: UIImage(named: "avatar_default_big"))
        }
    }
    

    // MARK: - 头像动画
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        moveAnimation()
    }
    /// 头像动画，从下到上
    func moveAnimation() {
        iconViewBottomCons?.constant = -(UIScreen.mainScreen().bounds.height - 160)
        
        // 开始动画
        UIView.animateWithDuration(1.0, delay: 0.1, usingSpringWithDamping: 0.6, initialSpringVelocity: 5, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            self.view.layoutIfNeeded()
            }, completion: { (_) -> Void in
                UIView.animateWithDuration(1.0, animations: { () -> Void in
                    self.nameLabel.alpha = 1.0
                    }, completion: { (_) -> Void in
                        // 切换到主控制器
                        (UIApplication.sharedApplication().delegate as! AppDelegate).switchRootController(true)
                })
        })
    }
    
    // MARK: - 准备UI
    private func prepareUI() {
        // 添加子控件
        view.addSubview(backgroundImageView)
        view.addSubview(iconView)
        view.addSubview(nameLabel)
        
        // 添加约束
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        iconView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 背景
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[bgView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["bgView": backgroundImageView]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[bgView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["bgView": backgroundImageView]))
        
        // 头像
        view.addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        
        view.addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 85))
        
        view.addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 85))
        
        // 垂直 底部160
        iconViewBottomCons = NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -160)
        view.addConstraint(iconViewBottomCons!)
        
        // 欢迎归来
        view.addConstraint(NSLayoutConstraint(item: nameLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: nameLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 16))
    }
    
    // MARK: - 懒加载控件
    
    /// 背景图片
    private lazy var backgroundImageView: UIImageView = {
        // 加载图片
        let imageView = UIImageView(image: UIImage(named: "ad_background"))
        return imageView
    }()
    
    /// 用户头像
    private lazy var iconView: UIImageView = {
        // 加载图片
        let imageView = UIImageView(image: UIImage(named: "avatar_default_big"))
        // 设置圆角
        imageView.layer.cornerRadius = 42.5
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    /// 用户名称
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "欢迎回来"
        label.sizeToFit()
        label.alpha = 0.0
        return label
    }()
    

}
