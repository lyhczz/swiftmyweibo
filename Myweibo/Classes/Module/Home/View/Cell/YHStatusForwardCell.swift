//
//  YHStatusForwardCell.swift
//  Myweibo
//
//  Created by mposthh on 15/11/2.
//  Copyright © 2015年 mposhh. All rights reserved.
//

import UIKit

class YHStatusForwardCell: YHStatusCell {

    /// 微博模型
    override var status: YHStatus? {
        didSet {
            // 设置转发微博内容
            let name = status?.retweeted_status?.user?.name ?? "名称为空"
            let text = status?.retweeted_status?.text ?? "转发微博内容为空"
            forwarLabel.text = "@\(name): \(text)"
        }
    }
    
    // 重写父类的prepareUI方法
    override func prepareUI() {
        super.prepareUI()
        
        // 测试数据
//        forwarLabel.text = "我是转发微博我是转发微博我是转发微博我是转发微博我是转发微博"
        
        // 添加子控件
        contentView.insertSubview(backButton, belowSubview: pictureView)
        contentView.addSubview(forwarLabel)
        
        // 添加约束
        backButton.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: contentLabel, size: nil, offset: CGPoint(x: -statusCellMargin, y: statusCellMargin))
        backButton.ff_AlignVertical(type: ff_AlignType.TopRight, referView: bottomView, size: nil)
        
        // 被转发微博的内容
        forwarLabel.ff_AlignInner(type: ff_AlignType.TopLeft, referView: backButton, size: nil, offset: CGPoint(x: statusCellMargin, y: statusCellMargin))
        
        
        //微博配图
        let con = pictureView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: forwarLabel, size: CGSize(width: 290, height: 290), offset: CGPoint(x: 0, y: statusCellMargin))
        
        // 获取微博配图的宽高约束
        pictureViewWidthCon = pictureView.ff_Constraint(con, attribute: NSLayoutAttribute.Width)
        pictureViewheightCon = pictureView.ff_Constraint(con, attribute: NSLayoutAttribute.Height)
    }
    
    // MARK: - 懒加载控件
    /// 被转发的微博内容
    private lazy var forwarLabel: UILabel = {
        // 创建label
        let label = UILabel()
        // 设置属性
        label.numberOfLines = 0
        label.font = UIFont.systemFontOfSize(14)
        label.textColor = UIColor(white: 0.2, alpha: 1)
        // 设置宽度
        label.preferredMaxLayoutWidth = UIScreen.width() - self.statusCellMargin * 2
        
        return label
    }()
    
    /// 被转发的微博背景
    private lazy var backButton: UIButton = {
       let button = UIButton()
        
        button.backgroundColor = UIColor(white: 0.91, alpha: 1)
        return button
        
    }()

}
