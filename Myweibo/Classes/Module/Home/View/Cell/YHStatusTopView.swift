//
//  YHStatusTopView.swift
//  Myweibo
//
//  Created by mposthh on 15/11/1.
//  Copyright © 2015年 mposhh. All rights reserved.
//

import UIKit

class YHStatusTopView: UIView {

    // MARK: - 属性
    /// 微博模型
    var status: YHStatus? {
        didSet {
            // 设置view的内容
            // 设置头像
            if let url = status?.user?.profileImageUrl {
                iconView.sd_setImageWithURL(url)
            }
            
            // 设置用户名称
            nameLabel.text = status?.user?.name
            
            // 设置时间标签
            timeLabel.text = status?.created_at
            
            // 微博来源
            sourceLabel.text = "来自iPhone6s"
            
            // 会员等级
            memberView.image = status?.user?.mbrankImage
            
            // 认证图标
            verifiedView.image = status?.user?.verifiedTyperImage
            
        }
    }
    
    // MARK: - 构造函数
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = UIColor.brownColor()
        prepareUI()
    }
    
    // MARK: - 准备UI
    private func prepareUI() {
        // 1.添加子控件
        addSubview(iconView)
        addSubview(nameLabel)
        addSubview(timeLabel)
        addSubview(sourceLabel)
        addSubview(verifiedView)
        addSubview(memberView)
        addSubview(topSeparatorView)
        
        // 2.添加约束
        // 用户头像
        iconView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: topSeparatorView, size: CGSize(width: 35, height: 35), offset: CGPoint(x: 8, y: 8))
        // 用户名称
        nameLabel.ff_AlignHorizontal(type: ff_AlignType.TopRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 0))
        // 时间标签
        timeLabel.ff_AlignHorizontal(type: ff_AlignType.BottomRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 0))
        // 来源标签
        sourceLabel.ff_AlignHorizontal(type: ff_AlignType.CenterRight, referView: timeLabel, size: nil, offset: CGPoint(x: 10, y: 0))
        // 会员等级图标
        memberView.ff_AlignHorizontal(type: ff_AlignType.CenterRight, referView: nameLabel, size: CGSize(width: 14, height: 14), offset: CGPoint(x: 10, y: 0))
        // 认证图片
        verifiedView.ff_AlignInner(type: ff_AlignType.BottomRight, referView: iconView, size: CGSize(width: 17, height: 17), offset: CGPoint(x: 8.5, y: 8.5))
        // 顶部分割视图
        topSeparatorView.ff_AlignInner(type: ff_AlignType.TopLeft, referView: self, size: CGSize(width: UIScreen.width(), height: 10))
    }
    
    // MARK: - 懒加载控件
    // 用户头像
    private lazy var iconView: UIImageView = UIImageView()
    // 用户名称
    private lazy var nameLabel = UILabel(textColor: UIColor.darkGrayColor(), fontSize: 14)
    // 时间标签
    private lazy var timeLabel = UILabel(textColor: UIColor.orangeColor(), fontSize: 9)
    // 来源标签
    private lazy var sourceLabel = UILabel(textColor: UIColor.lightGrayColor(), fontSize: 9)
    // 认证图片
    private lazy var verifiedView = UIImageView()
    // 会员等级图标
    private lazy var memberView = UIImageView()
    /// 顶部分割视图
    private lazy var topSeparatorView: UIView  = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.9, alpha: 0.9)
        return view
    }()
    
}
