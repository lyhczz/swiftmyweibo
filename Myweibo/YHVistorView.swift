//
//  YHVistorView.swift
//  Myweibo
//
//  Created by mposthh on 15/10/27.
//  Copyright © 2015年 mposhh. All rights reserved.
//

import UIKit

class YHVistorView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 准备UI
        prepareUI()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
    不同页面设置不同信息
    首页不用设置
    - parameter imageName: 图片名称
    - parameter titlt:     消息文字
    */
    func setupInfo(imageName:String,titlt:String) {
        
        iconView.image = UIImage(named: imageName)
        messageLabel.text = titlt
        messageLabel.sizeToFit()
        
        // 隐藏小房子
        homeView.hidden = true
        
        // 遮盖放到最小面
        sendSubviewToBack(converView)
    }
    
    /// 旋转动画
    func startRotationAnimation() {
        // 创建动画
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue = 2 * M_PI
        animation.duration = 20
        animation.repeatCount = MAXFLOAT
        animation.removedOnCompletion = false
        
        iconView.layer.addAnimation(animation, forKey: "homeRotation")
        
    }

    // MARK: - 准备UI
    private func prepareUI() {
        // 添加子控件
        addSubview(iconView)
        // 添加遮罩视图
        addSubview(converView)
        
        addSubview(homeView)
        addSubview(messageLabel)
        addSubview(registerButton)
        addSubview(loginButton)
        // 设置背景颜色
        backgroundColor = UIColor(white: 237 / 255, alpha: 1)
        
        // 设置布局
        iconView.translatesAutoresizingMaskIntoConstraints = false
        homeView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        converView.translatesAutoresizingMaskIntoConstraints = false
        
        
        // iconView
        addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: -40))
        
        // 房子
        addConstraint(NSLayoutConstraint(item: homeView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: homeView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
        
        // 消息label
        addConstraint(NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 16))
        addConstraint(NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 224))
        
        // 注册按钮
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: messageLabel, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: messageLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 16))
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 100))
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 35))
        
        // 登陆按钮
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: messageLabel, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: messageLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 16))
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 100))
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 35))
        
        // 遮盖视图
        addConstraint(NSLayoutConstraint(item: converView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: converView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: converView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: registerButton, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0))
    }
    
    // MARK: - 控件懒加载
    /// 转轮
    private lazy var iconView: UIImageView = {
        
        let image = UIImage(named: "visitordiscover_feed_image_smallicon")
        return UIImageView(image: image)
    }()
    
    /// 房子
    private lazy var homeView:UIImageView = {
        let image = UIImage(named: "visitordiscover_feed_image_house")
        return UIImageView(image: image)
    }()
    
    /// 文字标签
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "关注一些人,看看有什么惊喜关注一些人,看看有什么惊喜"
        label.numberOfLines = 0
        label.textColor = UIColor.lightGrayColor()
        label.sizeToFit()
        return label
    }()
    
    /// 注册按钮
    private lazy var registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("注册", forState: UIControlState.Normal)
        button.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        return button
    }()
    
    /// 登陆按钮
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("登陆", forState: UIControlState.Normal)
        button.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        return button
        }()
    
    // 遮盖视图
    private lazy var converView: UIImageView = {
        let image = UIImage(named: "visitordiscover_feed_mask_smallicon")
        return UIImageView(image: image)
    }()
}









